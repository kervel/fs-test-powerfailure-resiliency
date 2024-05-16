# Powerfail resiliency testing

This is an attempt at benchmarking how many power failures a machine can survive without manual intervention.
The test setup is:

* a debian VM (provisioned with vmdb2)
* postgres running
* some simulated read-write workload in postgres
* kill qemu every few minutes, restart it, and check whether postgres is still starting up and running fine

The supervisor script (doing the health checking and the rebooting) is [here](cycle.sh).
The workload script (simulated workload in VM) is [here](data/bench/bench.sh)

# Requirements

* vmdb2: don't install the apt version, use the one straight from gitlab (i use copy-tree which is new) 

```shell
pip install git+https://gitlab.com/larswirzenius/vmdb2.git
```

* debootstrap
* some utilities (zerofree)
* qemu with kvm (qemu-system-common qemu-system-x86)
* some free disk space (couple of GB)

## how to

* run the build.sh script to build the vm image
* run the cycle.sh script to start cycling, inside a tmux (it doesn't daemonize).
* check the logfile

# First results

* so far the ext4 machine survived 820 reboots without postgres failing to start.
