#!/bin/bash

export CONFIG_FILE=./configs/kitti/panoptic_deeplab/resnet50_os32_trainval_debug.textproto
export BASE_MODEL_DIRECTORY=./exp/
export NUM_GPUS=4

# export EXPERIMENT_NAME=panoptic_test
python -m debugpy --listen 5678 --wait-for-client \
	trainer/train.py \
	--config_file=${CONFIG_FILE} \
	--mode=train \
	--model_dir=${BASE_MODEL_DIRECTORY} \
	--num_gpus=${NUM_GPUS}
