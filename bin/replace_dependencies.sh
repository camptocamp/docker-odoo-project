#!/usr/bin/env bash

declare -A replace=(
    ["PIL"]="Pillow"
    ["pychart"]="Python-Chart"
)
sed_str=""

for k in "${!replace[@]}"
do
    sed_str+="s/$k/${replace[$k]}/g;"
done

find . -type f -name setup.py | xargs sed -i -e $sed_str
