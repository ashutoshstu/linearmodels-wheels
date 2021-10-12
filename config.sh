function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    python --version
    if [ "$uname -m" == aarch64 ]; then
    yum -y install wget
    wget -q https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh -O miniconda.sh
    MINICONDA_PATH=/home/travis/miniconda
    chmod +x miniconda.sh && ./miniconda.sh -b -p $MINICONDA_PATH
    export PATH=$MINICONDA_PATH/bin:$PATH
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
    if [ `uname -m` == `aarch64` ]; then
    yum -y install wget
    wget -q https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh -O miniconda.sh
    MINICONDA_PATH=/home/travis/miniconda
    chmod +x miniconda.sh && ./miniconda.sh -b -p $MINICONDA_PATH
    export PATH=$MINICONDA_PATH/bin:$PATH
    conda install -c conda-forge statsmodels
    
    # Copypaste from multibuild/common_utils.sh:install_run
    install_wheel
    mkdir tmp_for_test
    (cd tmp_for_test && run_tests)
    fi
}
