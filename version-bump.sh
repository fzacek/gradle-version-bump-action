#!/bin/bash

# Directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#
# Takes a version number, and the mode to bump it, and increments/resets
# the proper components so that the result is placed in the variable
# `NEW_VERSION`.
#
# $1 = mode (major, minor, patch)
# $2 = version (x.y.z)
#
function bump {
  local mode="$1"
  local old="$2"
  local parts=( ${old//./ } )
  case "$1" in
    major)
      local bv=$((parts[0] + 1))
      NEW_VERSION="${bv}.0.0"
      ;;
    minor)
      local bv=$((parts[1] + 1))
      NEW_VERSION="${parts[0]}.${bv}.0"
      ;;
    patch)
      local bv=$((parts[2] + 1))
      NEW_VERSION="${parts[0]}.${parts[1]}.${bv}"
      ;;
    esac
}

git config --global user.email $EMAIL
git config --global user.name $NAME

OLD_VERSION=$($DIR/get-version.sh)

BUMP_MODE="none"
if git log -1 | grep -q "#major"; then
  BUMP_MODE="major"
elif git log -1 | grep -q "#minor"; then
  BUMP_MODE="minor"
else
  BUMP_MODE="patch"
fi

BUILD_FILE=$GRADLEPATH/build.gradle
TYPE=GROOVY
if [ ! -f "$BUILD_FILE" ] ; then
    BUILD_FILE=$GRADLEPATH/build.gradle.kts
    TYPE=KOTLIN
fi

if [[ "${BUMP_MODE}" == "none" ]]
then
  echo "No matching commit tags found."
  echo "build.gradle at" $GRADLEPATH "will remain at" $OLD_VERSION
else
  echo $BUMP_MODE "version bump detected"
  bump $BUMP_MODE $OLD_VERSION
  echo "build.gradle at " $GRADLEPATH " will be bumped from" $OLD_VERSION "to" $NEW_VERSION
  if [ "${TYPE}" == "GROOVY" ]; then
      sed -i "s/$OLD_VERSION/$NEW_VERSION/" $BUILD_FILE
  elif [ "${TYPE}" == "KOTLIN" ]; then
      sed -i "s/version = \"$OLD_VERSION\"/version = \"$NEW_VERSION\"/" $BUILD_FILE
  fi
  git add $BUILD_FILE
  REPO="https://$GITHUB_ACTOR:$TOKEN@github.com/$GITHUB_REPOSITORY.git"
  git commit -m "Bump build.gradle from $OLD_VERSION to $NEW_VERSION"
  git tag $NEW_VERSION
  git push $REPO --follow-tags
  git push $REPO --tags
fi
