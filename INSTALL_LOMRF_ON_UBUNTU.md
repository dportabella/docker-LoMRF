# Install LoMRF on Ubuntu

Quick instructions to install [LoMRF](https://github.com/anskarl/LoMRF) on Ubuntu.

Note: There is already an [docker image](https://github.com/dportabella/docker-lomrf) with Ubuntu and LoMRF installed.

Note: Follow these other instructions to [install LoMRF on OSX](https://github.com/dportabella/docker-lomrf/blob/master/INSTALL_LOMRF_ON_OSX.md).

Requirements: install wget, git, java8, scala and sbt ([example installation script](https://github.com/hseeberger/scala-sbt/blob/master/Dockerfile)).

```
# Gurobi: http://www.gurobi.com/
cd /tmp
wget http://packages.gurobi.com/7.0/gurobi7.0.1_linux64.tar.gz
cd /opt
tar -xvzf /tmp/gurobi7.0.1_linux64.tar.gz
cd gurobi701/linux64/
rm /tmp/gurobi7.0.1_linux64.tar.gz
echo 'export GUROBI_HOME="/opt/gurobi701/linux64"' >>/root/.bashrc
echo 'export PATH="${PATH}:${GUROBI_HOME}/bin"' >>/root/.bashrc
echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"' >>/root/.bashrc

# Gurobi license: http://www.gurobi.com/ -> Get Gurobi -> For Academic Users -> Visit our Academia Center -> Get the Right License -> Academic Licenses -> [sign in or register] -> Request License
# Follow instructions to create the file /opt/gurobi/gurobi.lic (you will need to execute this command with the provided code)
# grbgetkey ........-....-....-.................


# lpsolve55 & lpsolve55j
mkdir /lib/lpsolve55
echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/lib/lpsolve55"' >>/root/.bashrc


# lpsolve: https://sourceforge.net/projects/lpsolve/
cd /tmp
# wget "http://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_dev_ux64.tar.gz?r=&ts=1478705377&use_mirror=netcologne"
wget "https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_dev_ux64.tar.gz"
cd /lib/lpsolve55
tar -xvzf /tmp/lp_solve_5.5.2.5_dev_ux64.tar.gz liblpsolve55.so
rm /tmp/lp_solve_5.5.2.5_dev_ux64.tar.gz


# lpsolvej: https://sourceforge.net/projects/lpsolve/
cd /tmp/
# wget "http://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip?r=&ts=1478705757&use_mirror=heanet"
wget "https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip"
cd /lib/lpsolve55
unzip -j /tmp/lp_solve_5.5.2.5_java.zip lp_solve_5.5_java/lib/ux64/liblpsolve55j.so
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
cp /opt/gurobi701/linux64/lib/gurobi.jar lib/
sbt publishLocal
cd
rm -Rf /tmp/Optimus


# LoMRF: https://github.com/anskarl/LoMRF
cd /tmp
git clone https://github.com/anskarl/LoMRF.git
cd LoMRF
git submodule update --init
sbt dist
cd /opt
unzip /tmp/LoMRF/target/universal/lomrf-0.5.1.zip
cp /opt/gurobi701/linux64/lib/gurobi.jar /opt/lomrf-0.5.1/lib/  # workaround: this should not be needed
cd
rm -Rf /tmp/LoMRF
echo 'export LOMRF_HOME="/opt/lomrf-0.5.1"' >>/root/.bashrc
echo 'export PATH="${PATH}:${LOMRF_HOME}/bin"' >>/root/.bashrc


# clean ivy2 cache
rm -Rf /root/.ivy2


# test it is installed
. /root/.bashrc
lomrf --help
```

Disclaimer: I am not affiliated to the authors of the [LoMRF](https://github.com/anskarl/LoMRF) software.
