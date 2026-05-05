# 推送到 GitHub

**仓库已创建**：https://github.com/RiddleGo/autodrive-interview-300（当前为空，待推送）

## 一键推送（用 Token）

在本机**能访问 GitHub** 的终端（若直连超时可开代理）执行：

```powershell
cd d:\vibecoding\autodrive-interview-300
$env:GH_TOKEN = "粘贴你的 GitHub Token"
.\deploy-to-github.ps1
```

Token 在 https://github.com/settings/tokens 创建（classic），勾选 **repo** 权限。推送成功后访问：https://github.com/RiddleGo/autodrive-interview-300
