# docker_pusher

本项目包含两个脚本，分别用于Linux/Unix系统（`.sh`）和Windows系统（`.bat`），旨在自动化从指定源仓库拉取Docker镜像，并直接推送到阿里云容器镜像服务（ACR），无需重命名操作。适用于需要定期同步或备份镜像的场景。

## 特性

- **跨平台支持**：提供Shell脚本（Linux/Unix）和Batch脚本（Windows）。
- **安全配置**：首次运行时，通过交互式方式收集阿里云镜像仓库的访问凭据，并安全地存储在本地配置文件中。
- **自动化处理**：根据`images.txt`文件中的镜像列表自动执行拉取与推送操作。

## 快速开始

### 环境要求

- **Docker**：确保您的系统上已安装并配置好Docker。
  - 对于Windows用户，推荐使用[Docker Desktop](https://www.docker.com/products/docker-desktop)。
- **阿里云账号**：拥有阿里云容器镜像服务的访问权限。
  
### 安装与配置

1. **克隆本仓库**：
   ```
   git clone https://github.com/Genshinzmnl/docker_pusher.git
   cd docker_pusher
   ```

2. **首次运行脚本**：
   - **Linux/Unix**：运行`put.sh`。
     ```
     sudo ./put.sh
     ```
     脚本将提示您输入阿里云镜像仓库的地址、命名空间、用户名和密码。这些信息将被安全地保存在`config.json`中。
   - **Windows**：运行`config.bat`。
     ```
     put.bat
     ```
     同样，您会被提示输入必要的配置信息。

### 日常使用

- 一旦配置完成，再次运行相应的脚本即可自动执行镜像的拉取与推送。
  - **Linux/Unix**：`./put.sh`
  - **Windows**：`put.bat`

### 注意事项

- **安全性**：虽然脚本尝试通过限制文件权限保护配置信息，但在生产环境中建议使用更高级别的安全措施，如环境变量或外部密钥管理系统。
- **错误处理**：脚本包含基本的错误处理逻辑，但在复杂的网络或权限问题下可能需要手动介入。
- **镜像列表**：确保`images.txt`文件中列出了您想同步的所有镜像及其完整标签，每行一个镜像。

## 贡献指南

欢迎提交bug报告、功能建议或直接贡献代码。请遵循[贡献指南](CONTRIBUTING.md)。

## 许可证

本项目使用[MIT许可证](LICENSE)。
