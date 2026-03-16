# 第 6 题：ResNet、DenseNet、EfficientNet 架构对比

## 题目

对比 ResNet、DenseNet、EfficientNet 的架构设计思想与适用场景。

---

## 一、ResNet：残差学习

**核心思想**：通过**残差连接（skip connection）**让梯度直接流过，缓解深层网络的退化与梯度消失，使网络可以堆到上百层。

**公式**：$y = F(x) + x$，其中 $F(x)$ 为卷积等学到的残差，$x$ 为恒等映射。反向时梯度有两条路：$\frac{\partial \mathcal{L}}{\partial x} = \frac{\partial \mathcal{L}}{\partial y}(1 + \frac{\partial F}{\partial x})$，即使 $\frac{\partial F}{\partial x}$ 很小，仍有“1”这条直通路径。

**设计要点**：每个 block 内 3×3→3×3 或 1×1→3×3→1×1（Bottleneck）；先 BN→ReLU→Conv，最后再加 $x$ 再 ReLU。下采样时 $x$ 用 1×1 conv 对齐通道与尺寸。

**适用场景**：通用骨干网络，分类、检测、分割均可；工业界最常用，部署友好。

---

## 二、DenseNet：密集连接

**核心思想**：每一层都与前面**所有层**在通道维拼接（dense connection），特征复用极强，参数量与计算量更省，梯度流动更充分。

**公式**：$x_\ell = H_\ell([x_0, x_1, \ldots, x_{\ell-1}])$，$H_\ell$ 为 BN+ReLU+Conv 等，输入是前面所有层输出的 concat。

**设计要点**：每个 Dense Block 内通道数固定（growth rate $k$），层数多时通道会很大，故 block 之间加 Transition（1×1 降维 + pooling）。参数量小是因为每层只需产生 $k$ 个新通道。

**优点**：特征复用强、参数少、梯度路径多；**缺点**：显存占用大（要存所有中间层用于 concat）、实现与并行不如 ResNet 简单。

**适用场景**：数据量中等、追求精度与参数效率的场景；显存紧张时需谨慎。

---

## 三、EfficientNet：复合缩放

**核心思想**：不单缩放深度或宽度，而是**同时缩放深度 $d$、宽度 $w$、分辨率 $r$**，按一组系数均衡放大，在给定算力下得到更优精度。

**公式**：在 baseline（如 B0）上，$d = \alpha^\phi$，$w = \beta^\phi$，$r = \gamma^\phi$，约束 $\alpha \cdot \beta^2 \cdot \gamma^2 \approx 2$，$\phi$ 为全局缩放系数。通过 NAS 搜出 $\alpha,\beta,\gamma$ 再按 $\phi$ 放大得到 B1–B7。

**设计要点**：backbone 为 MBConv（深度可分离卷积 + SE 注意力）；宽度、深度、分辨率按论文给出的表缩放。

**适用场景**：移动端与边缘设备上在精度与延迟之间做权衡；需要不同规模时选 B0–B7 对应档位。

---

## 四、三者对比小结

| 维度 | ResNet | DenseNet | EfficientNet |
|------|--------|----------|--------------|
| **核心思想** | 残差 $F(x)+x$，梯度直通 | 每层与前面所有层 concat | 深度+宽度+分辨率复合缩放 |
| **特征流动** | 逐层加性 | 密集复用、通道 concat | 逐层 + MBConv |
| **参数量/显存** | 中等 | 参数量小、显存大 | 同精度下更小更高效 |
| **实现与部署** | 简单、最常用 | 显存与实现成本高 | 需按表实现各尺寸 |
| **典型场景** | 通用 backbone、工业部署 | 研究、参数敏感场景 | 移动端、边缘、精度-速度权衡 |

面试常问：“为什么 ResNet 比纯堆卷积好？”——残差提供恒等映射，解决退化与梯度消失；“DenseNet 显存为什么大？”——要保存并 concat 前面所有层；“EfficientNet 好在哪里？”——复合缩放 + NAS，同 FLOPS 下精度更高。

---

## 五、小结与面试要点

**小结**：ResNet 用残差连接解决深层退化；DenseNet 用密集连接强化特征复用、省参数但费显存；EfficientNet 用复合缩放与 NAS 在给定算力下追求更高精度，适合移动与边缘。

**面试要点**：

- ResNet：$y=F(x)+x$，梯度有直通路径，可堆深。
- DenseNet：$x_\ell = H_\ell([x_0..x_{\ell-1}])$，特征复用强、参数量小、显存大。
- EfficientNet：$d,w,r$ 联合缩放，MBConv+SE，B0–B7 按规模选型。

---

## 记忆要点

1. **ResNet**：残差 $F(x)+x$，梯度直通，通用 backbone。
2. **DenseNet**：层间全连接式 concat，省参数、费显存。
3. **EfficientNet**：深度+宽度+分辨率复合缩放，移动端与边缘优选。
4. 选型：通用选 ResNet；参数敏感可考虑 DenseNet；移动/边缘选 EfficientNet。

---

*上一篇：[第 5 题 - 梯度爆炸与裁剪](./05-梯度爆炸与裁剪.md)*  
*下一篇：[第 7 题 - 感受野](./07-感受野.md)*
