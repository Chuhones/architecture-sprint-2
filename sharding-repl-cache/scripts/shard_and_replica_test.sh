#!/bin/bash
docker compose exec -T mdb-sh1-rep1 mongosh --port 27118 --quiet <<EOF
use somedb
print("mdb-sh1-rep1 contains " + db.helloDoc.countDocuments() + " records")
exit()
EOF
docker compose exec -T mdb-sh1-rep2 mongosh --port 27218 --quiet <<EOF
use somedb
print("mdb-sh1-rep2 contains " + db.helloDoc.countDocuments() + " records")
exit()
EOF
docker compose exec -T mdb-sh1-rep3 mongosh --port 27318 --quiet <<EOF
use somedb
print("mdb-sh1-rep3 contains " + db.helloDoc.countDocuments() + " records")
exit()
EOF
docker compose exec -T mdb-sh2-rep1 mongosh --port 27119 --quiet <<EOF
use somedb
print("mdb-sh2-rep3 contains " + db.helloDoc.countDocuments() + " records")
exit()
EOF
docker compose exec -T mdb-sh2-rep2 mongosh --port 27219 --quiet <<EOF
use somedb
print("mdb-sh2-rep3 contains " + db.helloDoc.countDocuments() + " records")
exit()
EOF
docker compose exec -T mdb-sh2-rep3 mongosh --port 27319 --quiet <<EOF
use somedb
print("mdb-sh2-rep3 contains " + db.helloDoc.countDocuments() + " records")
exit()
EOF
sleep 2s
