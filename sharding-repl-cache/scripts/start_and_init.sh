#!/bin/bash
docker compose up -d
docker compose exec -T mdb-config1 mongosh --port 27017 --quiet <<EOF
rs.initiate( { _id : "mdb-config1", configsvr: true, members: [ { _id : 0, host : "mdb-config1:27017" } ] } );
exit();
EOF
sleep 1s
docker compose exec -T mdb-sh1-rep1 mongosh --port 27118 --quiet <<EOF
rs.initiate( {
      _id: "mdb-shard1",
      members: [
        { _id: 0, host: "mdb-sh1-rep1:27118" },
        { _id: 1, host: "mdb-sh1-rep2:27218" },
        { _id: 2, host: "mdb-sh1-rep3:27318" } ] } );
exit();
EOF
sleep 1s
docker compose exec -T mdb-sh2-rep1 mongosh --port 27119 --quiet <<EOF
rs.initiate( {
      _id : "mdb-shard2",
      members: [
        { _id : 0, host : "mdb-sh2-rep1:27119" },
        { _id : 1, host : "mdb-sh2-rep2:27219" },
        { _id : 2, host : "mdb-sh2-rep3:27319" } ] } );
exit();
EOF
sleep 1s
docker compose exec -T mdb-router1 mongosh --port 27020 --quiet <<EOF
sh.addShard( "mdb-shard1/mdb-sh1-rep1:27118");
sh.addShard( "mdb-shard2/mdb-sh2-rep1:27119");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
exit();
EOF
