# 第 54 题：CUDA Memory Layout 与 NCHW vs NHWC 的性能差异

## 题目

什么是 CUDA Memory Layout？NCHW vs NHWC 的性能差异？

---

## 一、NCHW 与 NHWC

**NCHW**：Batch, Channel, Height, Width；同一 channel 的像素在内存中**连续**。  
**NHWC**：Batch, Height, Width, Channel；同一空间位置的各 channel 在内存中**连续**。

---

## 二、与计算、带宽的关系

**卷积**：  
- **NCHW**：一次读一整 channel 的 2D 块，**对卷积核滑动友好**；CuDNN 等对 NCHW 优化多，**多数框架默认 NCHW**。  
- **NHWC**：一次读同一位置的 C 个通道，对**逐点运算、向量化**友好；Tensor Core 与部分 kernel 在 NHWC 上更易利用**通道维连续**，减少转置。

**带宽**：  
- 访问模式若与 layout 一致则**连续访问**、cache 友好；不一致则易 strided 访问、带宽浪费。  
- **NHWC** 在“按 H,W 遍历、用 C 做向量化”时更自然；**NCHW** 在“按 C 做 2D 卷积”时更自然。

---

## 三、实际选择

- **训练/推理（GPU）**：**NCHW** 仍是主流（PyTorch、ONNX 默认），CuDNN 优化充分。  
- **部分推理引擎**：为发挥 Tensor Core 或特定 kernel，内部转为 **NHWC** 或支持两种格式；用户多数仍以 NCHW 输入。  
- **性能差异**：取决于具体 op、硬件与实现；不能笼统说谁更快，需实测；**混合精度与 Tensor Core** 下 NHWC 有时更优。

---

## 四、小结与面试要点

**小结**：NCHW=通道连续，适合 2D 卷积与 CuDNN；NHWC=空间点通道连续，适合逐点与部分 Tensor Core；性能看具体 op 与实现，NCHW 仍是默认主流。

**面试要点**：能解释两种 layout 与内存连续性；为何 NCHW 常用（CuDNN、框架默认）；NHWC 的适用场景（通道维向量化、部分 Tensor Core）。

---

## 记忆要点

1. **NCHW**：通道连续，2D 卷积与 CuDNN 友好。  
2. **NHWC**：空间点通道连续，逐点与部分 kernel 友好。  
3. 性能与 kernel 实现、硬件相关，需实测。  
4. 框架与 ONNX 默认多为 NCHW。

---

*上一篇：[第 53 题 - ONNX 与转换兼容性](./53-ONNX与转换兼容性.md)*  
*下一篇：[第 55 题 - Triton 与 ONNX Runtime 架构](./55-Triton与ONNX-Runtime架构.md)*
