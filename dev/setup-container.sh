#!/bin/bash
set -xeuo pipefail

cache_dir="$(brew --cache)"
user="$(whoami)"

mkdir -p "$cache_dir"
sudo chown -R "$user" "$cache_dir"
