#!/bin/bash

BACKUP_DIR=$1

gzip -c /var/lib/pve-cluster/config.db > $BACKUP_DIR/config_$(date +%Y%m%d).db.gz
find $BACKUP_DIR -type f -mtime +30 -delete
