#!/usr/bin/env bash

scripts=("deploy destroy test list logs xazab-cli generate")

if [[ " ${scripts[@]} " =~ " ${1} " ]]; then
    script=$1

    # Remove the first argument ("xazab-network")
    shift

    source "bin/$script"
else
    exec "$@"
fi
