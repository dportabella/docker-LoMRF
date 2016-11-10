FROM hseeberger/scala-sbt
MAINTAINER David Portabella <david.portabella@gmail.com>

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y wget git

# Gurobi: http://www.gurobi.com/ -> Get Gurobi -> For Academic Users -> Visit our Academia Center -> Download the latest version of Gurobi -> Gurobi Optimizer
# http://packages.gurobi.com/7.0/gurobi7.0.1_linux64.tar.gz
RUN cd /opt && \
    wget -O- http://packages.gurobi.com/7.0/gurobi7.0.1_linux64.tar.gz | tar -xvzf - && \
    echo 'export GUROBI_HOME="/opt/gurobi701/linux64"' >>/root/.bashrc && \
    echo 'export PATH="${PATH}:${GUROBI_HOME}/bin"' >>/root/.bashrc && \
    echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"' >>/root/.bashrc


# Gurobi license
# Get a license if you are using the Gurobi solver:
# Unfortunatelly you won't be able to use the free single-machine academic license, since this is running in a floating container (docker),
# so you need to contact them and ask for a "free multi-user academic site license (Unlimited-Simultaneous-Use, Floating-Use academic license)".
# http://www.gurobi.com/ -> Get Gurobi -> For Academic Users -> Visit our Academia Center -> Get the Right License -> Academic Licenses
# Follow instructions to create the file /opt/gurobi/gurobi.lic (you will need to execute this command with the provided code)
# grbgetkey ........-....-....-.................


# lpsolve55 & lpsolve55j
RUN mkdir /lib/lpsolve55 && \
    echo 'export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/lib/lpsolve55"' >>/root/.bashrc


# lpsolve: https://sourceforge.net/projects/lpsolve/
# http://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_dev_ux64.tar.gz?r=&ts=1478705377&use_mirror=netcologne
# https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_dev_ux64.tar.gz
RUN cd /lib/lpsolve55 && \
    wget -O- "https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_dev_ux64.tar.gz" | tar -xvzf - liblpsolve55.so


# lpsolvej: https://sourceforge.net/projects/lpsolve/
# http://downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip?r=&ts=1478705757&use_mirror=heanet
# https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip
RUN cd /tmp/ && \
    wget "https://github.com/dportabella/3rd-party-mirror/raw/master/files/downloads.sourceforge.net/project/lpsolve/lpsolve/5.5.2.5/lp_solve_5.5.2.5_java.zip" && \
    cd /lib/lpsolve55 && \
    unzip -j /tmp/lp_solve_5.5.2.5_java.zip lp_solve_5.5_java/lib/ux64/liblpsolve55j.so && \
    rm /tmp/lp_solve_5.5.2.5_java.zip


# auxlib: https://github.com/anskarl/auxlib
RUN cd /tmp && \
    git clone https://github.com/anskarl/auxlib.git && \
    cd auxlib && \
    sbt ++2.11.8 publishLocal && \
    cd && \
    rm -Rf /tmp/auxlib


# Optimus: https://github.com/vagmcs/Optimus
RUN cd /tmp && \
    git clone https://github.com/vagmcs/Optimus.git && \
    cd Optimus && \
    mkdir lib && \
    cp /opt/gurobi701/linux64/lib/gurobi.jar lib/ && \
    sbt publishLocal && \
    cd && \
    rm -Rf /tmp/Optimus


# LoMRF: https://github.com/anskarl/LoMRF
RUN cd /tmp && \
    git clone https://github.com/anskarl/LoMRF.git && \
    cd LoMRF && \
    git submodule update --init && \
    sbt dist && \
    cd /opt && \
    unzip /tmp/LoMRF/target/universal/lomrf-0.5.1.zip && \
    cp /opt/gurobi701/linux64/lib/gurobi.jar /opt/lomrf-0.5.1/lib/ && \
    cd && \
    rm -Rf /tmp/LoMRF && \
    echo 'export LOMRF_HOME="/opt/lomrf-0.5.1"' >>/root/.bashrc && \
    echo 'export PATH="${PATH}:${LOMRF_HOME}/bin"' >>/root/.bashrc


# clean ivy2 cache
RUN rm -Rf /root/.ivy2


# test it is installed
RUN . /root/.bashrc && which lomrf
