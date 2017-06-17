# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -n "$IS_OSX" ]; then
        export CC=clang
        export CXX=clang++
    fi
    SRC_DIR=lda
    pip install -r $SRC_DIR/requirements.txt
}

function run_tests {
    SRC_DIR=../lda
    echo "basic checks"
    python -c "import sys; print('\n'.join(sys.path))"
    python -c "import lda"
    pip install -r $SRC_DIR/requirements.txt
    pip install -r $SRC_DIR/test-requirements.txt
    if [ -n "$IS_OSX" ]; then
      # bug affects certain combinations of numpy and scipy on os x
      pip install -U numpy scipy
    fi
    echo "testing"
    python -m unittest lda.tests.test_lda
}
