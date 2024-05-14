#!/bin/bash

# Configuration variables
vm_image="image.qcow2"
log_file="logfile.log"
ssh_key="./id_vm_rsa"
ssh_port=2228  # Local host port configured for SSH forwarding
db_user="postgres"  # PostgreSQL username
db_name="mydatabase"  # PostgreSQL database name

ssh -o StrictHostKeyChecking=no -i $ssh_key -p $ssh_port root@localhost

