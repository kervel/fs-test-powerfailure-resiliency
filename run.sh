qemu-system-x86_64 -nographic -hda image.qcow2 -m 4G -enable-kvm  -net nic -net user,hostfwd=tcp::2228-:22
