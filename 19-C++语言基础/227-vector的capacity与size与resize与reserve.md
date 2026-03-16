# 第 227 题：vector 的 capacity 与 size 与 resize 与 reserve

## 题目

vector 的 size 与 capacity 区别？resize 与 reserve 分别做什么？何时会触发重新分配（reallocation）？

---

## 一、size 与 capacity

**size**：当前**已保存的元素个数**，即 size() 返回值；表示逻辑长度。  
**capacity**：当前**已分配的存储空间**能容纳的元素个数，即 capacity()；capacity ≥ size。  
**关系**：vector 内部有一块连续内存，可存 capacity 个元素，其中前 size 个是有效元素；访问 [0, size) 合法，[size, capacity) 未构造。

---

## 二、resize 与 reserve

**resize(n)**：把 **size** 改为 n。若 n > size，会**在末尾增加** n - size 个元素（值初始化或指定值），可能触发**扩容**（若 n > capacity）；若 n < size，会**析构**末尾元素，size 变小，**capacity 不变**。  
**reserve(n)**：保证 **capacity ≥ n**；若当前 capacity < n，会**重新分配**更大内存、移动元素、释放旧内存；**不改变 size**，不构造新元素。  
**区别**：resize 改“逻辑长度”并可能增删元素；reserve 只改“预分配空间”，避免后续 push_back 时多次扩容。

---

## 三、重新分配（reallocation）

**何时发生**：**push_back**、**insert**、**resize** 等导致 **size 将超过 capacity** 时，vector 会分配新内存（通常 **2 倍**或实现定义的增长因子）、将元素移动或拷贝到新内存、释放旧内存。  
**影响**：**迭代器、指针、引用**会**失效**；因此循环里 push_back 可能导致迭代器失效，需注意。  
**避免**：若已知大致元素个数，可先 **reserve**，减少 reallocation 次数与拷贝/移动。

面试可答：size 是元素个数，capacity 是已分配空间；resize 改 size 并可能增删元素，reserve 只保证 capacity 足够；超过 capacity 的插入会触发重新分配，迭代器会失效，可 reserve 预分配减少重分配。

---

## 小结与面试要点

**小结**：size=逻辑长度，capacity=已分配容量；resize 改 size，reserve 改 capacity；超 capacity 插入触发 reallocation，迭代器失效。

**面试要点**：能区分 size/capacity、resize/reserve 及 reallocation 的触发与影响。

---

## 记忆要点

1. **size**：元素个数；**capacity**：已分配容量，≥ size。  
2. **resize**：改 size，可能增删元素；**reserve**：保证 capacity，不建元素。  
3. **reallocation**：size 将超 capacity 时发生；迭代器/指针/引用失效；可 reserve 预分配。

---

*上一篇：[第 226 题 - RAII 原则](./226-RAII原则.md)*  
*下一篇：[第 228 题 - unordered_map 与 map 实现](./228-unordered_map与map实现.md)*
