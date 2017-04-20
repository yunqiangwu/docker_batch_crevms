#!/bin/bash



id_rsas_directory=./id_rsas
vms_config_file=./vms_config.csv


if [ -d $id_rsas_directory ];then
    rm -rf $id_rsas_directory

    ./rmrfvms.sh

    cat /dev/null > $vms_config_file
fi



docker build . -t centos_sshd
mkdir -p $id_rsas_directory


for i in `seq 1 10`  
do

	container_name=my_vm_$i

	container_id=`docker run --name $container_name -idt -P centos_sshd`

	container_ssh_port=`docker inspect --format="{{index ( index ( index  .NetworkSettings.Ports \"22/tcp\" ) 0) \"HostPort\"  }}" $container_id`

	id_rsa_file=$id_rsas_directory/id_rsa_$container_ssh_port

	echo "###----- ",$container_ssh_port,$id_rsa_file,$container_name
	sleep 1


	# docker exec -it $container_name cat ./id_rsa > $id_rsa_file

	docker cp $container_name:/id_rsa $id_rsa_file

	chmod 600 $id_rsa_file

	container_ip=`ssh  -oStrictHostKeyChecking=no -i $id_rsa_file root@127.0.0.1 -p $container_ssh_port /showip.sh`

	#LC_ALL=C ifconfig|grep "inet addr:"|grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}'

	echo $container_ip,$container_ssh_port,$id_rsa_file,$container_name>>$vms_config_file


done




