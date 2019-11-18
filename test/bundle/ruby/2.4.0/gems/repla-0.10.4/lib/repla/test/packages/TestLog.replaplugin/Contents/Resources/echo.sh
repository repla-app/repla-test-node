#!/bin/sh

set -e

echo 'Testing log error' >&2
printf "\n" >&2
echo 'ERROR ' >&2
echo 'Testing log message'
echo 'MESSAGE '
echo
printf "\t"
echo 'Done'
printf "\n"

