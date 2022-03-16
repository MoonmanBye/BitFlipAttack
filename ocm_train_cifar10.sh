#!/bin/bash
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo $dt

data="CIFAR10"
dir="data/"
model="resnet20_quan"
classes=10

# Train vanilla and piecewise clustering regularized ResNet-20 networks (8-bit) and OCM models on CIFAR-10
python -u main.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --outdir "results/cifar10/resnet20_quan8/"
python -u main.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --outdir "results/cifar10/resnet20_quan8_PC/" -pc -lam 1e-3
python -u main.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --ocm --code_length 16 --output_act "tanh" -wd 1e-4 --outdir "results/cifar10/resnet20_quan8_OCM16/"
python -u main.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --ocm --code_length 32 --output_act "tanh" -wd 1e-4 --outdir "results/cifar10/resnet20_quan8_OCM32/"
python -u main.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --ocm --code_length 64 --output_act "tanh" -wd 1e-4 --outdir "results/cifar10/resnet20_quan8_OCM64/"

# Evaluate Stealthy TA-LBF and Stealthy T-BFA attacks on OCM defended models
python -u attack_talbf.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --ocm --code_length 64 --output_act "tanh" --outdir "results/cifar10/resnet20_quan8_OCM64/"
python -u attack_tbfa.py --data_dir $dir --dataset $data -c $classes --arch $model --bits 8 --ocm --code_length 64 --output_act "tanh" --outdir "results/cifar10/resnet20_quan8_OCM64/"