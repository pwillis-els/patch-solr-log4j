#!/usr/bin/env sh
# patch-log4j.sh - replace old log4j files in a target directory with new ones from a log4j download
# Copyright (c) 2021  Peter Willis
set -e -u
[ "${DEBUG:-0}" = "1" ] && set -x
DRYRUN=0 # Set to 1 to prevent removing/copying files

if [ $# -lt 2 ] ; then
    cat <<EOUSAGE
Usage: $0 LOG4J_DIR TARGET_DIR

LOG4J_DIR must be a directory with the patched version of Log4j downloaded.
TARGET_DIR should be the directory of a Java project with log4j jars.
EOUSAGE
    exit 1
fi

LOG4J_DIR="$1"
TARGET_DIR="$2"

TARGET_JARS="$(find "$TARGET_DIR" -type f -iname '*log4j*.jar')"
for jar in $TARGET_JARS ; do
    target_dn="$(dirname "$jar")"
    target_bn="$(basename "$jar" .jar)"
    libname="$(echo "$target_bn" | sed -e 's/^\(.*\)-\([0-9]\+\.[0-9]\+\.[0-9]\+\)/\1/')"
    libver="$(echo "$target_bn" | sed -e 's/^\(.*\)-\([0-9]\+\.[0-9]\+\.[0-9]\+\)/\2/')"
    echo "$0: Found $libname version $libver ($jar)"

    detected_jar="$(find "$LOG4J_DIR/" -type f -iname '*.jar' | grep -e "\/\?$libname-[0-9]\+\.[0-9]\+\.[0-9]\+\.jar$")"
    if [ ! -n "$detected_jar" ] || [ "$(echo "$detected_jar" | wc -l)" -gt 1 ] ; then
        echo "$0: ERROR: Could not detect log4j jar file matching name '$libname'"
    else
        echo "$0: Detected jar file '$detected_jar'"
        echo "$0: Replacing jar '$jar' with '$detected_jar'"
        if [ "$DRYRUN" = "0" ] ; then
            rm -f "$jar"
            cp -f "$detected_jar" "$target_dn/"
        fi
    fi
done
