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

# 检查是否存在配置文件并询问是否使用
if [ -f "$CONFIG_FILE" ]; then
    echo "检测到已存在配置文件: $CONFIG_FILE"
    cat "$CONFIG_FILE"
    read -p "是否使用上述命令启动模型? [y/n] " use_existing
    if [ "$use_existing" = "y" ] || [ "$use_existing" = "Y" ]; then
        # 执行配置文件中的命令
        eval "$(cat "$CONFIG_FILE")"
        echo "模型已启动"
        exit 0
    fi
fi

# 构建最终命令
dynamo_cmd="dynamo serve graphs.agg_mx:SGLangFrontend -f ./configs/agg_mx_v2_tp16.yaml --service-name=SGLangWorker"

# 3. 保存命令到配置文件
echo "$dynamo_cmd" > "$CONFIG_FILE"
echo "命令已保存至: $CONFIG_FILE"
echo "生成的命令: $dynamo_cmd"

# 询问是否执行命令
read -p "是否立即执行上述命令? [y/n] " execute_now
if [ "$execute_now" = "y" ] || [ "$execute_now" = "Y" ]; then
    eval "$dynamo_cmd"
    echo "模型启动完成"
else
    echo "可稍后通过执行配置文件启动: source $CONFIG_FILE"
fi
