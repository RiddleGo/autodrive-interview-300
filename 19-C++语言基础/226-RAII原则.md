# 第 226 题：RAII 原则

## 题目

什么是 RAII？为什么 C++ 推荐用 RAII 管理资源？举几个标准库中的 RAII 例子。

---

## 一、RAII 含义

**全称**：Resource Acquisition Is Initialization—**资源获取即初始化**。  
**核心**：把**资源的获取**与**对象的构造**绑定、把**资源的释放**与**对象的析构**绑定；通过**栈上对象**的生命周期，自动在**离开作用域**时调用析构函数释放资源，避免泄漏与重复释放。

---

## 二、为什么推荐 RAII

**异常安全**：若在获取资源后、释放前抛异常，手动 release 可能不会执行；RAII 依靠栈展开时必然调用的析构函数，保证**无论正常或异常**都会释放。  
**避免遗忘**：多处 return 或复杂分支下，容易漏写 release；RAII 一处定义、处处生效。  
**代码简洁**：不需成对写 acquire/release，逻辑更清晰；符合“谁申请谁释放、用对象代表资源”的思路。

---

## 三、标准库中的 RAII 例子

**智能指针**：**unique_ptr**、**shared_ptr**—持有一个指针，析构时 delete 或减引用计数；**lock_guard**、**unique_lock**—构造时 lock、析构时 unlock。  
**文件与流**：**std::fstream**—打开文件即获取句柄，析构时关闭；**std::ifstream/ofstream** 同理。  
**其他**：**std::string** 管理动态内存；**std::vector** 管理数组；自定义的“句柄类”（如 socket、GPU 资源）也应封装成 RAII 对象。

面试可答：RAII 即用对象构造表示获取资源、析构表示释放资源，依赖作用域结束自动析构保证释放；智能指针、lock_guard、fstream 都是 RAII，保证异常安全与不遗漏释放。

---

## 小结与面试要点

**小结**：RAII 用对象生命周期绑定资源生命周期；构造获取、析构释放；异常安全、避免遗漏；智能指针与锁是典型例子。

**面试要点**：能解释 RAII 含义、优势并举出 2～3 个标准库例子。

---

## 记忆要点

1. **RAII**：获取=构造、释放=析构；栈对象离开作用域即释放。  
2. **优势**：异常安全、不遗漏、代码清晰。  
3. **例子**：unique_ptr/shared_ptr、lock_guard/unique_lock、fstream。

---

*上一篇：[第 225 题 - 虚继承与菱形继承](./225-虚继承与菱形继承.md)*  
*下一篇：[第 227 题 - vector 的 capacity 与 size 与 resize 与 reserve](./227-vector的capacity与size与resize与reserve.md)*
