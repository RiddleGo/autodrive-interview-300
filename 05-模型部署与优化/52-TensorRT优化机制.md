# 第 52 题：TensorRT 优化的核心机制

## 题目

TensorRT 优化的核心机制？层融合、动态 shape 处理？

---

## 一、TensorRT 概览

**TensorRT**：NVIDIA 的**推理优化引擎**，将 ONNX/PyTorch 等模型**解析、优化、生成**针对 GPU 的高效引擎，降低延迟、提高吞吐。

---

## 二、核心优化机制

**1. 层融合（Layer Fusion）**  
- 把**多个小算子**合并成**一个大 kernel**，减少**显存读写**与 **kernel 启动开销**。  
- 例：Conv+BN+ReLU → 单 kernel；MatMul+Add+Activation → 融合。  
- 效果：带宽与 launch 开销显著下降，尤其小 batch 与轻量层多时。

**2. 精度**  
- **FP16/BF16/INT8**：自动或手动混合精度、INT8 量化（需校准或 QAT 模型），减少算力与带宽。  
- **INT8** 需校准集或 QAT 得到 scale。

**3. 内核自动选择（Kernel Auto-Tuning）**  
- 针对当前 GPU、batch、尺寸等**自动选**最快实现（如不同 tile size、是否用 Tensor Core）。  
- 构建时搜索或使用预选表。

**4. 动态 Shape**  
- **动态 batch/尺寸**：构建时指定**优化 profile**（如 min/opt/max shape），为每个 profile 生成优化引擎；运行时若在 profile 内可直接用，否则需对应 profile 或重建。  
- 动态会略增引擎大小与构建时间，但能适应多分辨率/多 batch。

**5. 内存与调度**  
- **显存复用**：中间结果生命周期分析，复用缓冲区，降低峰值显存。  
- **并行**：多 stream、多请求并行执行，提高吞吐。

---

## 三、小结与面试要点

**小结**：TensorRT 通过层融合、精度（FP16/INT8）、内核选择、动态 shape profile、显存与调度优化等提升推理效率。

**面试要点**：层融合=多算子合一、减带宽与 launch；动态 shape=多 profile；INT8=校准或 QAT。

---

## 记忆要点

1. **层融合**：Conv+BN+ReLU 等合一，减读写与 kernel 数。  
2. **精度**：FP16/INT8，INT8 需校准。  
3. **动态 shape**：min/opt/max profile，多尺寸适配。  
4. 内核自动选择、显存复用、多 stream 提升吞吐。

---

*上一篇：[第 51 题 - 剪枝量化蒸馏](./51-剪枝量化蒸馏.md)*  
*下一篇：[第 53 题 - ONNX 与转换兼容性](./53-ONNX与转换兼容性.md)*
