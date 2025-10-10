#########################################################################
# File Name: ww.sh
# Author: Bill
# mail: XXXXXXX@qq.com
# Created Time: 2016-08-12 10:40:12
#########################################################################
#!/bin/bash

# 获取当前脚本的绝对路径
current_script_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
current_script_full_path="${current_script_path}/$(basename "${BASH_SOURCE[0]}")"

echo "当前脚本所在目录的绝对路径: $current_script_path"
echo "当前脚本文件的绝对路径: $current_script_full_path"