#!/usr/bin/env bash

HOST=$(hostname -s)
DOMAIN=$(hostname -d)

function create_config() {
  /bin/cp /hbase/conf/hbase-env.sh.bak /hbase/conf/hbase-env.sh
  /bin/cp /hbase/conf/hbase-site.xml.bak /hbase/conf/hbase-site.xml

  sed -i "s/ZK_SERVERS/${ZK_SERVERS}/g" /hbase/conf/hbase-site.xml
  sed -i "s/HADOOP_NAMENODE_HOST/${HADOOP_NAMENODE_HOST}/g" /hbase/conf/hbase-site.xml
  sed -i "s/HBASE_MASTER_HOST/${HBASE_MASTER_HOST}/g" /hbase/conf/hbase-site.xml
  

}

function unrecognized_node_type() {
  echo "unrecognized node type"
  echo "available node type:master|regionserver"
  echo "specific it as HBASE_NODE_TYPE under spec.containers.env"
  exit 1
}

create_config

if [ "${HBASE_NODE_TYPE}" != "" ]; then
  if [ "${HBASE_NODE_TYPE}" == "master" ]; then
    /hbase/bin/hbase master start
  elif [ "${HBASE_NODE_TYPE}" == "regionserver" ]; then
    /hbase/bin/hbase regionserver start
  else
    unrecognized_node_type
  fi
else
  unrecognized_node_type
fi
