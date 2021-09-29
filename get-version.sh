#!/bin/sh

$GRADLEPATH/gradlew properties --no-daemon --console=plain -q --build-file $GRADLEPATH/build.gradle | grep "^version:" | awk '{printf $2}'
