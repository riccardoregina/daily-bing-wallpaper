#!/bin/bash

show_help() {
	cat << EOF
usage: $(basename "$0") [options]

A script to fetch, download and set with waypaper the daily Bing wallpaper.

options:
	-h, --help			show this help message and exit
	-v, --verbose		print every operation the script does
	--download-only		only downloads the image, but does not set it as wallpaper
	--wallpaper-dir DIR	specify the directory to save wallpapers
	--debug				like --verbose but prints additional info
EOF
}

# Parameter parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            verbose=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
		--download-only)
			download_only=true
			shift
            ;;
		--wallpaper-dir)
			WALLPAPER_DIR="$2"
			shift 2
			;;
		--debug)
			verbose=true
			debug=true
			shift
			;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            # Positional argument
            break
            ;;
    esac
done

# Fallback to default directory
if [[ ! $WALLPAPER_DIR ]]; then
	WALLPAPER_DIR="$HOME/BingWallpapers"
fi

# Fetch the daily Bing wallpaper URL
[[ $verbose == true ]] && echo "Fetching todays Bing wallpaper..."

BING_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"
[[ $debug == true ]] && echo "BING_URL=$BING_URL"
BING_RESPONSE=$(curl -s "$BING_URL")
if [[ $? -ne 0 ]]; then
	echo "Error: failed to fetch data from the Bing server" >&2
	echo "Rerun the script in debug mode for more info" >&2
	exit 1
fi
[[ $debug == true ]] && echo "BING_RESPONSE=$BING_RESPONSE"
IMAGE_URL=$(echo "$BING_RESPONSE" | grep -oP '"url":"\K[^"]+' | sed 's/^/https:\/\/www.bing.com/' | sed 's/1920x1080/UHD/')
[[ $debug == true ]] && echo "IMAGE_URL=$IMAGE_URL"
if [[ -z "$IMAGE_URL" ]]; then
	echo "Error: failed to obtain a valid image URL" >&2
	echo "Rerun the script in debug mode for more info" >&2
	exit 1
fi
IMAGE_TITLE=$(echo "$BING_RESPONSE" | grep -oP '"title":"\K[^"]+' | sed 's/ /-/g')
[[ $debug == true ]] && echo "IMAGE_TITLE=$IMAGE_TITLE"
if [[ -z "$IMAGE_TITLE" ]]; then
	echo "Error: failed to obtain a valid image title" >&2
	echo "Rerun the script in debug mode for more info" >&2
	exit 1
fi
[[ $verbose == true ]] && echo "Todays wallpaper is $IMAGE_TITLE"

# Download the wallpaper if needed
mkdir -p "$WALLPAPER_DIR"
if [[ $? -ne 0 ]]; then
	echo "Error: failed to create $WALLPAPER_DIR" >&2
	echo "Check your current permissions" >&2
	exit 1
fi

WALLPAPER_PATH="$WALLPAPER_DIR/$IMAGE_TITLE.jpg"
if [[ ! -e $WALLPAPER_PATH ]]; then
	[[ $verbose == true ]] && echo "Downloading the wallpaper..."
	curl -s -o "$WALLPAPER_PATH" "$IMAGE_URL"
	if [[ $? -ne 0 ]]; then
		echo "Error: failed to download the wallpaper from the Bing server" >&2
		exit 1
	fi
fi

# Set the wallpaper
if [[ $download_only != true ]]; then
	[[ $verbose == true ]] && echo "Setting the wallpaper..."
	waypaper --wallpaper "$WALLPAPER_PATH"
	if [[ $? -ne 0 ]]; then
		echo "Error: failed to set wallpaper with waypaper" >&2
		exit 1
	fi
fi

