#!/bin/bash

# 定义颜色
re="\033[0m"
red="\033[1;91m"
green="\e[1;32m"
yellow="\e[1;33m"
purple="\e[1;35m"
red() { echo -e "\e[1;91m$1\033[0m"; }
green() { echo -e "\e[1;32m$1\033[0m"; }
yellow() { echo -e "\e[1;33m$1\033[0m"; }
purple() { echo -e "\e[1;35m$1\033[0m"; }
reading() { read -p "$(red "$1")" "$2"; }

USERNAME=$(whoami) && \
WORKDIR="/home/${USERNAME}/.nezha-agent"

[[ "$HOSTNAME" == "s1.ct8.pl" ]] && WORKDIR="${WORKDIR}" || WORKDIR="${WORKDIR}"
[ -d "$WORKDIR" ] || (mkdir -p "$WORKDIR" && chmod 777 "$WORKDIR")

download_agent() {
    # 检查是否指定版本
    if [ -z "$VERSION" ]; then
        echo "未指定版本，下载最新版本..."
        DOWNLOAD_LINK="https://github.com/amclubs/am-nezha-agent/releases/latest/download/nezha-agent_freebsd_amd64.zip"
    else
        echo "指定版本为：$VERSION"
        DOWNLOAD_LINK="https://github.com/amclubs/am-nezha-agent/releases/download/${VERSION}/nezha-agent_freebsd_amd64.zip"
    fi

    if [ -e "$FILENAME" ]; then
        echo "$FILENAME 已存在，跳过下载"
    else
        echo "正在下载文件..."
        FILENAME="$WORKDIR/nezha-agent_freebsd_amd64.zip"
        if ! wget -q -O "$FILENAME" "$DOWNLOAD_LINK"; then
            echo "error: 文件 $FILENAME 下载失败。"
            exit
        fi
        echo "已成功下载 $FILENAME"
    fi

    echo "正在解压文件..."
    if ! unzip "$FILENAME" -d "$WORKDIR" > /dev/null 2>&1; then
        echo "error: 解压失败，请检查文件或重试。"
        exit
    fi
    echo "解压成功。"

    if [ -e "$WORKDIR/nezha-agent" ]; then
	       chmod +x ${WORKDIR}/nezha-agent
    else
        echo "error: 解压后的文件夹不存在，可能解压失败或文件结构已更改。"
        exit
    fi
				
	   #echo "正在清理下载文件..."
	   rm -f "$FILENAME";
				
    return 0
}

generate_config() {
    echo
    echo "初始化nezha-agent配置"

    printf "请输入面板的agentsecretkey: "
    read -r your_agent_secret
				printf "请输入Agent对接地址: "
    read -r your_dashboard_server
				printf "请输入uuid(回车默认生成): "
    read -r uuid

    if [ -z "$your_agent_secret" ]; then
        echo "error! 面板的agentsecretkey不能为空"
        rm -rf ${WORKDIR}
        return 1
    fi
    if [ -z "$your_dashboard_server" ]; then
        echo "error! Agent对接地址不能为空"
        rm -rf ${WORKDIR}
        return 1
    fi
				if [ -z "$uuid" ]; then
        uuid=$(uuidgen)
    fi
				
CONFIG_FILE="config.yml"
cat <<EOF > "$CONFIG_FILE"
client_secret: $your_agent_secret
debug: false
disable_auto_update: false
disable_command_execute: false
disable_force_update: false
disable_nat: false
disable_send_query: false
gpu: false
insecure_tls: false
ip_report_period: 1800
report_delay: 1
server: $your_dashboard_server
skip_connection_count: false
skip_procs_count: false
temperature: false
tls: false
use_gitee_to_upgrade: false
use_ipv6_country_code: false
uuid: $uuid
EOF
# 提示信息
echo "$CONFIG_FILE 已创建并写入内容。"

}


generate_run() {
    cat > ${WORKDIR}/start.sh << EOF
#!/bin/bash
pgrep -f '$WORKDIR/nezha-agent' | xargs -r kill
cd ${WORKDIR}
exec ${WORKDIR}/nezha-agent -c ${WORKDIR}/config.yml >/dev/null 2>&1
EOF
    chmod +x ${WORKDIR}/start.sh
}

