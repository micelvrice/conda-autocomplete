#!/bin/bash

# Conda Environment Autocomplete Tool
# 用于实现conda环境激活时的自动补全功能

# 获取所有conda环境列表
_get_conda_envs() {
    local conda_envs=""
    
    # 检查conda是否安装
    if command -v conda >/dev/null 2>&1; then
        # 获取conda环境列表，排除base环境的标记
        conda_envs=$(conda env list | grep -v '^#' | awk '{print $1}' | grep -v '^$')
    fi
    
    # 如果存在自定义的conda环境目录，也可以从目录中获取
    if [ -d "$HOME/anaconda3/envs" ]; then
        local dir_envs=$(ls -1 "$HOME/anaconda3/envs" 2>/dev/null)
        conda_envs="$conda_envs $dir_envs"
    elif [ -d "$HOME/miniconda3/envs" ]; then
        local dir_envs=$(ls -1 "$HOME/miniconda3/envs" 2>/dev/null)
        conda_envs="$conda_envs $dir_envs"
    fi
    
    # 去重并排序
    echo "$conda_envs" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

# conda activate 命令的自动补全函数
_conda_activate_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # 只在 activate 后面提供补全
    if [[ "$prev" == "activate" ]]; then
        local envs=$(_get_conda_envs)
        COMPREPLY=($(compgen -W "$envs" -- "$cur"))
    fi
}

# source activate 命令的自动补全函数
_source_activate_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # 检查是否是 source activate 命令
    if [[ "${COMP_WORDS[0]}" == "source" && "$prev" == "activate" ]]; then
        local envs=$(_get_conda_envs)
        COMPREPLY=($(compgen -W "$envs" -- "$cur"))
    fi
}

# 自定义的激活命令（可选）
activate_env() {
    if [ -z "$1" ]; then
        echo "Usage: activate_env <environment_name>"
        echo "Available environments:"
        _get_conda_envs | tr ' ' '\n' | column
        return 1
    fi
    
    # 尝试使用conda activate
    if command -v conda >/dev/null 2>&1; then
        conda activate "$1"
    else
        echo "Conda is not installed or not in PATH"
        return 1
    fi
}

# 简化的别名命令
ca() {
    activate_env "$1"
}

# 为ca命令添加自动补全
_ca_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local envs=$(_get_conda_envs)
    COMPREPLY=($(compgen -W "$envs" -- "$cur"))
}

# 注册自动补全
# 为conda activate注册
complete -F _conda_activate_complete conda

# 为source activate注册
complete -F _source_activate_complete source

# 为自定义命令注册
complete -F _ca_complete ca
complete -F _ca_complete activate_env

# 提示信息
echo "Conda autocomplete loaded successfully!"
echo "Available commands:"
echo "  - conda activate <env>  : Activate conda environment with tab completion"
echo "  - source activate <env> : Legacy activation with tab completion"  
echo "  - ca <env>             : Shortcut for activate_env"
echo "  - activate_env         : List all available environments"
