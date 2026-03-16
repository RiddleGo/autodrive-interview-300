# 第 218 题：mutex 与 lock_guard 与 unique_lock

## 题目

std::mutex、std::lock_guard、std::unique_lock 的区别与使用场景？何时用 unique_lock 而不是 lock_guard？

---

## 一、mutex

**作用**：**互斥量**，保证同一时刻只有一个线程持有锁；**lock()** 获取、**unlock()** 释放；**不可拷贝、不可移动**。  
**使用**：临界区前 lock、临界区后 unlock；若中途抛异常未 unlock 会**死锁**，故应配合 **RAII** 包装类使用。  
**其他**：**recursive_mutex** 允许同一线程多次加锁；**timed_mutex** 支持 try_lock_for / try_lock_until。

---

## 二、lock_guard

**作用**：**RAII** 包装，构造时 lock 传入的 mutex，析构时 unlock；**不可拷贝**。  
**使用**：简单“加锁到作用域结束”的场景；代码简洁，无手动 unlock。  
**特点**：不提供 **lock/unlock** 接口，不能中途解锁或配合条件变量；**轻量**，无额外状态。

---

## 三、unique_lock

**作用**：也是 RAII，但比 lock_guard **更灵活**；可**延迟加锁**（defer_lock）、**尝试加锁**（try_to_lock）、**超时加锁**；支持 **lock()/unlock()**，可**转移所有权**（移动）。  
**使用**：需要**条件变量**（condition_variable::wait 要求 unique_lock）、需要**中途解锁**、需要 **try_lock** 或**超时**时用 unique_lock。  
**开销**：比 lock_guard 略大（存锁状态、可重入 lock/unlock）；简单场景用 lock_guard 即可。

面试可答：mutex 是互斥量；lock_guard 是简单 RAII 锁，作用域结束即解锁；unique_lock 更灵活，可配合条件变量、中途解锁与 try_lock，条件变量必须用 unique_lock。

---

## 小结与面试要点

**小结**：mutex 为底层锁；lock_guard 简单 RAII；unique_lock 灵活，支持条件变量与手动 lock/unlock。

**面试要点**：能说明三者关系及何时选 unique_lock（条件变量、需手动控制锁时）。

---

## 记忆要点

1. **mutex**：lock/unlock；须配合 RAII 防异常导致死锁。  
2. **lock_guard**：构造 lock、析构 unlock；简单场景、无中途解锁。  
3. **unique_lock**：可 lock/unlock、可转移；**condition_variable::wait** 必须用 unique_lock。

---

*上一篇：[第 217 题 - C++11/14/17/20 新特性](./217-C++11-14-17-20新特性.md)*  
*下一篇：[第 219 题 - 死锁条件与避免](./219-死锁条件与避免.md)*
