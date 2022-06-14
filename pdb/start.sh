docker build -t psql .
export PSQL_CONTAINER=$(docker create psql)
echo "Container: $PSQL_CONTAINER"
mkdir /pdb/rootfs
docker export $PSQL_CONTAINER | tar -C /pdb/rootfs -xf -
echo "Exported"
docker inspect -f "{{json .Config.Env}}" psql >>/pdb/rootfs/env.json
echo "Env generated"
mkdir /mnt/bin
wget -O /mnt/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
chmod +x /mnt/bin/dumb-init
echo "Runc starting"
runc run --detach --bundle /pdb/ testing &>/dev/null </dev/null
sleep 5
runc exec testing psql --username=postgres -c "SELECT 1"
runc exec testing ls -la /var/run/postgresql
echo "Checkpoint starting"
runc checkpoint --image-path /pdb/checkpoint --work-path /tmp testing
runc list
echo "Restoring"
runc restore --image-path /pdb/checkpoint/ --work-path /tmp --detach --bundle /pdb/ testing
sleep 2
runc exec testing ls -la /var/run/postgresql
