#!/bin/sh

set -e
script_dir="$( cd "$(/usr/bin/dirname "$0")" ; pwd -P )"
echo_path="$script_dir/echo.sh"
/usr/bin/script -q /dev/null "$echo_path"
