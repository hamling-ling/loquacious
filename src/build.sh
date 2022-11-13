#!/bin/bash

exit_on_error() {
    msg=$1
    echo $msg
    exit 1
}

# Clean
OPT_CLEAN=0
# ビルドするだけ (今のところ Linux 上で単体テストはしない)
OPT_BUILD=0

for opt in "$@"
do
    if [ "$opt" = "clean" ] ; then
        OPT_CLEAN=1
    fi
    if [ "$opt" = "build" ] ; then
        OPT_BUILD=1
    fi
done

if [ $OPT_CLEAN -eq 0 ]&& [ $OPT_BUILD -eq 0 ] ; then
    OPT_CLEAN=1
    OPT_BUILD=1
fi

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
REPO_ROOT=$(realpath "$SCRIPTPATH"/../)

BUILD_DIR=build
SRC_DIR=src/SpeechTrainer
ARTIFACT_DIR=artifact

# Create build directory
mkdir -p $BUILD_DIR

# Cleanup
if [ $OPT_CLEAN -eq 1 ] ; then
    rm -rf $BUILD_DIR/*
    echo "build directory cleaned"
fi

# Build and run unit tests
if [ $OPT_BUILD -eq 1 ] ; then
    cmake -G "Ninja" \
      -DCMAKE_FIND_ROOT_PATH=/opt/Qt/6.2.4/android_armv7 \
      -DQT_HOST_PATH=/opt/Qt/6.2.4/gcc_64 \
      -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
      -DCMAKE_PREFIX_PATH=/opt/Qt/6.2.4/android_armv7/lib/cmake/Qt6 \
      -DANDROID_NDK=$ANDROID_NDK \
      -DANDROID_SDK_ROOT=$ANDROID_SDK_ROOT \
      -S "$REPO_ROOT"/"$SRC_DIR" \
      -B "$REPO_ROOT"/"$BUILD_DIR" || exit_on_error "build CMakeFiles failed"
    pushd "$REPO_ROOT"/"$BUILD_DIR" && \
    cmake --build . || exit_on_error "build binary failed"
    popd

    mkdir -p $ARTIFACT_DIR
    mv "$REPO_ROOT"/"$BUILD_DIR"/android-build/appSpeechTrainer.apk $ARTIFACT_DIR/
fi

