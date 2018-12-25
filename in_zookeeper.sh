# if [ $# == 0 ];then
# 	echo "please pointed config location!"
# 	exit 1;
# fi
# #confPath=$1

# confPath=/data/zookeeper
# mkdir -p $confPath

# ips=`hostname -i`
# for ip in ${ips[@]}
# do
#         for line in $(cat $confPath)
#         do
#                 result=$(echo $line | grep "${ip}")
#                 if [ "$result" != "" ]
#                 then
#                         myid=$(echo $line|cut -d = -f 1 |cut -d . -f 2)
#                 fi
#         done
# done

# if [ !$myid ];then
# 	echo "please check zoo.cfg!"
# 	exit 1;
# fi
#################################zookeeper 部署及相关python包部署##################################

wget http://archive.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz -O /usr/local/zookeeper-3.4.8.tar.gz
tar -xzf /usr/local/zookeeper-3.4.8.tar.gz -C /usr/local
ln -s /usr/local/zookeeper-3.4.8 /usr/local/zookeeper
rm -rf /usr/local/zookeeper-3.4.8.tar.gz


grep "export ZOOKEEPER_HOME=/usr/local/zookeeper" /etc/profile > /dev/null
if [ $? -eq 1 ]; then
    echo "export ZOOKEEPER_HOME=/usr/local/zookeeper" >> /etc/profile
fi

grep "export PATH=\\$\ZOOKEEPER_HOME/bin:\\$\PATH" /etc/profile > /dev/null
if [ $? -eq 1 ]; then
    echo "export PATH=\$ZOOKEEPER_HOME/bin:\$PATH" >> /etc/profile
fi

source /etc/profile

cp $ZOOKEEPER_HOME/bin/zkEnv.sh $ZOOKEEPER_HOME/bin/zkEnv.sh.bak
sed -i 's\ZOO_LOG_DIR="."\ZOO_LOG_DIR="$ZOOBINDIR/../logs"\g' $ZOOKEEPER_HOME/bin/zkEnv.sh

cp $ZOOKEEPER_HOME/conf/log4j.properties $ZOOKEEPER_HOME/conf/log4j.properties.bak
sed -i 's/zookeeper.root.logger=INFO, CONSOLE/zookeeper.root.logger=INFO, ROLLINGFILE/g' $ZOOKEEPER_HOME/conf/log4j.properties


################init config ##############
# cat <<EOF >$ZOOKEEPER_HOME/conf/zoo.cfg
# tickTime=2000
# the directory where the snapshot is stored
# dataDir=/data/zookeeper/data
# the directory where the transaction log is stored
# aLogDir=/data/zookeeper/log
# entPort=6181
# tLimit=10
# cLimit=5
# ClientCnxns=0
cat $confPath>$ZOOKEEPER_HOME/conf/zoo.cfg
cat $ZOOKEEPER_HOME/conf/zoo.cfg

################init manage script ##############

mkdir -p /root/scripts
mkdir -p /data/zookeeper/data
touch /root/scripts/zookeeper
cat <<EOF > /root/scripts/zookeeper
#/bin/bash   

ZOOKEEPER_HOME=/usr/local/zookeeper

case \$1 in  
          start) \$ZOOKEEPER_HOME/bin/zkServer.sh start;;  
          stop) \$ZOOKEEPER_HOME/bin/zkServer.sh stop;;                                 
          status) \$ZOOKEEPER_HOME/bin/zkServer.sh status;;  
          restart) \$ZOOKEEPER_HOME/bin/zkServer.sh stop&\$ZOOKEEPER_HOME/bin/zkServer.sh stop;;  
              *)  echo "require start|stop|status|restart";;  
esac
EOF
chmod +x /root/scripts/zookeeper

/root/scripts/zookeeper

grep "nohup /root/scripts/zookeeper start &" /etc/rc.local > /dev/null
if [ $? -eq 1 ]; then
    echo 'nohup /root/scripts/zookeeper start &' >> /etc/rc.local
fi


echo "ZOOKEEPR install ok!"

echo $myid > /data/zookeeper/data/myid
