#!/bin/bash
docker compose up -d
docker compose exec -T mdb-config1 mongosh --port 27017 --quiet <<EOF
rs.initiate( { _id : "mdb-config1", configsvr: true, members: [ { _id : 0, host : "mdb-config1:27017" } ] } );
exit();
EOF
docker compose exec -T mdb-shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate({_id: "mdb-shard1", members: [ { _id: 0, host: "mdb-shard1:27018" } ] } );
exit();
EOF
docker compose exec -T mdb-shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate( { _id : "mdb-shard2", members: [ { _id : 1, host : "mdb-shard2:27019" } ] } );
exit();
EOF
docker compose exec -T mdb-router1 mongosh --port 27020 --quiet <<EOF
sh.addShard( "mdb-shard1/mdb-shard1:27018");
sh.addShard( "mdb-shard2/mdb-shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
exit();
EOF
