# 5 Minutes Stacks, épisode XX : OpenVPN (site-to-site)  #

## Episode XX : OpenVPN (site-to-site)

![OpenVPNlogo](http://allnightburger.com/wp-content/uploads/2015/12/openvpn-logo.jpg)

Created in 2002, Open is an open source tool used to build VPNs site with site with the protocol SSL / TLS or with the shared keys. His(her,its) role is "to tunneliser ", in a secure way, data on a single port(bearing) TCP / UDP through a network not safe(sure) as Internet and so to establish VPNs.
OpenVPN can be installed(settled) on almost all the platforms as Linux, Microsoft Windows 2000 / XP / Vista, OpenBSD, FreeBSD, NetBSD, Mac BONE X and Solaris.
The Linux systems have to have a pit(core) 2.4 or a superior(a higher education). The principle of configuration stays the same whatever is the used platform.
OpenVPN creates a tunnel TCP or UDP and then calculates(codes) the data inside this one.
The port(bearing) by default used by OpenVPN is the port(bearing) UDP 1194, based on an official assignement of port(bearing) by the IANA.

## Descriptions

La service "openvpn(site-to-site)" is composed of two stack:

- bundle-trusty-vpn-site2sitefr1

the stack called bundle-trusty-vpn-site2sitefr1 create an instance a OpenVPN Server in the  region fr1

- bundle-trusty-vpn-site2sitefr2

the stack called bundle-trusty-vpn-site2sitefr2 create an instance a OpenVPN Client in the  region fr2

And then this is done install a vpn tunnel between those two nodes.

## Preparations

### the versions
 - OpenVPN 2.3.2-7ubuntu3.1

 ### The prerequisites to deploy this stack

  * an internet access
  * a Linux shell
  * a [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact), with an [existing keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
  * the tools [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
  * a local clone of the git repository [Cloudwatt applications](https://github.com/cloudwatt/applications)

 ### Size of the instance

  Per default, the script is proposing a deployement on an instance type "Standard 2" (n2.cw.standard-2).  Instances are charged by the minute and capped at their monthly price (you can find more details on the [Tarifs page](https://www.cloudwatt.com/fr/produits/tarifs.html) on the Cloudwatt website). Obviously, you can adjust the stack parameters, particularly its defaut size.

 ## What will you find in the repository

  Once you have cloned the github, you will find in the
  `bundle-trusty-vpn-site2sitefr1/`,`bundle-trusty-vpn-site2sitefr2/`

  * `bundle-trusty-vpn.heat.yml`: HEAT orchestration template. It will be used to deploy the necessary infrastructure.
  * `stack-start.sh`: Stack launching script. This is a small script that will save you some copy-paste.

 ## Start-up

 ### Initialize the environment

  Have your Cloudwatt credentials in hand and click [HERE](https://console.cloudwatt.com/project/access_and_security/api_access/openrc/).
  If you are not logged in yet, you will go thru the authentication screen then the script download will start. Thanks to it, you will be able to initiate the shell accesses towards the Cloudwatt APIs.

  Source the downloaded file in your shell. Your password will be requested.

  ~~~ bash
  $ source COMPUTE-[...]-openrc.sh
  Please enter your OpenStack Password:

  ~~~

  Once this done, the Openstack command line tools can interact with your Cloudwatt user account.

 ### Adjust the parameters

* bundle-trusty-vpn-site2sitefr1

  With the `bundle-trusty-vpn.heat.yml` file, you will find at the top a section named `parameters`. The parameters which need to be set up are called:

  - `keypair_name`  Its value must contain a valid keypair with regards to your Cloudwatt user account.
  - `flavor_name`  This is within this same file that you can adjust the instance size by playing with the  parameter. (default value: n1.cw.standard-1 )
  - `server_cidr`  This is the /24 cidr of local subnet. (default value: 10.10.10.0/24 )
  - `client_cidr`  This is the /24 cidr of target subnet. (default value: 20.20.20.0/24 )
  - `COUNTRY`  This is the Certificate VPN parameter COUNTRY. (default value: FR )
  - `CITY`  This is the Certificate VPN parameter CITY. (default value: Paris )
  - `ORGANISATION`  This is the Certificate VPN parameter ORGANISATION. (default value: cloudwatt
  - `EMAIL`  This is the Certificate VPN parameter EMAIL.( default value: contact@cloudwatt.com )
  - `PROVINCE`  This is the Certificate VPN parameter PROVINCE.(default value: idf )
  - `mykey_name`  This is the keypair_name used for the VPN Tunnel Initialization.

* bundle-trusty-vpn-site2sitefr2

  With the `bundle-trusty-vpn.heat.yml` file, you will find at the top a section named `parameters`. The parameters which need to be set up are called:

  - `keypair_name`  Its value must contain a valid keypair with regards to your Cloudwatt user account.
  - `flavor_name`  This is within this same file that you can adjust the instance size by playing with the  parameter.
  - `server_cidr`  This is the /24 cidr of local subnet.
  - `client_cidr`  This is the /24 cidr of target subnet.
  - `serv_public_key`  This is the public KEY of the OpenVPN server displayed in the output of the stack site2sitefr1
  - `ip_server_adress`  This is the floating ip of the OpenVPN server displayed in the output of the stack site2sitefr1


~~~ yaml
heat_template_version: 2013-05-23


description: Virtual Private Network Stack Site to Site


parameters:
  mykey_name:
    description: Keypair to inject in instance
    label: SSH MaKeypair
    type: string

  server_cidr:
    description: /24 cidr of local subnet
    type: string
    default: 10.10.10.0/24

  client_cidr:
    description: /24 cidr of target subnet (other end of the tunnel)
    type: string
    default: 20.20.20.0/24

  COUNTRY:
    description: COUNTRY for the VPN certificate
    label: certificate VPN COUNTRY
    type: string
    constraints:
      - length: { min: 1, max: 2 }
        description: COUNTRY must be between 1 and 2 characters
    default: FR

  PROVINCE:
    description: PROVINCE for the VPN certificate
    label: certificate VPN PROVINCE
    type: string
    constraints:
      - length: { min: 1, max: 40 }
        description: PROVINCE must be between 1 and 40 characters
    default: IDF

  CITY:
    description: CITY for the VPN certificate
    label: certificate VPN CITY
    type: string
    constraints:
      - length: { min: 1, max: 40 }
        description: CITY must be between 1 and 40 characters
    default: Paris

  ORGANISATION:
    description: ORGANISATION for the VPN certificate
    label: certificate VPN ORGANISATION
    type: string
    constraints:
      - length: { min: 1, max: 40 }
        description: ORGANISATION must be between 1 and 40 characters
    default: CLOUDWATT

  EMAIL:
    description: EMAIL for the VPN certificate
    label: certificate VPN EMAIL
    type: string
    constraints:
      - length: { min: 1, max: 40 }
        description:  EMAIL must be between 1 and 40 characters
    default: contact@Cloudwatt.com

  keypair_name:
    description: Keypair to inject in instance
    label: SSH Keypair
    type: string
    default: mickael

  flavor_name:
    description: Flavor to use for the deployed instance
    type: string
    label: Instance Type (Flavor)
    constraints:
      - allowed_values:
        - n1.cw.standard-1
        - n1.cw.standard-2
        - n1.cw.standard-4
    default:  n1.cw.standard-1

[...]
~~~

By default, ports(bearings) used by Openvpn are accessible only on the local area network, if you wish to change these rules of filtering (to open for example the port XXX), you can also edit the file `bundle-trusty-vpn.heat.yml `.
~~~ yaml
security_group:
  type: OS::Neutron::SecurityGroup
  properties:
    rules:
      - { direction: ingress, protocol: TCP, port_range_min: 22, port_range_max: 22 }
      - { direction: ingress, protocol: TCP, port_range_min: 80, port_range_max: 80 }
      - { direction: ingress, protocol: TCP, port_range_min: 443, port_range_max: 443 }
      - { direction: ingress, protocol: UDP, port_range_min: 1194, port_range_max: 1194 }
      - { direction: ingress, protocol: ICMP }
      - { direction: egress, protocol: ICMP }
      - { direction: egress, protocol: TCP }
      - { direction: egress, protocol: UDP }
      - { direction: egress, protocol: UDP, port_range_min: 1194, port_range_max: 1194 }
~~~


### Start the stacks

From a shell, launch the script `stack-start.sh`:

~~~
./stack-start.sh nom\_de\_votre\_stack
~~~

Example :

~~~bash
$ ./stack-start.sh vpn
+--------------------------------------+-----------------+--------------------+----------------------+
| id                                   | stack_name      | stack_status       | creation_time        |
+--------------------------------------+-----------------+--------------------+----------------------+
| ee873a3a-a306-4127-8647-4bc80469cec4 | VPN       | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
+--------------------------------------+-----------------+--------------------+----------------------+
~~~

Then wait for **5 minutes** that the deplyemnent is complet.

 ~~~ bash
 $ watch -n 1 heat stack-list
 +--------------------------------------+------------+-----------------+----------------------+
 | id                                   | stack_name | stack_status    | creation_time        |
 +--------------------------------------+------------+-----------------+----------------------+
 | xixixx-xixxi-ixixi-xiixxxi-ixxxixixi | VPN  | CREATE_COMPLETE | 2025-10-23T07:27:69Z |
 +--------------------------------------+------------+-----------------+----------------------+
 ~~~

 ### All of this is fine, but you do not have a way to run the stack through the console ?

 Yes ! Using the console, you can deploy an OpenVPN server:
 1.	Go the Cloudwatt Github in the applications/bundle-trusty-vpn-site2site/bundle-trusty-vpn-site2sitefr1  repository
 2.	Click on the file nammed bundle-trusty-vpn.heat.yml
 3.	Click on RAW, a web page appear with the script details
 4.	Save as its content on your PC. You can use the default name proposed by your browser (just remove the .txt)
 5.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console
 6.	Click on « Launch stack », then click on « Template file » and select the file you've just saved on your PC, then click on « NEXT »
 7.	Named your stack in the « Stack name » field
 8.	Complete the parameters fields
 9. Enter the informations for the certificat publishing :
- ORGANISATION(entre 1 et 40 characters)
- CITY(entre 1 et 40 characters)
- PROVINCE(entre 1 et 40 characters)
- EMAIL (entre 1 et 40 characters)
- COUNTRY (entre 1 et 2 characters)
 10.  Enter the client and server network that you want to configurate ending by /24 :
 Client_cidr :  X.X.X.X/24
 Server_cidr : X.X.X.X/24
 11. Enter the keypair_name used for the VPN Tunnel Initialization. ( Beware to not choose a existing name )
 12. Choose the size of your instance among the up and down menu  « flavor_name » and click on « Launch »
 13. Once the OpenVPN server is spawned you can acces to its output. You have got to collect the ip_server_adress and serv_public_key output to fill the client's stack parameters.
 14. Go the Cloudwatt Github in the applications/bundle-trusty-vpn-site2site/bundle-trusty-vpn-site2sitefr2  repository
 15. Click on the file nammed bundle-trusty-vpn.heat.yml.
 16.	Click on RAW, a web page appear with the script details.
 17.	Save as its content on your PC. You can use the default name proposed by your browser (just remove the .txt).
 18.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console.
 19.	Click on « Launch stack », then click on « Template file » and select the file you've just saved on your PC, then click on « NEXT ».
 20. Named your stack in the « Stack name » field.
 21. Complete the parameters fields
 22. Enter the client and server network that you want to configurate ending by /24 :
 Client_cidr : X.X.X.X/24 (must be the same than the one you have set up on the server)
 Server_cidr : X.X.X.X/24 (must be the same than the one you have set up on the server)
 23. Enter the ip_server_adress and serv_public_key parameters.
 24. Choose the size of your instance among the up and down menu  « flavor_name » and click on « Launch ».
 25. Connect yourself on the server and the client OpenVPN  both by ssh using your ssh key with the following command.
 Ssh -i  your_key cloud@X.X.X.X (ip adress of the instance that you want to join).
 26. edit the file /home/cloud/config.sh on the Server side and replace {{ip_client}} by the floating ip of the OpenVPN Client.
 27. Then run the /home/cloud/config.sh on both side (Client and Server).
 28. The Vpn tunnel is set up.

Le script `start-stack.sh` handles launch the necessary calls to the API Cloudwatt :


* Start 2 instances based on Ubnuntu the first one on the area FR1 the second one one the area FR2, pre- provisioned with the OpenVPN stack.
* Configure two nodes an OpenVPN server and OpenVPN client.
* Mount the VPN tunnel between the two nodes.

![OpenVPNArchi](img/site2sitearchi.png)

### Enjoy

Once this is done you have VPN tunnel between two remote website ready to use, you can retrieve the IP (public and private), subnets, networks, associated with instances created with the following command (Section `outputs` list the outputs of the stack)

You will have 2 silos fully isolated network that can nevertheless communicate through an encrypted tunnel.

You can view the stack output parameters in the console
by clicking: Stack → name of your stack → The Overview tab

The outputs of the stack on the Server side are:

- Floating_ip_server ( public IP associated with the vpn server )
- Public_key ( public key associated with the VPN client )
- Server_private_ip ( private IP address of the VPN server)


~~~ bash
$ heat stack-show OpenVPN FR1
+-----------------------+---------------------------------------------------+
| Property              | Value                                             |
+-----------------------+---------------------------------------------------+
|                     [...]                                                 |
| outputs               | [                                                 |
|                       |   {                                               |
|                       |     "output_value": "10.10.10.100",               |
|                       |     "description": "server private IP address",   |
|                       |     "output_key": "server_private_ip"             |
|                       |   },                                              |
|                       |   {                                               |
|                       |     "output_value": "YY.YY.YY.YY",                |
|                       |     "description": "server1 public IP address",   |
|                       |     "output_key": "server1_public_ip"             |
|                       |   },                                              |
|                       |   {                                               |
|                       |     "output_value": "rsa-pub ergezgezerv",        |
|                       |     "description": "Public key",                  |
|                       |     "output_key": "Public key"                    |
|                       |   },                                              |                                           |                       | ]                                                 |
|                       |    [...]                                          |
+-----------------------+---------------------------------------------------+
~~~

The outputs of the stack on the Client side are:

- Floating_ip_client ( public IP associated with the vpn client )
- Client_private_ip ( private IP address of the VPN client)

~~~ bash
$ heat stack-show OpenVPN FR2
+-----------------------+---------------------------------------------------+
| Property              | Value                                             |
+-----------------------+---------------------------------------------------+
|                     [...]                                                 |
| outputs               | [                                                 |
|                       |   {                                               |
|                       |     "output_value": "20.20.20.100",               |
|                       |     "description": "server private IP address",   |
|                       |     "output_key": "Client_private_ip"             |
|                       |   },                                              |
|                       |   {                                               |
|                       |     "output_value": "YY.YY.YY.YY",                |
|                       |     "description": "server public IP address",    |
|                       |     "output_key": "Floating_ip_client"            |
|                       |   },                                              |                                         |                       | ]                                                 |
|                       |    [...]                                          |
+-----------------------+---------------------------------------------------+
~~~



### Administer the   OpenVPN server
~~~ bash
ssh -i <keypair> cloud@<node-ip@>

~~~

### Consult the  OpenVPN's logs

OpenVPN services logs are visible via command line

~~~ bash
ssh -i <keypair> core@<node-ip@>

~~~

OpenVPN its backup logs in files `/var/log/syslog` et `/var/log/openvpn.log`

~~~ bash
ssh -i <keypair> cloud@<node-ip@>
tail -n 100 /var/log/openvpn.log
grep VPN /var/log/syslog
~~~

### Spawn instances in subnets client nodes and OpenVPN server

Go to the " Instances " section of the console. Start Instance  to create the server side instances and  the client side instances.

To start these instance you must complete the following steps  :

![etape0](img/etape0.png)

go to the Instances section of the console and click on Start Instance.

![etape1](img/etape1.png)

choose the name, the number, the boot source file and the boot image the of the instance.

![etape2](img/etape2.png)

choose the size of your instance.

![etape3](img/etape3.png)

select the key name use for the instance, the security group name and the subnet associate.

![etape4](img/etape4.png)

click on lauch to start the instance.

![validationcrea](img/validationcrea.png)

it means that the instance had been succesfully spwaned.

![fin](img/fin.png)

you can check you brand-new instance in the instance's list.

Log on to the instances that you just created by ssh from the server or the client thanks to the Openvpn my_key key created during the installation of the stack Openvpn by applying the step 12 of deployment of VPN .

### Once on the server or client to join Openvpn instances you just created.
~~~ bash

cd /home/cloud/.ssh
ssh -i your_key cloud@<node-ip@>
~~~

### The important files are :

#### For the server:

- `/ Etc / openvpn / ta.key` : secret key shared between the Client and the Server
- `/ Etc / openpvn / ca.crt` : Certificate SSL / TLS administration
- `/ Etc / openvpn / server.key` : server key
- `/ Etc / openvpn / server.crt` : Certificate Server
- `/ Etc / openvpn / server.conf` : server configuration file
- `/ Etc / openvpn / configclient.tar.gz` : Archive containing OpenVPN client configuration files

#### to the client:

- `/ Etc / openvpn / ta.key` : secret key shared between the Client and the Server
- `/ Etc / openpvn / ca.crt` : Certificate SSL / TLS administration
- `/ Etc / openvpn / client.key` : client key
- `/ Etc / openvpn / client.crt` : Client Certificate
- `/ Etc / openvpn / client.conf` : Client Configuration File

#### Other sources that may interest you:

* [OpenVPN Homepage](https://openvpn.net/)
* [Ubuntu OpenVPN
Homepage](https://doc.ubuntu-fr.org/openvpn)


-----
Have fun. Hack in peace.
