#!/bin/bash

force_build=0

while getopts "f" opt; do
    case "$opt" in
        f) force_build=1 ;;
        \?) echo "Usage: $0 [-f]" >&2
            exit 1 ;;
    esac
done

shift $((OPTIND - 1))

for folder in */; do
    folder_name=${folder%/}
    image_name="${folder_name,,}"  # Convert folder name to lowercase for image name

    if [ $force_build -eq 0 ]; then
        # Check if the image exists
        if docker image inspect "$image_name" &> /dev/null; then
            continue
        fi
    fi

    echo "Building image for folder '$folder_name'..."

    # Build Docker image
    docker build -t "$image_name" "$folder_name"

    echo "Image for folder '$folder_name' built and tagged as '$image_name'."
done

