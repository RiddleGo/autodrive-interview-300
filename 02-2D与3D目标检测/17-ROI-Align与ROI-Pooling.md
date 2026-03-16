# 第 17 题：ROI Align 与 ROI Pooling 的区别

## 题目

解释 ROI Align 与 ROI Pooling 的区别，为什么 Align 精度更高？

---

## 一、为什么需要 RoI 池化/对齐？

在 two-stage 检测里，RPN 给出的 **proposal 大小不一**，而检测头（全连接或小卷积）需要**固定尺寸**的输入（如 7×7）。因此要在特征图上按 proposal 的坐标**裁出区域并 resize 到固定大小**，这一步即 RoI Pooling（早期）或 **RoI Align**（改进版）。

---

## 二、ROI Pooling 的做法与问题

**做法**：
1. 将 proposal 坐标按**特征图相对原图的比例**映射到特征图上的浮点坐标。
2. 把该区域**均匀划分**成 $H \times W$ 个 bin（如 7×7）。
3. 每个 bin 内做**取整**得到整数坐标，对该 bin 内的特征做 **max pooling**（或 average），得到一个值。
4. 得到 $H \times W$ 的输出。

**问题**：
- **两次量化**： proposal 映射到特征图时坐标会**取整**（第一次量化）；每个 bin 的边界再**取整**（第二次量化）。格子边界与真实 proposal 不对齐，**存在系统性偏移**。
- **小目标/小 proposal 更吃亏**： proposal 很小时代表几个像素，取整误差占比例大，框回归与分类都会受影响，**精度损失明显**。

---

## 三、ROI Align 的做法与改进

**做法**：
1. Proposal 映射到特征图时**不做取整**，保留浮点坐标。
2. 将 RoI 区域**均匀划分**成 $H \times W$ 个 bin，每个 bin 内再**均匀采 4 个点**（如 2×2 网格中心或均匀分布）。
3. 每个采样点用**双线性插值**在特征图上取值（不依赖整格子），再对 4 个点做 **max 或 average** 得到该 bin 的一个值。
4. 得到 $H \times W$ 的输出。

**改进点**：
- **无取整**：全程用浮点坐标与双线性插值，**没有量化带来的偏移**，与 proposal 几何对齐更好。
- **子格采样**：每个 bin 内多个采样点 + 插值，比“整个 bin 一个 max”更细，**信息保留更多**，尤其小 RoI。

因此 **Align 精度更高**，尤其在小目标与高 IoU 要求下；Mask R-CNN 论文中明确用 RoI Align 替代 RoI Pooling 做检测与 mask。

---

## 四、小结与面试要点

**小结**：ROI Pooling 在映射与 bin 边界上两次取整，产生对齐误差；ROI Align 保留浮点坐标、bin 内双线性插值采样，无量化、对齐好，精度更高。

**面试要点**：
- Pooling：映射取整 + bin 取整 + max，两次量化。
- Align：无取整 + bin 内 4 点双线性插值 + max/avg，无量化。
- 为何 Align 更准：对齐好、小目标友好、信息更细。

---

## 记忆要点

1. **Pooling**：两次取整，有偏移；**Align**：浮点 + 双线性插值，无取整。
2. Align 在每个 bin 内采多点（如 2×2）再插值。
3. 小目标、高 IoU 场景下 Align 优势明显。
4. Mask R-CNN 起普遍用 Align 替代 Pooling。

---

*上一篇：[第 16 题 - Faster R-CNN 与 RPN](./16-Faster-RCNN与RPN.md)*  
*下一篇：[第 18 题 - NMS 与手写实现](./18-NMS与手写实现.md)*
