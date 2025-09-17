#!/bin/bash

# Conda Autocomplete Installer
# 自动检测shell类型并安装相应的补全脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Conda Autocomplete Installer ===${NC}"

# 检测当前使用的shell
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

# 检测默认shell
detect_default_shell() {
    local shell_name=$(basename "$SHELL")
    echo "$shell_name"
}

# 检查conda是否安装
check_conda() {
    if command -v conda >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Conda detected${NC}"
        conda --version
        return 0
    else
        echo -e "${YELLOW}⚠ Conda not found in PATH${NC}"
        echo "Please make sure conda is installed and initialized"
        return 1
    fi
}

# 安装bash补全
install_bash() {
    echo -e "${GREEN}Installing Bash autocomplete...${NC}"
    
    local bashrc="$HOME/.bashrc"
    local bash_profile="$HOME/.bash_profile"
    local target_file="$bashrc"
    
    # macOS通常使用.bash_profile
    if [[ "$OSTYPE" == "darwin"* ]] && [ -f "$bash_profile" ]; then
        target_file="$bash_profile"
    fi
    
    # 复制补全脚本到用户目录
    cp "$SCRIPT_DIR/conda_autocomplete.sh" "$HOME/.conda_autocomplete.sh"
    
    # 检查是否已经添加
    if grep -q "conda_autocomplete.sh" "$target_file" 2>/dev/null; then
        echo -e "${YELLOW}Already installed in $target_file${NC}"
    else
        # 添加source命令到配置文件
        echo "" >> "$target_file"
        echo "# Conda environment autocomplete" >> "$target_file"
        echo "[ -f ~/.conda_autocomplete.sh ] && source ~/.conda_autocomplete.sh" >> "$target_file"
        echo -e "${GREEN}✓ Added to $target_file${NC}"
    fi
    
    echo -e "${GREEN}✓ Bash autocomplete installed${NC}"
    echo -e "${YELLOW}Please run: source $target_file${NC}"
}

# 安装zsh补全
install_zsh() {
    echo -e "${GREEN}Installing Zsh autocomplete...${NC}"
    
    local zshrc="$HOME/.zshrc"
    
    # 复制补全脚本到用户目录
    cp "$SCRIPT_DIR/conda_autocomplete.zsh" "$HOME/.conda_autocomplete.zsh"
    
    # 检查是否已经添加
    if grep -q "conda_autocomplete.zsh" "$zshrc" 2>/dev/null; then
        echo -e "${YELLOW}Already installed in $zshrc${NC}"
    else
        # 添加source命令到.zshrc
        echo "" >> "$zshrc"
        echo "# Conda environment autocomplete" >> "$zshrc"
        echo "[ -f ~/.conda_autocomplete.zsh ] && source ~/.conda_autocomplete.zsh" >> "$zshrc"
        echo -e "${GREEN}✓ Added to $zshrc${NC}"
    fi
    
    echo -e "${GREEN}✓ Zsh autocomplete installed${NC}"
    echo -e "${YELLOW}Please run: source $zshrc${NC}"
}

# 安装高级功能
install_advanced() {
    echo -e "${GREEN}Installing advanced features...${NC}"
    
    # 创建一个通用的conda helper脚本
    cat > "$HOME/.conda_helper" << 'EOF'
#!/bin/bash

# Conda Helper Functions

# 列出所有环境及其Python版本
conda_list_detailed() {
    echo "Conda Environments:"
    echo "==================="
    conda env list
    echo ""
    echo "Python versions:"
    echo "================"
    for env in $(conda env list | grep -v '^#' | awk '{print $1}' | grep -v '^$'); do
        if [ "$env" != "base" ]; then
            python_version=$(conda run -n "$env" python --version 2>/dev/null || echo "N/A")
            printf "%-20s : %s\n" "$env" "$python_version"
        fi
    done
}

# 快速切换到上一个环境
conda_switch_last() {
    if [ -n "$CONDA_PREV_ENV" ]; then
        conda activate "$CONDA_PREV_ENV"
    else
        echo "No previous environment recorded"
    fi
}

# 记录环境切换历史
conda_activate_with_history() {
    export CONDA_PREV_ENV="$CONDA_DEFAULT_ENV"
    conda activate "$1"
}

# 别名
alias cl='conda_list_detailed'
alias cs='conda_switch_last'
alias cah='conda_activate_with_history'

# 环境提示符美化（可选）
conda_prompt() {
    if [ -n "$CONDA_DEFAULT_ENV" ]; then
        echo "(🐍 $CONDA_DEFAULT_ENV)"
    fi
}
EOF
    
    chmod +x "$HOME/.conda_helper"
    echo -e "${GREEN}✓ Advanced features installed${NC}"
}

# 主安装流程
main() {
    echo ""
    
    # 检查conda
    if ! check_conda; then
        echo -e "${RED}Please install conda first${NC}"
        exit 1
    fi
    
    echo ""
    
    # 检测shell
    DEFAULT_SHELL=$(detect_default_shell)
    echo "Detected default shell: $DEFAULT_SHELL"
    
    # 询问用户要为哪个shell安装
    echo ""
    echo "Which shell would you like to install autocomplete for?"
    echo "1) Bash"
    echo "2) Zsh"
    echo "3) Both"
    echo "4) Cancel"
    
    read -p "Enter your choice [1-4]: " choice
    
    case $choice in
        1)
            install_bash
            ;;
        2)
            install_zsh
            ;;
        3)
            install_bash
            echo ""
            install_zsh
            ;;
        4)
            echo "Installation cancelled"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    
    # 询问是否安装高级功能
    read -p "Install advanced features? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_advanced
        echo -e "${YELLOW}Remember to add 'source ~/.conda_helper' to your shell config${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}=== Installation Complete ===${NC}"
    echo ""
    echo "Available commands after reloading shell:"
    echo "  - conda activate <TAB>  : Autocomplete environment names"
    echo "  - source activate <TAB> : Legacy command with autocomplete"
    echo "  - ca <TAB>             : Quick activate with autocomplete"
    
    if [ -f "$HOME/.conda_helper" ]; then
        echo ""
        echo "Advanced commands (after sourcing .conda_helper):"
        echo "  - cl                   : List environments with Python versions"
        echo "  - cs                   : Switch to previous environment"
        echo "  - cah <env>           : Activate with history tracking"
    fi
    
    echo ""
    echo -e "${YELLOW}Don't forget to reload your shell configuration!${NC}"
}

# 运行主函数
main
