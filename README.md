# Hardware Benchmarks

This is a simple repo to keep some hardware benchmark scripts. 

## Run single node all-reduce over the 4 GPUs of a todi node
```
sbatch single_node_bench.slurm
```
This should give you roughly
```
The average bandwidth of all_reduce with a 4.0GB payload (20 trials, 4 ranks):
 algbw: 218.635 GBps (1749.1 Gbps)
 busbw: 327.952 GBps (2623.6 Gbps)
```

## Run multi node all-reduce
You can selected the number of nodes by chaning the SBATCH --nodes argument.
```
sbatch multi_node_bench.slurm
```

### 2 todi nodes
without nccl annotations in the env toml file
```
The average bandwidth of all_reduce with a 4.0GB payload (20 trials, 8 ranks):
 algbw: 2.019 GBps (16.1 Gbps)
 busbw: 3.533 GBps (28.3 Gbps)
```
with the nccl plugin
```
The average bandwidth of all_reduce with a 4.0GB payload (20 trials, 8 ranks):
 algbw: 52.186 GBps (std: 0.013) (417.5 Gbps)
 busbw: 91.325 GBps (730.6 Gbps)
```

### 4 todi nodes
without nccl annotations in the env toml file
```
The average bandwidth of all_reduce with a 4.0GB payload (20 trials, 16 ranks):
 algbw: 0.979 GBps (7.8 Gbps)
 busbw: 1.835 GBps (14.7 Gbps)
```
with the nccl plugin
```
The average bandwidth of all_reduce with a 4.0GB payload (20 trials, 16 ranks):
 algbw: 48.686 GBps (std: 0.015) (389.5 Gbps)
 busbw: 91.287 GBps (730.3 Gbps)
```

### 8 nodes
```
todo
```
