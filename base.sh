#!/bin/bash

# Install ansible
sudo apt install python3 python3-pip -y

if ! [ -x "$(command -v ansible)" ]; then
	sudo python3 -m pip install ansible
	ansible-galaxy install diodonfrost.p10k
	ansible-galaxy install geerlingguy.docker
	ansible-galaxy install christiangda.awscli
fi

# Install conda
if ! [ -x "$(command -v conda)" ]; then
	mkdir -p ~/miniconda3
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
	bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
	rm -rf ~/miniconda3/miniconda.sh
	~/miniconda3/bin/conda init bash
fi
