# 第 259 题：Git Flow与GitHub Flow

## 题目

Git Flow 与 GitHub Flow 的主要区别是什么？在自动驾驶或车载团队中如何选择与裁剪？

---

## 一、Git Flow 要点

**分支**：长期存在 **main（master）** 与 **develop**；功能从 develop 拉 **feature**，合回 develop；发布从 develop 拉 **release**，修 bug 后合回 main 与 develop；**hotfix** 从 main 拉，修完合回 main 与 develop。  
**特点**：版本线清晰，适合**固定发布周期、多版本并行维护**（如车厂多个车型/年款）；流程较重，分支多。

---

## 二、GitHub Flow 要点

**分支**：只有长期 **main**；所有开发在 **feature 分支**完成，通过 PR 合入 main；发布用 **main + 标签**，无 develop/release 分支。  
**特点**：简单，**持续部署**友好，适合主干即可发布、迭代快的团队；多版本并存时需靠标签或分支策略补充。

---

## 三、区别与选型

**区别**：Git Flow 有 develop/release/hotfix，多分支支撑多版本；GitHub Flow 仅 main + feature，主干即发布。  
**选型**：需要**多版本并行**（如 L2/L3 分支、不同 OEM 定制）时倾向 Git Flow 或在其基础上裁剪（如省略 release、简化 hotfix）；**单线快速迭代**、主干即产线时可用 GitHub Flow。  
**自动驾驶**：常采用 Git Flow 或 Trunk-Based + 发布分支，兼顾功能分支隔离与发布可追溯；需与 CI/CD、代码评审、发布门禁配合。

---

## 小结与面试要点

**小结**：Git Flow 多分支多版本；GitHub Flow 单 main 持续发布；车载/自动驾驶多选 Git Flow 或裁剪版，与发布与合规需求匹配。

**面试要点**：能说清两种模型的分支结构、适用场景及在车载团队中的选型考量。

---

## 记忆要点

1. **Git Flow**：main + develop + feature/release/hotfix，多版本并行。  
2. **GitHub Flow**：main + feature，主干即发布。  
3. **选型**：多版本维护用 Git Flow；单线快迭代用 GitHub Flow；自动驾驶常裁剪 Git Flow。

---

*上一篇：[第 258 题 - CI-CD与自动化测试](./258-CI-CD与自动化测试.md)*  
*下一篇：[第 260 题 - Code Review关注点](./260-Code-Review关注点.md)*
