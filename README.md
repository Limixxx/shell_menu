## shell_menu

Shell_menu 是一个框架,也是一个工具箱

> * 自动生成脚本菜单
> * 统一管理脚本工具
> * 日常运维工具
>   * docker

![Screenshot](images/menu.jpg)

* 上图输入 1 ，即执行 ww.sh 脚本
* 上图输入 2 ，及进入 wang 目录，程序会判断是否在子目录，如果是在子目录，会自动加回退到上级目录选项
* 本程序仅支持到三级菜单
* 如果输入中有字符输入错误，可以输入'Ctrl + Backspace' 进行删除操作
* 添加脚本后可以通过 bash main.sh -c 手动更新菜单，以及 bash main.sh -t 查看菜单
