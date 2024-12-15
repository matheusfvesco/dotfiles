# mandatory
echo "export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}" >> ~/.zshrc

echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> .zshrc

sudo apt update
sudo apt-get install g++ freeglut3-dev build-essential libx11-dev \
    libxmu-dev libxi-dev libglu1-mesa-dev libfreeimage-dev libglfw3-dev

sudo apt install cudnn
