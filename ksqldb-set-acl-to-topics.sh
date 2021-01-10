#!/bin/bash
if [ $# -ne 2 ]
  then
    echo "No arguments supplied"
    echo "Please add cluster_name and topic_name as parameters"
    exit 0
fi

CLUSTER_NAME=$1
TOPIC_NAME=$2
echo "Cluster name : " $CLUSTER_NAME
echo "Topic name : " $TOPIC_NAME

echo "Login to Confluent Cloud"
ccloud login

# Retrieve the Cluster Id
CLUSTER_ID=`ccloud kafka cluster list | grep $CLUSTER_NAME | awk -F "|" '{print $1}'`
echo "CLUSTER_ID = " $CLUSTER_ID
# NOTE: if this cluster_id is the default one, there is a * we need to remove
if echo "$CLUSTER_ID" | grep '\*'
  then CLUSTER_ID=`echo "$CLUSTER_ID" | awk -F " " '{print $2}'`
fi
# Set to use the Cluster Id with ccloud
ccloud kafka cluster use $CLUSTER_ID
# Get the KSQLDB App Id
KSQLDB_ID=`ccloud ksql app list | grep $CLUSTER_ID | awk -F "|" '{print $1}'`
echo "KSQLDB_ID = " $KSQLDB_ID
# Get the Service Account Id
ccloud ksql app configure-acls $KSQLDB_ID $TOPIC_NAME --dry-run
SERVICE_ACCOUNT_ID=`ccloud service-account list | grep $KSQLDB_ID |awk -F "|" '{print $1}'`
echo "SERVICE_ACCOUNT_ID = " $SERVICE_ACCOUNT_ID

# Set Read/Write access to the Topics
ccloud kafka acl create --allow --service-account $SERVICE_ACCOUNT_ID --operation READ --operation WRITE --topic '*'
echo ""

