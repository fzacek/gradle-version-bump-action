#!/bin/sh

BUILD_FILE=$GRADLEPATH/build.gradle
if [ ! -f "$BUILD_FILE" ] ; then
    BUILD_FILE=$GRADLEPATH/build.gradle.kts
fi

"$GRADLEPATH"/gradlew properties --no-daemon --console=plain -q --build-file "$BUILD_FILE" | grep "^version:" | awk '{printf $2}'
