# Daily Bing Wallpaper

A simple script to fetch, download, and set the daily Bing wallpaper using `waypaper`.

## Features

- Downloads the daily Bing wallpaper in UHD resolution
- Sets the wallpaper using `waypaper`
- Supports custom wallpaper directory
- Verbose and debug modes for troubleshooting

## Requirements

- `curl` - for fetching the Bing wallpaper URL and downloading the image
- `waypaper` - for setting the wallpaper
- `bash` - for running the script

## Installation

1. Clone this repository:

```bash
git clone https://github.com/riccardoregina/daily-bing-wallpaper.git
```

2. Make the script executable:

```bash
chmod +x set-daily-bing-wallpaper.sh
```

## Usage

```bash
./set-daily-bing-wallpaper.sh [options]
```

### Options

- `-h, --help`: Show help message and exit
- `-v, --verbose`: Print every operation the script does
- `--download-only`: Only downloads the image, but does not set it as wallpaper
- `--wallpaper-dir DIR`: Specify the directory to save wallpapers (default: `$HOME/BingWallpapers`)
- `--debug`: Like `--verbose` but prints additional info

### Examples

1. Download and set the wallpaper:

```bash
./set-daily-bing-wallpaper.sh
```
Note that the wallpaper will not be downloaded if it already exists in the specified directory. Default directory is ~/BingWallpapers.

2. Download the wallpaper only:

```bash
./set-daily-bing-wallpaper.sh --download-only
```

3. Specify a custom wallpaper directory:

```bash
./set-daily-bing-wallpaper.sh --wallpaper-dir ~/Pictures/Wallpapers
```

4. Run in verbose mode:

```bash
./set-daily-bing-wallpaper.sh --verbose
```

## ML4W dotfiles integration
You can use this script inside a ML4W (https://github.com/mylinuxforwork) setup, but be careful if you want to execute it at startup by placing it in the hyprland configuration: since ML4W already executes a wallpaper restore script (restore-wallpaper.sh) at startup, a race condition on the waypaper config file could occurr, causing a corrupted waypaper config file. To avoid this, you can either:
+ run this script after a sleep e.g. `exec-once = sleep 5 && path/to/set-daily-bing-wallpaper.sh` [RECOMMENDED]
+ replace the restore-wallpaper.sh ML4W script with this script. However, it is not generally recommended to change the default ML4W scripts.

## License

This project is licensed under the MIT License.
