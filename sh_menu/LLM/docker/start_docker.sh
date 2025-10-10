#!/bin/bash
#########################################################################
# File Name: start_docker.sh
# Author: limix
# mail: limiximil@163.com
# Created Time: [2025.10.10]
# 功能: 交互式创建并启动Docker容器，支持保存配置和命令复用
#########################################################################

# 配置文件相关变量
CONFIG_DIR="./config"
SCRIPT_NAME=$(basename "$0" .sh)
CONFIG_FILE="${CONFIG_DIR}/${SCRIPT_NAME}.config"

# 检查并创建config目录
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
fi

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
    read -p "是否使用上述命令启动容器? [y/n] " use_existing
    if [ "$use_existing" = "y" ] || [ "$use_existing" = "Y" ]; then
        # 执行配置文件中的命令
        eval "$(cat "$CONFIG_FILE")"
        echo "容器已启动"
        exit 0
    fi
fi

# 1. 提示用户输入容器名称和镜像版本
read -p "请输入容器名称: " container_name
read -p "请输入镜像名称及版本 (格式: image:version): " image_version

# 2. 循环输入-v参数
volumes=()
echo "请输入-v参数（输入空值结束）"
while true; do
    read -p "输入挂载路径 (格式: 宿主机路径:容器路径): " volume
    if [ -z "$volume" ]; then
        break
    fi
    volumes+=("-v" "$volume")
done

# 构建最终命令
docker_cmd="docker run -d --it --name ${container_name} --shm-size 32g --ipc=host --privileged --network=host ${volumes[*]} ${image_version}"

# 3. 保存命令到配置文件
echo "$docker_cmd" > "$CONFIG_FILE"
echo "命令已保存至: $CONFIG_FILE"
echo "生成的命令: $docker_cmd"

# 询问是否执行命令
read -p "是否立即执行上述命令? [y/n] " execute_now
if [ "$execute_now" = "y" ] || [ "$execute_now" = "Y" ]; then
    eval "$docker_cmd"
    echo "容器启动完成"
else
    echo "可稍后通过执行配置文件启动: source $CONFIG_FILE"
fi
