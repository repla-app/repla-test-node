#!/bin/sh

if [[ -n "$1" ]]; then
  echo "$@"
else
  echo "$ECHO_MESSAGE"
fi

