#!/bin/bash
#########################################################################
# File Name: start_docker.sh
# Author: yourname
# mail: yourmail@example.com
# Created Time: [填写当前时间]
# 功能: 交互式创建并启动Docker容器，支持保存配置和命令复用
#########################################################################

# 配置文件相关变量
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/.config"
SCRIPT_NAME=$(basename "$0" .sh)
CONFIG_FILE="${CONFIG_DIR}/${SCRIPT_NAME}.config"
LOG_FILE="${CONFIG_DIR}/${SCRIPT_NAME}.log"

# 检查并创建config目录
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
fi

# 重定向所有输出到日志文件，同时保留终端输出
exec > >(tee -a "$LOG_FILE") 2>&1

# 处理-c参数（清空配置目录）
if [ "$1" = "-c" ]; then
    if [ -d "$CONFIG_DIR" ]; then
        rm -rf "$CONFIG_DIR"/*
        echo "已清空配置目录: $CONFIG_DIR"
    fi
    exit 0
fi

# 1. 提示用户输入容器名称和镜像版本
read -p "请输入容器ID: " docker_id

# 构建最终命令
docker_cmd="docker exec -it ${docker_id} /bin/bash"

# 3. 保存命令到配置文件
echo "$docker_cmd" > "$CONFIG_FILE"
echo "命令已保存至: $CONFIG_FILE"
echo "生成的命令: $docker_cmd"

# 询问是否执行命令
read -p "是否立即执行上述命令? [y/n] " execute_now
if [ "$execute_now" = "y" ] || [ "$execute_now" = "Y" ]; then
    eval "$docker_cmd"
else
    echo "可稍后通过执行配置文件启动: source $CONFIG_FILE"
fi
