#!/usr/bin/env bash

set -e
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"
echo_path="$script_dir/echo.sh"
/usr/bin/script -q /dev/null "$echo_path"
