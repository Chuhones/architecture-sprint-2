#!/bin/bash
docker compose exec -T mdb-shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF
docker compose exec -T mdb-shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF