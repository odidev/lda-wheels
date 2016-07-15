# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        export CC=clang
        export CXX=clang++
        brew install pkg-config
    fi
}

function build_wheel {
    # Override common_utils build_wheel function to fix version error
    # pbr is easily confused about what git repository it is in, provide version
    PBR_VERSION=${BUILD_COMMIT} build_bdist_wheel $@
}

function run_tests {
    SRC_DIR=../lda
    echo "sanity checks"
    python -c "import sys; print('\n'.join(sys.path))"
    python -c "import lda"
    pip install -r $SRC_DIR/requirements.txt
    pip install -r $SRC_DIR/test-requirements.txt
    pip install nose

    echo "testing"
    nosetests lda
}
