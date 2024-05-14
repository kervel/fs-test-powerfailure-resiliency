#!/bin/bash

# Configuration variables
vm_image="image.qcow2"
log_file="logfile.log"
ssh_key="./id_vm_rsa"
ssh_port=2228  # Local host port configured for SSH forwarding
db_user="postgres"  # PostgreSQL username
db_name="mydatabase"  # PostgreSQL database name


check_vm_health() {
    # SSH to localhost on the forwarded port to execute a PostgreSQL command
    # The command will log in to PostgreSQL and run a SELECT COUNT(*) from a table
    result=$(ssh -o StrictHostKeyChecking=no -i $ssh_key -p $ssh_port root@localhost \
        "sudo -u $db_user bash -c \"cd /; psql -d $db_name -c 'SELECT COUNT(*) FROM test;' \"" 2>/dev/null)
    echo $result
}

start_vm() {
    # Start the VM with port forwarding
    (qemu-system-x86_64 -enable-kvm -display none -daemonize -m 2G -drive file=$vm_image,format=qcow2,id=disk0,if=none,cache=none \
        -device ahci,id=ahci \
        -device ide-hd,drive=disk0,bus=ahci.0 \
        -net nic -net user,hostfwd=tcp::${ssh_port}-:22 \
    ) &    
}

stop_vm() {
	pkill -f "qemu-system-x86_64.*$vm_image"  # Terminate the VM process
}

ssh-keygen -f "/home/kervel/.ssh/known_hosts" -R "[localhost]:2228"

echo "starting for first time, waiting longer"
start_vm
sleep 300
stop_vm
echo "now starting cycle"
# Main loop
while true; do
    # Start the VM with port forwarding
    start_vm
    # Wait a bit for the VM to fully start up
    sleep 60  # Adjust as needed

    # Perform the health check
    echo "Performing health check..."
    health_result=$(check_vm_health)
    echo "Health check result: $health_result"

    if [[ $health_result =~ "row" ]]; then
        echo "$(date): Health check passed - $health_result" >> $log_file
    else
        echo "$(date): Health check failed - $health_result" >> $log_file
    fi

    # Power cycle the VM (simulate power failure)
    stop_vm
    sleep 5  # Ensure the VM is fully down before restarting

    # Logging
    echo "$(date): Restarting VM" >> $log_file
done