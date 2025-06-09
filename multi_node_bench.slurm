#!/bin/bash
#SBATCH --job-name=nccl-test
#SBATCH --nodes=4
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:rtx2080ti:4
#SBATCH --time=1:30:00
#SBATCH --partition=gpu
#SBATCH --output=nccl_test_%j.out


# Optional network tuning — required to prevent process freezes/failures if not configured
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=ens3  # or ib0 if using InfiniBand
export NCCL_P2P_DISABLE=1
export NCCL_IB_DISABLE=1


# set environment variables needed for pytorch DDP
export WORLD_SIZE=$SLURM_NTASKS
export RANK=$SLURM_PROCID
export LOCAL_RANK=$SLURM_LOCALID

# get the first node as master address
echo "NODELIST="${SLURM_NODELIST}
master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr
export MASTER_PORT=6000
echo "MASTER_ADDR="$MASTER_ADDR":"$MASTER_PORT

DIR=$(realpath .)
mkdir -p $DIR/runs

command="
cd $DIR && torchrun \
	--nproc_per_node=4 \
	--nnodes $WORLD_SIZE \
	--rdzv_endpoint $MASTER_ADDR:$MASTER_PORT \
	--rdzv_backend c10d \
	--max_restarts 0 \
	--role `hostname -s`: \
	--tee 3 \
	all_reduce_benchmark.py"

echo $command

DATETIME=`date +'date_%y-%m-%d_time_%H-%M-%S'`
srun -u --output=$DIR/runs/%x_%j_$DATETIME.log bash -c "${command}"

