#!/bin/bash
# batch create vms 



vms_info_directory=./vms_info
vms_config_file=$vms_info_directory/vms_config.csv

if [ "$1" = "-clear" ]; then

	if  [ ! -d $vms_info_directory ]; then
		exit
	fi


    cat $vms_config_file |cut -d' ' -f5|cut -d'=' -f2|xargs docker rm -f
    rm -rf $vms_info_directory
    #cat /dev/null > $vms_config_file
	exit
fi

if [ -d $vms_info_directory ];then
    cat $vms_config_file |cut -d, -f4|xargs docker rm -f
    rm -rf $vms_info_directory
fi



docker build . -t centos_sshd
mkdir -p $vms_info_directory

n=$1
if [ "$n" = "" ];then
    n=4
fi

for i in `seq 1 $n`  
do

	container_name=my_vm_$i

	container_id=`docker run --name $container_name -idt -P centos_sshd`

	container_ssh_port=`docker inspect --format="{{index ( index ( index  .NetworkSettings.Ports \"22/tcp\" ) 0) \"HostPort\"  }}" $container_id`

	id_rsa_file=$vms_info_directory/id_rsa_$container_ssh_port

	echo "###----- ",$container_ssh_port,$id_rsa_file,$container_name
	sleep 1


	# docker exec -it $container_name cat ./id_rsa > $id_rsa_file

	docker cp $container_name:/id_rsa $id_rsa_file

	chmod 600 $id_rsa_file

	container_ip=`ssh  -oStrictHostKeyChecking=no -i $id_rsa_file root@127.0.0.1 -p $container_ssh_port /shell/showip.sh`

	docker exec $container_name rm -rf /root/.ssh/known_hosts

	#LC_ALL=C ifconfig|grep "inet addr:"|grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}'

	echo $container_ip ansible_ssh_user=root ansible_ssh_port=22 ansible_ssh_private_key_file=`pwd`/$id_rsa_file container_name=$container_name>>$vms_config_file


done


cp ./vms_info/vms_config.csv /etc/ansible/hosts

