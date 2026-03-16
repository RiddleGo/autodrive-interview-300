# 第 16 题：Faster R-CNN 流程与 RPN 的作用

## 题目

简述 Faster R-CNN 的完整流程，RPN 的作用是什么？

---

## 一、Faster R-CNN 整体流程

Faster R-CNN 是 **two-stage** 检测器：先由 **RPN（Region Proposal Network）** 生成候选框，再对候选框做 **RoI 特征提取 + 分类与回归**。

**四步流程**：

1. **骨干网络（Backbone）**：输入图像经 CNN（如 ResNet-50 + FPN）得到多尺度特征图。
2. **RPN**：在特征图上用滑动窗口 + 锚框（anchor）生成**候选区域（proposals）**，并做前景/背景二分类与框回归，输出约 1k–2k 个 proposal。
3. **RoI 池化/对齐**：根据每个 proposal 在特征图上裁出固定大小（如 7×7）的 RoI 特征。
4. **检测头**：对 RoI 特征做**分类（类别 + 背景）**和**边界框回归（refinement）**，得到最终检测结果。

相比 R-CNN、Fast R-CNN，Faster 的改进是**用 RPN 替代了独立的候选框生成（如 Selective Search）**，实现端到端、共享 backbone 特征、速度更快。

---

## 二、RPN 的作用

**RPN 的作用**：在**共享的特征图**上，以**锚框 + 滑动窗口**的方式，快速产出**可能包含物体的候选框**，供第二阶段精分类与精回归。

- **输入**：Backbone 输出的特征图（如 FPN 的多层）。
- **操作**：在每个空间位置预设若干 anchor（不同尺度、比例），对每个 anchor 预测：
  - **二分类**：是前景（object）还是背景；
  - **框回归**：相对 anchor 的偏移 $(dx, dy, dw, dh)$，用于修正 proposal 位置与大小。
- **输出**：按前景分数排序，取 top-K（如 1000–2000）个 proposal，再经 NMS 去重叠，送入第二阶段。

**为什么重要？** 候选框质量直接决定 two-stage 的上限；RPN 与检测头共享 backbone，省去单独提候选的开销，且可端到端训练，是 Faster R-CNN 的核心组件。

---

## 三、RPN 与检测头的训练

- **损失**：RPN 的 loss = 前景/背景分类 loss（如 CE）+ 框回归 loss（如 Smooth L1），仅对正样本 anchor 算回归。
- **正负样本**：与 GT 的 IoU 高为正、低为负；中间区域可忽略。
- **与检测头联合训练**：Faster 常用 4-step 或联合训练，使 RPN 与 RoI head 共享 backbone 并交替或联合更新。

---

## 四、小结与面试要点

**小结**：Faster R-CNN = Backbone → RPN（生成 proposals）→ RoI 池化/对齐 → 检测头（分类 + 框回归）。RPN 负责在特征图上用 anchor 快速产出候选框，实现端到端、共享特征的两阶段检测。

**面试要点**：

- 能说出四步：Backbone、RPN、RoI、检测头。
- RPN 作用：在共享特征上以 anchor 生成候选框，替代 Selective Search，实现端到端。
- RPN 输出：前景/背景分数 + 框回归偏移；NMS 后取 top-K 作为 proposal。

---

## 记忆要点

1. 流程：Backbone → RPN → RoI → 检测头。
2. RPN：anchor + 二分类 + 框回归，产出 proposals。
3. 与 Fast R-CNN 区别：候选框由 RPN 生成，共享特征、端到端。

---

*下一篇：[第 17 题 - ROI Align 与 ROI Pooling](./17-ROI-Align与ROI-Pooling.md)*
