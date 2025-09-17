#!/bin/zsh

# Conda Environment Autocomplete for Zsh
# 支持zsh shell的conda环境自动补全

# 获取conda环境列表
_get_conda_envs_zsh() {
    local -a envs
    
    # 从conda env list获取环境
    if command -v conda >/dev/null 2>&1; then
        envs=(${(f)"$(conda env list | grep -v '^#' | awk '{print $1}' | grep -v '^$')"})
    fi
    
    # 检查常见的conda环境目录
    local conda_dirs=(
        "$HOME/anaconda3/envs"
        "$HOME/miniconda3/envs"
        "$HOME/miniforge3/envs"
        "$HOME/.conda/envs"
        "/opt/conda/envs"
    )
    
    for dir in $conda_dirs; do
        if [[ -d "$dir" ]]; then
            local dir_envs=(${(f)"$(ls -1 $dir 2>/dev/null)"})
            envs=($envs $dir_envs)
        fi
    done
    
    # 去重
    typeset -U envs
    echo ${envs[@]}
}

# Zsh补全函数
_conda_activate_zsh() {
    local -a envs
    envs=($(_get_conda_envs_zsh))
    _describe 'conda environments' envs
}

# 为不同的激活命令设置补全
compdef '_conda_activate_zsh' 'conda activate'

# source activate 的补全
_source_activate_zsh() {
    local state
    
    _arguments \
        '1:command:(activate deactivate)' \
        '2:environment:->env'
    
    case $state in
        env)
            if [[ ${words[2]} == "activate" ]]; then
                _conda_activate_zsh
            fi
            ;;
    esac
}

compdef _source_activate_zsh source

# 自定义快捷命令
ca() {
    if [[ -z "$1" ]]; then
        echo "Usage: ca <environment_name>"
        echo "\nAvailable environments:"
        _get_conda_envs_zsh | tr ' ' '\n' | sort | column
        return 1
    fi
    
    conda activate "$1"
}

# 为ca命令添加补全
compdef '_conda_activate_zsh' ca

# 额外功能：fuzzy finder集成（如果安装了fzf）
if command -v fzf >/dev/null 2>&1; then
    # 使用fzf选择conda环境
    caf() {
        local env
        env=$(_get_conda_envs_zsh | tr ' ' '\n' | fzf --prompt="Select conda environment: ")
        if [[ -n "$env" ]]; then
            echo "Activating environment: $env"
            conda activate "$env"
        fi
    }
    
    echo "FZF integration enabled! Use 'caf' for fuzzy search."
fi

echo "Zsh conda autocomplete loaded!"
