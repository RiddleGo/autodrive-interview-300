# 第 2 题：Batch Normalization 的训练与推理阶段区别

## 题目

Batch Normalization 的训练和推理阶段有何区别？BN 层有哪些可学习参数？

---

## 一、BN 在做什么？

**Batch Normalization（BN）** 对每个**通道/特征维度**，在**当前 batch 的 $N$ 个样本**上做标准化，再乘以可学习缩放 $\gamma$、平移 $\beta$：

- 设某通道在 batch 上的取值为 $x_1,\ldots,x_N$，则：
  - $\mu = \frac{1}{N}\sum_i x_i$，$\sigma^2 = \frac{1}{N}\sum_i (x_i-\mu)^2$
  - $\hat{x}_i = \frac{x_i - \mu}{\sqrt{\sigma^2 + \epsilon}}$
  - 输出 $y_i = \gamma \hat{x}_i + \beta$

**目的**：减轻内部协变量偏移，稳定每层输入分布，允许更大学习率、加速收敛，并有一定正则效果。

---

## 二、训练阶段 vs 推理阶段

| 项目       | 训练阶段                         | 推理阶段                           |
|------------|----------------------------------|------------------------------------|
| **均值/方差** | 用**当前 batch** 的 $\mu$、$\sigma^2$ 计算 | 用训练时维护的 **running mean / running variance**（移动平均） |
| **计算方式** | 前向时算当前 batch 统计，并更新 running | 只做前向：$\hat{x} = \frac{x - \mu_{\mathrm{running}}}{\sqrt{\sigma^2_{\mathrm{running}}}+\epsilon}$ |
| **Batch 大小** | 通常固定（如 32、64）           | 可为 1（单张图推理），不依赖 batch |
| **可学习参数** | $\gamma$、$\beta$ 参与反向传播   | $\gamma$、$\beta$ 固定，仅前向     |

**Running 更新方式**（训练时）：  
$\mu_{\mathrm{running}} \leftarrow (1-\alpha)\,\mu_{\mathrm{running}} + \alpha\,\mu$，$\sigma^2_{\mathrm{running}}$ 同理，$\alpha$ 为动量（常取 0.1）。

**为什么推理不用当前 batch？** 推理时 batch 可能为 1 或很小，单 batch 统计不稳定；且需要**确定性、可复现**的输出，故统一用训练阶段积累的全局统计。

---

## 三、BN 层有哪些可学习参数？

- **可学习参数**：每个通道一组  
  - **$\gamma$（scale）**：$C$ 维，$C$ 为通道数  
  - **$\beta$（shift）**：$C$ 维  

- **不可学习、但需保存的状态**（用于推理）：  
  - **running mean**：$C$ 维  
  - **running variance**：$C$ 维  

因此，若该层有 $C$ 个通道，BN 的**可学习参数量**为 $2C$；若输入为 NCHW，则 $C$ 即 channel 维大小。

---

## 四、小结与面试要点

**小结**：训练时用当前 batch 的均值和方差做标准化，并更新 running 统计；推理时只用 running mean/variance，不依赖当前 batch，保证稳定与可复现。可学习参数仅为 $\gamma$、$\beta$，每通道各一个。

**面试要点**：

- 训练：batch 统计 + 更新 running；推理：仅用 running，无 batch 依赖。
- 可学习参数：$\gamma$、$\beta$，共 $2C$；running mean/var 为状态量，不可学习。
- 追问：“batch=1 时训练会怎样？”——方差估计噪声大，BN 行为不稳定，常配合 BatchNorm→GroupNorm 或 LayerNorm 等替代方案。

---

## 记忆要点

1. 训练：当前 batch 的 $\mu$、$\sigma^2$；推理：running mean、running variance。
2. 可学习参数只有 $\gamma$、$\beta$，共 $2C$。
3. Running 用指数移动平均在训练中更新，推理时固定。
4. 推理时 batch 可为 1，不依赖 batch 大小。

---

*上一篇：[第 1 题 - CNN 归纳偏置](./01-CNN归纳偏置.md)*  
*下一篇：[第 3 题 - BN 输出维度与计算过程](./03-BN输出维度与计算.md)*
