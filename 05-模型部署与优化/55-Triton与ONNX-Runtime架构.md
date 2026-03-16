# 第 55 题：推理引擎（Triton、ONNX Runtime）的架构设计

## 题目

推理引擎（Triton、ONNX Runtime）的架构设计？

---

## 一、ONNX Runtime 架构概要

**定位**：跨平台 **ONNX 模型推理**，支持 CPU、GPU、NPU 等。  
**流程**：加载 ONNX 图 → **图优化**（常量折叠、算子融合、布局转换等）→ **执行提供者（EP）** 选择（CUDA、TensorRT、OpenVINO 等）→ 按拓扑序**调度算子**执行。  
**特点**：模块化 EP、同一模型可切分到多 EP；内置量化、图优化；C++ 核心、多语言 API。

---

## 二、Triton 架构概要

**定位**：**GPU 编程与 kernel 编写**的开放框架（非仅推理引擎），用类 Python 的 **Triton 语言**写 kernel，自动并行与内存管理，常用于**自定义算子、研究、以及作为推理后端**。  
**流程**：用户写 Triton kernel（tile、block 划分）→ 编译为 PTX/GPU 代码 → 与 PyTorch/TensorFlow 等集成调用。  
**特点**：**易写高效 kernel**、自动并行、适合新 op 与算法原型；推理链上可把部分 op 用 Triton 实现并接入 ONNX Runtime 或 PyTorch。

---

## 三、对比与“架构”要点

| 维度 | ONNX Runtime | Triton |
|------|----------------|--------|
| **角色** | 完整推理引擎 | GPU kernel 开发与执行 |
| **输入** | ONNX 图 | 手写 Triton kernel |
| **优化** | 图级优化 + 多 EP | kernel 级、用户控制 |
| **典型** | 部署、多后端 | 新算子、研究、高性能 kernel |

**架构共性**：**计算图/算子抽象** + **后端执行**（多 EP 或 Triton 编译）+ **内存与调度**；目标都是**低延迟、高吞吐**。

---

## 四、小结与面试要点

**小结**：ONNX Runtime=ONNX 图+图优化+多 EP 执行；Triton=GPU kernel 编写与执行框架；二者可结合（如用 Triton 实现 op 再接入 Runtime）。

**面试要点**：能简述 Runtime 的“图→优化→EP→执行”；Triton 的“写 kernel→编译→GPU 执行”；二者定位不同（全链路推理 vs kernel 开发）。

---

## 记忆要点

1. **ONNX Runtime**：图加载、图优化、多 EP、按图执行。  
2. **Triton**：Triton 语言写 kernel、自动并行、GPU 编译执行。  
3. Runtime 偏部署全链路；Triton 偏 kernel 与算法。  
4. 可组合：Triton 实现 op → 接入 Runtime 或 PyTorch。

---

*上一篇：[第 54 题 - CUDA Memory Layout 与 NCHW/NHWC](./54-CUDA-Memory-Layout与NCHW-NHWC.md)*  
*下一篇：[第 56 题 - 多相机批量推理优化](./56-多相机批量推理优化.md)*
