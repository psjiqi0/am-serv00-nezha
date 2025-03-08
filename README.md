

## 一、需要准备的前提资料
### 1、首先注册一个Serv00账号，建议使用gmail邮箱注册，注册好会有一封邮箱上面写着你注册时的用户名和密码
- 注册帐号地址：https://serv00.com


![image](https://github.com/user-attachments/assets/b3b3733b-3553-45dd-9346-c4664251755f)
  
### 2、连接ssh 工具

## 三、安装前需准备好以下工作
- 1、登入邮件里面发你的 DevilWEB webpanel 后面的网址，进入网站后点击 Change languag 把面板改成英文
- 2、然后在左边栏点击 Additonal services ,接着点击 Run your own applications 看到一个 Enable 点击
也可以ssh连接用命令设置，设置成功要退出ssh再重新连接
```
devil binexec on
```
- 3、找到 Port reservation 点击后面的 Add Port 新开二个端口，随便写，也可以点击 Port后面的 Random随机选择Port tybe 选择 TCP
- 4、然后点击 Port list 你会看到二个端口
![image](https://github.com/user-attachments/assets/7060edbc-25f7-4add-a0fc-219a002c4048)

- 5、找到左边栏 WWW websites 点击 Add nwe websites 填写你的域名，也可以用别的域名映射到Serv00里 
![image](https://github.com/user-attachments/assets/0c40ef42-2c19-4ac2-aacf-801e39a3d3d6)

- 6、如果想用域名要解析你添加到serv00里面的A记录即可。找到 WWW websites 点击后面的 Mange SSL 就可以看到二个IP，一般添加第一个IP就可以了。
- 7、添加自己的域名开启DNS的话 在左边栏 DNS zones也可以看到A记录
- 8、推荐cloudflare域名解析A记录

## 四、 准备Github里面的三个东西，按照以下步骤后保存到一边
- 1、进入Gihub点击右上角头像找到 Settings 点击后往下拉找到左边栏下面的 Developer settings 点击
- 2、然后会看到三个应用点击 OAuth Apps 找到 New OAuth App点击后 按照下图所填，然后点击 Register application
![image](https://github.com/user-attachments/assets/a10dc421-7fe2-4234-a6bb-2200562a912d)

- 3、进入后会看到下图
![image](https://github.com/user-attachments/assets/5357bbeb-42d9-4cf4-89a5-8acc88e27c4e)

- 4、看到 Client ID下面的ID Client secrets 点击左边的 Generate seceet 后你会得到一个密码保存好后面会用到。
- 5、这里的Application name 可以随便写
callback URL的填成改成你的域名。
```
https://xxx.com/
```
 Authorization callback URL的代码复制下面的,记得前面的网址改成你的。
```
https://xxx.com/oauth2/callback
```
- 也可以这样输入,上面的的第2步里面的URL 也可以这样填防止登录不到面板端
```  
http://ip:9888/oauth2/callback
```

- 如果解析的域名登录不上面板记得改成 Github 的第2步 。如下图
![image](https://github.com/user-attachments/assets/8fe58fbc-e148-4190-84f2-8bc75850b412)

## 五、开始安装

- 1、进入到面板后复制下面代码到面板安装（与 V1 版本不兼容，对应agent探针也要 V0 版本）
```
bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/install-dashboard.sh)
```

- 2、指定版本下载安装(把VERSION=自己修改对应要安装的版本号)
```
VERSION=v0.20.13 bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/install-dashboard.sh)
```

- 4、然后按照以下提升输入
  
| 变量 | 值 | 
|--------|---------|
|请输入 OAuth2 提供商(github/gitlab/jihulab/gitee，默认 github):	|回车就行
|请输入 Oauth2 应用的 Client ID	|前面页面里面保存的ID
|请输入 Oauth2 应用的 Client Secret	|右边保存的密码
|请输入 GitHub/Gitee 登录名作为管理员，多个以逗号隔开	|页面头像后面的用户名
|请输入站点标题	|随便写
|请输入站点访问端口	|前面网站设置的第一个端口
|请输入用于 Agent 接入的 RPC 端口	|第二个端口

- 5、这样我们面板端就安装好了,接着去浏览器里面输入p安装成功后输出的里面的链接如下图所示
  <img width="1497" alt="nezha" src="https://github.com/user-attachments/assets/460f08ba-4c73-49e9-a334-690012b025d3">

- 6、登入到面板端后点击右边用户名的管理后台找到设置里面的未接入CDN的面板服务器域名/IP
  
  <img width="1260" alt="nezha-1" src="https://github.com/user-attachments/assets/82767233-8010-439a-8e9d-39f26ed9f788">

填入解析的IP或者域名后保存

点击服务器新增服务器，名称随便填点击下面的的新增

下来会看到一个服务器后面的密钥下面我们会用到

<img width="1223" alt="serv00-3" src="https://github.com/user-attachments/assets/8a430a9d-3d55-47d7-846d-6eb5a8caca1a">

- 7、dashboard保活

保活视频教程：[点击观看](https://youtu.be/zkGGklEaO2I?si=Ssqkk2fUM6fif8tO)

- 8、dashboard卸载命令(卸载完就执行第3步的安装命令重新安装)
```
pgrep -f 'dashboard' | xargs -r kill
rm -rf ~/.nezha-dashboard
```

--------------------------------------------------------------------------------------------------------
- 9、V1 版本面板安装（与 V0 版本不兼容，对应agent探针也要V1版本）
```
bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/install-dashboard-v1.sh)
```
- 4、指定版本下载安装(把VERSION=自己修改对应要安装的版本号)
```
VERSION=v1.5.1 bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/install-dashboard-v1.sh)
```


## 六、把serv00服务器添加到nezha上面(其它要监控和多台服务器都是此命令安装就可以)
- 1、V1 版本面板安装（与 V0 版本不兼容，对应面板也要V1版本）
```
bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/install-agent-v1.sh)
```
- 2、指定版本下载安装(把VERSION=自己修改对应要安装的版本号)
```
VERSION=v1.5.1 bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/install-agent-v1.sh)
```
重启
```
bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/am_restart_agent.sh)
```
## 七、保活
- 3、agent保活命令
```
  (crontab -l; echo "*/12 * * * * pgrep -x "nezha-agent" > /dev/null || nohup /home/${USER}/.nezha-agent/start.sh >/dev/null 2>&1 &") | crontab -
```
重启
```
bash <(curl -s https://raw.githubusercontent.com/amclubs/am-serv00-nezha/main/am_restart_dashboard.sh)
```

- 4、agent卸载命令(卸载完就执行第1步的安装命令重新安装)
```
pgrep -f 'nezha-agent' | xargs -r kill
rm -rf ~/.nezha-agent
```







 #
 免责声明:
 - 1、该项目设计和开发仅供学习、研究和安全测试目的。请于下载后 24 小时内删除, 不得用作任何商业用途, 文字、数据及图片均有所属版权, 如转载须注明来源。
 - 2、使用本程序必循遵守部署服务器所在地区的法律、所在国家和用户所在国家的法律法规。对任何人或团体使用该项目时产生的任何后果由使用者承担。
 - 3、作者不对使用该项目可能引起的任何直接或间接损害负责。作者保留随时更新免责声明的权利，且不另行通知。
 
