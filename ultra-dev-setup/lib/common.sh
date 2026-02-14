#!/usr/bin/env bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

retry() {
  local n=0
  until [ "$n" -ge 5 ]; do
    "$@" && break
    n=$((n+1))
    sleep 2
  done
}

log() {
  echo "[INFO] $*"
}
