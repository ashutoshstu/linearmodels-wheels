function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ "$uname -m" == aarch64 ]; then
    yum -y install wget
    wget https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh -O miniconda.sh
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
