function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    python --version
    if [ "$uname -m" == aarch64 ]; then
    PYTHON_EXE=`which python`
    PYTHON_EXE --version
    PYTHON_VERSION=$(PYTHON_EXE --version)
    #PYTHON_VERSION=${PYTHON_EXE:14:1}.${PYTHON_EXE:15:1}
    yum -y install wget
    wget -q https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh -O miniconda.sh
    MINICONDA_PATH=/home/miniconda
    chmod +x miniconda.sh && ./miniconda.sh -b -p $MINICONDA_PATH
    export PATH=$MINICONDA_PATH/bin:$PATH
    conda create -n testenv --yes python=$PYTHON_VERSION pip
    source activate testenv
    conda install -c conda-forge statsmodels
    fi
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    MPLBACKEND="agg" python -c "import linearmodels; linearmodels.test(['-n','auto','--skip-slow','--skip-smoke'])"
}

function install_run {
    # Override multibuild test running command, to preinstall packages
    # that have to be installed before TEST_DEPENDS.
    set -ex
    if [ `uname -m` == 'aarch64' ]; then
    #apt-get -y install wget
    PYTHON_VERSION=$(python --version)
    #PYTHON_EXE=`which python`
    #PYTHON_EXE --version
    #PYTHON_VERSION=$(PYTHON_EXE --version)
    #$PYTHON_EXE -m pip install packaging
    PYTHON_EXE=${PYTHON_VERSION:7:1}.${PYTHON_VERSION:9:1}
    wget -q https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh -O miniconda.sh
    MINICONDA_PATH=/home/miniconda
    chmod +x miniconda.sh && ./miniconda.sh -b -p $MINICONDA_PATH
    export PATH=$MINICONDA_PATH/bin:$PATH
    conda create -n testenv --yes python=$PYTHON_EXE pip
    source activate testenv
    conda install -c conda-forge statsmodels
    
    # Copypaste from multibuild/common_utils.sh:install_run
    install_wheel
    mkdir tmp_for_test
    (cd tmp_for_test && run_tests)
    fi
}
