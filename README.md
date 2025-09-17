# Conda Environment Autocomplete Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Support](https://img.shields.io/badge/Shell-Bash%2C%20Zsh-blue.svg)](https://github.com/yourusername/conda-autocomplete)
[![Platform](https://img.shields.io/badge/Platform-Linux%2C%20macOS%2C%20Windows-green.svg)](https://github.com/yourusername/conda-autocomplete)

A command-line tool that solves conda environment activation autocomplete issues.
一个解决conda环境激活时自动补全问题的命令行工具。



https://github.com/user-attachments/assets/c931a0a1-a8fc-4f4b-b93d-e4ad9606298f



## Features | 功能特性

- ✅ **Tab Autocomplete**: Support for `conda activate` command | 支持 `conda activate` 命令的Tab自动补全
- ✅ **Legacy Support**: Support for `source activate` command | 支持 `source activate` 命令的Tab自动补全
- ✅ **Quick Commands**: Simplified shortcut command `ca` | 提供简化的快捷命令 `ca`
- ✅ **Multi-Shell**: Support for Bash and Zsh shells | 支持Bash和Zsh shell
- ✅ **Auto Detection**: Automatically detect all conda environments | 自动检测所有conda环境
- ✅ **Advanced Features**: Environment switching history, detailed listings, etc. | 可选的高级功能（环境切换历史、详细列表等）
- ✅ **FZF Integration**: Fuzzy search support (optional) | 模糊搜索支持（可选）

## Quick Installation | 快速安装

```bash
# 1. Clone the repository | 克隆仓库
git clone https://github.com/yourusername/conda-autocomplete.git
cd conda-autocomplete

# 2. Make the install script executable | 赋予安装脚本执行权限
chmod +x scripts/install.sh

# 3. Run the installer | 运行安装脚本
./scripts/install.sh

# 4. Reload your shell configuration | 重新加载shell配置
source ~/.bashrc  # For Bash users | 如果使用bash
# or | 或
source ~/.zshrc   # For Zsh users | 如果使用zsh
```

## Manual Installation | 手动安装

### For Bash Users | Bash用户

```bash
# 复制bash补全脚本
cp scripts/conda_autocomplete.sh ~/.conda_autocomplete.sh

# 添加到.bashrc
echo '[ -f ~/.conda_autocomplete.sh ] && source ~/.conda_autocomplete.sh' >> ~/.bashrc

# 重新加载配置
source ~/.bashrc
```

### For Zsh Users | Zsh用户

```bash
# 复制zsh补全脚本
cp scripts/conda_autocomplete.zsh ~/.conda_autocomplete.zsh

# 添加到.zshrc
echo '[ -f ~/.conda_autocomplete.zsh ] && source ~/.conda_autocomplete.zsh' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc
```

## Usage | 使用方法

After installation, you can use the following commands with Tab autocomplete:
安装完成后，你可以使用以下命令并享受Tab自动补全：

### Basic Usage | 基本用法

```bash
# 使用conda activate（推荐）
conda activate fund<TAB>
# 自动补全为: conda activate fundcrawler

# 使用source activate（兼容旧版本）
source activate fund<TAB>
# 自动补全为: source activate fundcrawler

# 使用快捷命令
ca fund<TAB>
# 自动补全为: ca fundcrawler
```

### 多个匹配项

当输入的前缀匹配多个环境时，按Tab键会显示所有匹配的选项：

```bash
conda activate py<TAB>
# 可能显示:
# python36  python37  python38  pytorch
```

### 列出所有环境

```bash
# 不带参数运行activate_env会列出所有可用环境
activate_env

# 或使用ca命令
ca
```

## 高级功能

如果安装了高级功能，可以使用以下命令：

```bash
# 先source helper文件
source ~/.conda_helper

# 列出所有环境及其Python版本
cl

# 切换到上一个环境
cs

# 带历史记录的激活
cah myenv
```

## FZF集成（可选）

如果系统安装了[fzf](https://github.com/junegunn/fzf)，zsh版本会自动启用模糊搜索功能：

```bash
# 使用模糊搜索选择环境
caf
# 会打开一个交互式选择界面
```

## 配置说明

工具会自动检测以下位置的conda环境：

1. 通过 `conda env list` 命令获取的环境
2. `~/anaconda3/envs/` 目录
3. `~/miniconda3/envs/` 目录
4. `~/miniforge3/envs/` 目录
5. `~/.conda/envs/` 目录
6. `/opt/conda/envs/` 目录

## 故障排除

### 自动补全不工作

1. 确保conda已正确安装和初始化
   ```bash
   conda --version
   ```

2. 确保补全脚本已正确source
   ```bash
   # 检查是否加载
   type _conda_activate_complete  # bash
   # 或
   type _conda_activate_zsh  # zsh
   ```

3. 手动重新加载shell配置
   ```bash
   exec $SHELL
   ```

### 环境未被检测到

如果某些环境未被检测到，可以：

1. 检查环境是否在标准位置
2. 修改脚本中的 `_get_conda_envs` 函数，添加自定义路径
3. 确保有读取权限

### macOS特殊说明

在macOS上，如果使用bash，配置可能需要添加到 `~/.bash_profile` 而不是 `~/.bashrc`：

```bash
echo '[ -f ~/.conda_autocomplete.sh ] && source ~/.conda_autocomplete.sh' >> ~/.bash_profile
source ~/.bash_profile
```

## 自定义和扩展

你可以通过修改脚本来添加更多功能：

1. **自定义快捷命令**：在脚本中添加新的alias或函数
2. **环境名称过滤**：修改 `_get_conda_envs` 函数来过滤特定环境
3. **集成其他工具**：如virtualenv、pyenv等

## 兼容性

- ✅ Linux (Ubuntu, CentOS, Debian等)
- ✅ macOS
- ✅ Windows (WSL/Git Bash/Cygwin)
- ✅ Conda 4.x 及以上版本
- ✅ Anaconda/Miniconda/Miniforge

## 贡献

欢迎提交Issue和Pull Request来改进这个工具！

## 许可证

MIT License

## 更新日志

### v1.0.0
- 初始版本发布
- 支持基本的Tab自动补全
- 支持Bash和Zsh
- 包含安装脚本
- 可选的高级功能
