# 第 18 题：非极大值抑制（NMS）与手写实现

## 题目

什么是非极大值抑制（NMS）？手写 NMS 代码（Python/C++）。

---

## 一、为什么需要 NMS？

检测器在**密集预测**时，同一物体会被**多个框**覆盖（不同 anchor、不同格点、不同尺度），最终会得到大量重叠框。NMS 的作用是：**在同一类别内，按置信度排序，保留高置信度框，抑制与其 IoU 过高的其他框**，从而每个物体只保留一个代表框。

---

## 二、NMS 的流程（单类别）

1. 输入：同一类别的框列表，每个框含 $(x1, y1, x2, y2, \mathrm{score})$。
2. 按 **score 从高到低**排序。
3. 取当前**最高分**的框，加入输出，并删除与该框 **IoU > 阈值**（如 0.5）的所有其他框。
4. 在剩余框里重复步骤 3，直到没有剩余框。

多类别：对每个类别分别做一次上述 NMS；或先做跨类别过滤再按类 NMS。

---

## 三、IoU 计算

两个框 $A=(x1_a,y1_a,x2_a,y2_a)$、$B=(x1_b,y1_b,x2_b,y2_b)$：

- 交集：$x1_i = \max(x1_a, x1_b)$，$y1_i = \max(y1_a, y1_b)$，$x2_i = \min(x2_a, x2_b)$，$y2_i = \min(y2_a, y2_b)$。  
  若 $x1_i \ge x2_i$ 或 $y1_i \ge y2_i$，交集为 0。  
  否则 $\mathrm{area}_i = (x2_i - x1_i) \times (y2_i - y1_i)$。
- 并集：$\mathrm{area}_a + \mathrm{area}_b - \mathrm{area}_i$。
- $\mathrm{IoU} = \mathrm{area}_i / \mathrm{并集}$。

---

## 四、Python 手写 NMS（核心逻辑）

```python
def nms(boxes, scores, iou_threshold=0.5):
    # boxes: (N, 4) [x1, y1, x2, y2], scores: (N,)
    order = scores.argsort()[::-1]  # 从高到低
    keep = []
    while order.size > 0:
        i = order[0]
        keep.append(i)
        if order.size == 1:
            break
        # 当前框与剩余框的 IoU
        xx1 = np.maximum(boxes[i, 0], boxes[order[1:], 0])
        yy1 = np.maximum(boxes[i, 1], boxes[order[1:], 1])
        xx2 = np.minimum(boxes[i, 2], boxes[order[1:], 2])
        yy2 = np.minimum(boxes[i, 3], boxes[order[1:], 3])
        w = np.maximum(0, xx2 - xx1)
        h = np.maximum(0, yy2 - yy1)
        inter = w * h
        area_i = (boxes[i,2]-boxes[i,0])*(boxes[i,3]-boxes[i,1])
        area_o = (boxes[order[1:],2]-boxes[order[1:],0])*(boxes[order[1:],3]-boxes[order[1:],1])
        iou = inter / (area_i + area_o - inter)
        # 保留 IoU <= 阈值的
        inds = np.where(iou <= iou_threshold)[0]
        order = order[inds + 1]
    return keep
```

---

## 五、Soft-NMS 与变体（简述）

- **Soft-NMS**：不直接删掉高 IoU 的框，而是按 IoU 给其 score **打折**（如乘以衰减函数），减少漏检。
- **IoU 阈值**：常用 0.5；过高保留多框、过低易删真阳性。

---

## 六、小结与面试要点

**小结**：NMS 按分数排序，逐次保留最高分框并抑制与其 IoU 超过阈值的框；手写需会算 IoU 与索引维护。

**面试要点**：能口述流程；会写 IoU；会写“排序→取最高→删高 IoU→重复”；注意边界（无交集时 IoU=0）。

---

## 记忆要点

1. 流程：按 score 排序 → 取最高 → 删 IoU>阈值的 → 重复。
2. IoU = 交/并；交 = max(0, 重叠宽高) 的积。
3. 手写时用 argsort 降序、用切片维护剩余 order。
4. Soft-NMS：对重叠框降权而非删除。

---

*上一篇：[第 17 题 - ROI Align 与 ROI Pooling](./17-ROI-Align与ROI-Pooling.md)*  
*下一篇：[第 19 题 - 小目标检测与 FPN](./19-小目标检测与FPN.md)*
