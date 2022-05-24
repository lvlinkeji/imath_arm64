#!/bin/bash

mkdir -p $START_DIR

mkdir -p ~/.local/share/code-server/User
mv /settings.json ~/.local/share/code-server/User/settings.json
chmod a+rx ~/.local/share/code-server/User/settings.json
mv /rclone-tasks.json ~/.local/share/code-server/User/tasks.json
chmod a+rx ~/.local/share/code-server/User/tasks.json

code-server --install-extension /actboy168.tasks-0.9.0.vsix
code-server --install-extension /ms-vscode.cpptools-1.10.3@linux-arm64.vsix
code-server --install-extension ms-python.python
code-server --install-extension james-yu.latex-workshop
code-server --install-extension ms-azuretools.vscode-docker
code-server --install-extension eamodio.gitlens
code-server --install-extension DavidAnson.vscode-markdownlint

mkdir -p ~/.config/code-server
rm -rf ~/.config/code-server/config.yaml
mv /config.yaml ~/.config/code-server/config.yaml
chmod a+rx ~/.config/code-server/config.yaml

prl=`grep PermitRootLogin /etc/ssh/sshd_config`
pa=`grep PasswordAuthentication /etc/ssh/sshd_config`
if [[ -n $prl && -n $pa ]]; then
sed -i 's/^#\?Port[ ]22.*/Port 22/g' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
fi

#需要手动安装一下 go https://go.dev/doc/install ，添加环境变量 PATH /etc/profile，然后 source /etc/profile
#记得在 /etc/nginx/nginx.conf 的 http 域里的最后一行添加 client_max_body_size 1024m; 然后重载一下 nginx 的配置文件 nginx -s reload
#client_max_body_size 0;代表大小不限制

#Ubuntu安装LaTeX，以VS Code为编辑器，支持中文字体简单教程_努力做无毒的Pb的博客-程序员宝宝
#https://www.cxybb.com/article/weixin_44715583/109553033

#解压网站模板
#unzip -o /grad_school.zip -d /
#chmod -Rf +rw /templatemo_557_grad_school

sed -i "s|iPORT|$PORT|g" /etc/nginx/sites-available/default
#sed -i "s|include /etc/nginx/sites-enabled/*;|include /etc/nginx/sites-enabled/*;client_max_body_size 0;|g" /etc/nginx/nginx.conf
sed -i 's|include[ ][/]etc[/]nginx[/]sites-enabled[/][*];\+|include /etc/nginx/sites-enabled/*;\n    client_max_body_size 0;|g' /etc/nginx/nginx.conf

#service redis-server start &
#/etc/init.d/redis-server restart >/dev/null 2>&1 &
#service nginx start &
#/etc/init.d/nginx restart >/dev/null 2>&1 &

#/usr/local/bin/ttyd -p $PORT -c admin:adminks123 bash

#rm -rf /usr/bin/python
#ln -s /usr/bin/python3 /usr/bin/python

#wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /usr/local/bin/ttyd
#chmod a+rx /usr/local/bin/ttyd

chmod -Rf 777 /run/screen

#run rclone config
# screen_name="rclone_config"
# screen -dmS $screen_name
# cmd="/rclone_config.sh";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'
nohup /rclone_config.sh &

#run code-server
# screen_name="code-server"
# screen -dmS $screen_name
# cmd="code-server --host 0.0.0.0 --port 8722 $START_DIR";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'

#run ttyd
# screen_name="ttyd"
# screen -dmS $screen_name
# #cmd="ttyd login";
# cmd="ttyd -p 7681 -c admin:adminks123.C bash"
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'

#curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
filebrowser config init
filebrowser config set -b '/file'
filebrowser config set -p 60002
filebrowser users add root c68.300OQa --perm.admin

#run filebrowser
# screen_name="filebrowser"
# screen -dmS $screen_name
# cmd="filebrowser -r /";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'
#filebrowser username:root password:c68.300OQa

#run rclone
# screen_name="rclone"
# screen -dmS $screen_name
# cmd="rclone rcd --rc-web-gui --rc-addr 127.0.0.1:5572 --rc-user root --rc-pass c68.300OQa";
# screen -x -S $screen_name -p 0 -X stuff "$cmd"
# screen -x -S $screen_name -p 0 -X stuff '\n'

#run math
#screen_name="imath"
#screen -dmS $screen_name
#cmd="/math_calc.sh";
#screen -x -S $screen_name -p 0 -X stuff "$cmd"
#screen -x -S $screen_name -p 0 -X stuff '\n'

#run qbittorrent-nox
qbittorrent-nox -d --webui-port=8082
#qbittorrent username:admin password:adminadmin

#wstunnel -s 0.0.0.0:80 &
/usr/sbin/sshd -D

/verysync-linux-arm64-v2.13.2/verysync generate --gui-user=admin --gui-password=c6,.8300OQa

supervisord -c /supervisord.conf

while true
do
    sleep 5
done
