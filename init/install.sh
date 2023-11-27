BASE_URL=http://192.168.1.1

cd $HOME


echo "==========Set NO PASSWORD=========="
echo "user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/user
sudo sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
echo "==========Set NO PASSWORD=========="

echo "==========UPDATE SOURCE============"
sudo apt update 
echo "==========UPDATE SOURCE============"



echo "=========SET SSH CONFIGURE========="
mkdir -p $HOME/.ssh
cd $HOME/.ssh
curl ${BASE_URL}/ssh/id_ed25519 -o $HOME/.ssh/id_ed25519
curl ${BASE_URL}/ssh/id_ed25519.pub -o $HOME/.ssh/id_ed25519.pub
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
sudo chmod 600 ~/.ssh/id_ed25519
sudo chmod 600 ~/.ssh/id_ed25519.pub
echo "=========SET SSH CONFIGURE========="


echo "=========INSTALL PIP & RICH========="
sudo apt install -y python3-pip
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple rich
echo "=========INSTALL PIP & RICH========="

sudo apt install -y pssh


echo "==========Set The HTTP Server=========="
cd $HOME
curl ${BASE_URL}/init/http_server.py -o /home/user/http_server.py
curl ${BASE_URL}/init/http_server.service -o /home/user/http_server.service
sudo chmod 777 http_server.py
sudo cp http_server.service /etc/systemd/system/http-server.service
sudo systemctl daemon-reload
sudo systemctl start http-server.service
sudo systemctl enable http-server.service
echo "==========Set The HTTP Server=========="