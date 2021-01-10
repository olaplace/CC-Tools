# CC-Tools
Tools to accelerate Confluent Cloud usage.

## Scripts:
### ksqldb-set-acl-to-topics.sh:
Once a ksqlDB cluster is created in your CC cluster, you need to configure ACLs so that you can use ksqlDB commands against a Topic.
It takes 2 parameters:
-1 = Cluster_Name
-2 = Topic_Name
#### Example to use it:
`sh ./ksqldb-set-acl-to-topics.sh My_Azure_Cluster My_Topic_Name`
