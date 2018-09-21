#!/bin/sh

CMAKE_SOURCE_DIR=$1
CMAKE_BINARY_DIR=$2
VER_MAJOR=$3
VER_MINOR=$4
VER_MICRO=$5
HDR_NAME="$CMAKE_BINARY_DIR/autogenerated_version_info.h"

update_header() {
    NEW_CONTENT="const char *g_version_info = \"v$VER_MAJOR.$VER_MINOR.$VER_MICRO, $1\";"
    OLD_CONTENT=$(cat "$HDR_NAME" 2>/dev/null)
    if [ "$NEW_CONTENT" != "$OLD_CONTENT" ]; then
        echo "$NEW_CONTENT" > $HDR_NAME
    fi
}

GIT_COMMAND_EXISTS=1
command -v git >/dev/null 2>&1 || GIT_COMMAND_EXISTS=0

if [ ! -d "$CMAKE_SOURCE_DIR/.git" -o $GIT_COMMAND_EXISTS -eq 0 ]; then
    update_header "no vcs hash"
    exit 0
fi

GIT_HASH=$(cd "$CMAKE_SOURCE_DIR"; expr substr `git rev-parse HEAD` 1 8)
GIT_HAVE_CHANGES=$(cd "$CMAKE_SOURCE_DIR"; git diff --exit-code --quiet && echo || echo ", with changes")

update_header "$GIT_HASH$GIT_HAVE_CHANGES"
