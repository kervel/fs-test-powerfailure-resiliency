set -ex
sudo apt install zerofree
sudo pip install git+https://gitlab.com/larswirzenius/vmdb2.git
sudo vmdb2 -v --log DEBUG  test.vmdb --output=foo.img --rootfs-tarball root.tgz
qemu-img convert -f raw -O qcow2 foo.img image.qcow2
