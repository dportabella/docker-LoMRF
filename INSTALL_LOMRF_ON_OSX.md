# Install LoMRF on OSX

Quick instructions to install [LoMRF](https://github.com/anskarl/LoMRF) on OSX.

Note: There is already an [docker image](https://github.com/dportabella/docker-lomrf) with Ubuntu and LoMRF installed.

Note: Follow these other instructions to [install LoMRF on Ubuntu](https://github.com/dportabella/docker-lomrf/blob/master/INSTALL_LOMRF_ON_UBUNTU.md).

Requirements: install git, [brew](http://brew.sh/), java8, scala and sbt.

```
# Gurobi: http://www.gurobi.com/ -> Get Gurobi -> For Academic Users -> Visit our Academia Center -> Download the latest version of Gurobi -> Gurobi Optimizer
cd /tmp
download and install http://packages.gurobi.com/7.0/gurobi7.0.1_mac64.pkg

# Gurobi license: http://www.gurobi.com/ -> Get Gurobi -> For Academic Users -> Visit our Academia Center -> Get the Right License -> Academic Licenses -> [sign in or register] -> Request License
# Follow instructions to create the file ~/gurobi.lic (you will need to execute this command with the provided code)
# grbgetkey ........-....-....-.................


# lpsolve: https://sourceforge.net/projects/lpsolve/
brew tap homebrew/science
brew install lp_solve
sudo cp /usr/local/Cellar/lp_solve/5.5.2.0/lib/liblpsolve55.dylib /Library/Java/Extensions/


# lpsolvej: https://sourceforge.net/projects/lpsolve/
cd /tmp
# wget "http://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip?r=&ts=1477991262&use_mirror=kent"
wget "https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip"
unzip lp_solve_5.5.2.5_java.zip
cd lp_solve_5.5_java/lib/mac

# edit build-osx and replace
# LPSOLVE_DIR=/Users/spkane/Desktop/mac/downloads/lp_solve/lp_solve_5.5
# by
# LPSOLVE_DIR=/tmp/lp_solve_5.5
. build-osx
sudo cp liblpsolve55j.jnilib /Library/Java/Extensions/
cd
rm /tmp/lp_solve_5.5.2.5_java.zip


# auxlib: https://github.com/anskarl/auxlib
cd /tmp
git clone https://github.com/anskarl/auxlib.git
cd auxlib
sbt ++2.11.8 publishLocal
cd
rm -Rf /tmp/auxlib


# Optimus: https://github.com/vagmcs/Optimus
cd /tmp
git clone https://github.com/vagmcs/Optimus.git
cd Optimus
mkdir lib
cp /Library/Java/Extensions/gurobi.jar lib/
sbt publishLocal
cd
rm -Rf /tmp/Optimus


# LoMRF: https://github.com/anskarl/LoMRF
cd /tmp
git clone https://github.com/anskarl/LoMRF.git
cd LoMRF
git submodule update --init
sbt dist
mkdir -p ~/bin
cd ~/bin
unzip /tmp/LoMRF/target/universal/lomrf-0.5.1.zip
cd
rm -Rf /tmp/LoMRF
echo 'export LOMRF_HOME="{$HOME}/bin/lomrf-0.5.1"' >>~/.bashrc
echo 'export PATH="${PATH}:${LOMRF_HOME}/bin"' >>~/.bashrc


# optionally clean ivy2 cache
# rm -Rf ~/.ivy2


# test it is installed
. ~/.bashrc
lomrf --help
```

Disclaimer: I am not affiliated to the authors of the [LoMRF](https://github.com/anskarl/LoMRF) software.
