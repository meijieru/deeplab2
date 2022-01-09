conda create -n deeplab2 python=3
conda activate deeplab2
# conda install tensorflow-gpu -y
conda install ipython cython matplotlib pillow -y
# conda install protobuf -y
pip install tensorflow
pip install pycocotools

export PROJECT_ROOT=~/workspace/machine_learning/segmentation/deeplab2
# export DATA_ROOT=/mnt/data1/jrmei
export DATA_ROOT=/media/5TB1/jrmei
export KITTI_STEP_ROOT=${DATA_ROOT}/kitti_step
export OUTPUT_DIR=${DATA_ROOT}/kitti_step_tf
export TF_LIB_ROOT=~/lib/anaconda/envs/deeplab2/lib/python3.9/site-packages/tensorflow

mkdir $OUTPUT_DIR $KITTI_STEP_ROOT
cd $KITTI_STEP_ROOT
mkdir images
cd images
wget -O data_tracking_image_2.zip https://s3.eu-central-1.amazonaws.com/avg-kitti/data_tracking_image_2.zip
unzip ./data_tracking_image_2.zip

mv testing/image_02/ test/
rm -r testing/

mkdir val
mv training/image_02/0002 val/
mv training/image_02/0006 val/
mv training/image_02/0007 val/
mv training/image_02/0008 val/
mv training/image_02/0010 val/
mv training/image_02/0013 val/
mv training/image_02/0014 val/
mv training/image_02/0016 val/
mv training/image_02/0018 val/

mv training/image_02/ train/
rm -r training

cd ..
wget https://storage.googleapis.com/gresearch/tf-deeplab/data/kitti-step.tar.gz
tar -xvf kitti-step.tar.gz
mv kitti-step/panoptic_maps panoptic_maps
rm -r kitti-step

cd $PROJECT_ROOT
PYTHONPATH=. python deeplab2/data/build_step_data.py --step_root=${KITTI_STEP_ROOT} --output_dir=${OUTPUT_DIR}

cd $PROJECT_ROOT
git clone https://github.com/tensorflow/models.git

mkdir -p ${TF_LIB_ROOT}/include/third_party/gpus/cuda
ln -s /usr/local/cuda/include $TF_LIB_ROOT/include/third_party/gpus/cuda/

bash ./deeplab2/compile.sh gpu
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/models

mkdir $PROJECT_ROOT/deeplab2/checkpoints -p
cp $PROJECT_ROOT/deeplab2/checkpoints
wget https://storage.googleapis.com/gresearch/tf-deeplab/checkpoint/resnet50_imagenet1k_strong_training_strategy.tar.gz -O ckpt.tar.gz
tar xzf ckpt.tar.gz
rm ckpt.tar.gz

# https://askubuntu.com/questions/1336425/no-module-named-uaclient-during-sudo-apt-upgrade-ubuntu-16-04
# https://www.tensorflow.org/install/gpu?hl=zh-cn