run_agent(){
    nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &
    printf "nezha-agent已经准备就绪，请按下回车键启动\n"
    read
    printf "正在启动nezha-agent，请耐心等待...\n"
    sleep 3
    if pgrep -f "${WORKDIR}/nezha-agent" > /dev/null; then
        echo "nezha-agent 已启动！"
        echo "如果面板处未上线，请检查参数是否填写正确，并停止 agent 进程，删除已安装的 agent 后重新安装！"
        echo "停止 agent 进程的命令：pgrep -f 'nezha-agent' | xargs -r kill"
        echo "删除已安装的 agent 的命令：rm -rf ~/.nezha-agent"
    else
        rm -rf "${WORKDIR}"
        echo "nezha-agent 启动失败，请检查参数填写是否正确，并重新安装！"
    fi
}

check_and_run() {
    if pgrep -f '$WORKDIR/nezha-agent' > /dev/null; then
        echo "程序已运行"
        exit
    fi
}

install_agent() {
	echo -e "${yellow}开始运行前，请确保V1版本哪吒面板dashboard${purple}已安装${re}"
	echo -e "${yellow}面板${purple}Additional services中的Run your own applications${yellow}已开启为${purplw}Enabled${yellow}状态${re}"
	reading "\n确定继续安装吗？【y/n】: " choice
	case "$choice" in
	[Yy])
	  cd $WORKDIR
	  check_and_run
	  download_agent && wait
	  generate_run
	  generate_config
	  run_agent && sleep 3
	;;
	[Nn]) exit 0 ;;
	*) red "无效的选择，请输入y或n" && menu ;;
  esac
}

uninstall_agent() {
  reading "\n确定要卸载吗？【y/n】: " choice
    case "$choice" in
       [Yy])
          kill -9 $(ps aux | grep "${WORKDIR}" | grep -v 'grep' | awk '{print $2}')
		  echo "删除安装目录: $WORKDIR"
          rm -rf $WORKDIR
          ;;
        [Nn]) exit 0 ;;
    	*) red "无效的选择，请输入y或n" && menu ;;
    esac
}

restart_agent() {
  reading "\n确定要重启吗？【y/n】: " choice
    case "$choice" in
       [Yy])
          run_agent
          ;;
        [Nn]) exit 0 ;;
    	*) red "无效的选择，请输入y或n" && menu ;;
    esac
	
}

kill_agent() {
reading "\n关闭nezha-agent进程，确定继续清理吗？【y/n】: " choice
  case "$choice" in
    [Yy]) kill -9 $(ps aux | grep "${WORKDIR}" | grep -v 'grep' | awk '{print $2}') ;;
       *) menu ;;
  esac
}

kill_all_tasks() {
reading "\n清理所有进程将退出ssh连接，确定继续清理吗？【y/n】: " choice
  case "$choice" in
    [Yy]) killall -9 -u $(whoami) ;;
       *) menu ;;
  esac
}


#主菜单
menu() {
    clear
    echo ""
    purple "=== AM科技 serv00 | nezha-agent V1哪吒探针 一键安装脚本 ===\n"
    purple "转载请著名出处，请勿滥用\n"
    echo -e "${green}AM科技 YouTube频道    ：${yellow}https://youtube.com/@AM_CLUB${re}"
    echo -e "${green}AM科技 GitHub仓库     ：${yellow}https://github.com/amclubs${re}"
    echo -e "${green}AM科技 个人博客       ：${yellow}https://am.809098.xyz${re}"
    echo -e "${green}AM科技 TG交流群组     ：${yellow}https://t.me/AM_CLUBS${re}"
    echo -e "${green}AM科技 脚本视频教程   ：${yellow}https://youtu.be/2B5yN09Wd_s${re}"
    echo   "======================="
    green  "1. 安装nezha-agent"
    echo   "======================="
    red    "2. 卸载nezha-agent"
    echo   "======================="
    green  "3. 重启nezha-agent"
    echo   "======================="
    green  "4. 查看配置信息"
    echo   "======================="
    yellow "5. 关闭nezha-agent进程"
    echo   "======================="
    yellow "6. 清理所有进程"
    echo   "======================="
    red    "7. serv00系统初始化"
    echo   "======================="
    red    "0. 退出脚本"
    echo   "======================="

    # 用户输入选择
    reading "请输入选择(0-5): " choice
    echo ""
    
    # 根据用户选择执行对应操作
    case "$choice" in
        1) install_agent ;;
        2) uninstall_agent ;;
        3) restart_agent ;;
        4) cat $WORKDIR/config.yml ;;
        5) kill_agent ;;
        6) kill_all_tasks ;;
        7) system_initialize ;;
        0) exit 0 ;;
        *) red "无效的选项，请输入 0 到 5" ;;
    esac
}
menu
