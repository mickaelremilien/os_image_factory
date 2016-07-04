sudo scp -oStricthostkeychecking=no -oIdentityFile=/home/cloud/.ssh/{{ma_key}}.pem /etc/openvpn/configclient.tar.gz cloud@"{{ip_client}}":/etc/openvpn/
sudo service openvpn restart
