sudo tar xzvf  /etc/openvpn/configclient.tar.gz -C  /etc/openvpn/
cd  /etc/openvpn/configclient
sudo mv * ..
sed -i 's/X.X.X.X/{{ip_server}}/g' /etc/openvpn/client.conf
sudo service openvpn restart
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo /etc/init.d/iptables-persistent save
sudo /etc/init.d/iptables-persistent reload
