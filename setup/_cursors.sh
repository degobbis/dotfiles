#!/usr/bin/env bash
# --------------------------------------------------------------
# Cursors
# --------------------------------------------------------------

# --------------------------------------------------------------
# Bibata Cursors
# --------------------------------------------------------------

download_folder="$HOME/Downloads/bibata-cursors"
bibata_url="https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7"

if [ -d $download_folder ]; then
    rm -rf $download_folder
fi

bibataUrls=(
	"$bibata_url/Bibata-Modern-Amber.tar.xz"
	"$bibata_url/Bibata-Modern-Classic.tar.xz"
	"$bibata_url/Bibata-Modern-Ice.tar.xz"
)

_installBibataCursors() {
    local cursor
    local fileName
    for cursor in "${bibataUrls[@]}"; do
		fileName=$(basename "$cursor")
		_downloadFileToTmp \
			--download-url="$cursor" \
			--target-dir='ml4w/bibata-cursors'

		if [[ $? -eq 0 ]]; then
			_info "Cursor $fileName downloaded"
			tar -xf $downloadedFileToTmp -C ~/.local/share/icons/
			_info "Cursor $fileName installed into ~/.local/share/icons"
		else
			_error "Error downloading cursor $fileName"
		fi
		unset downloadedFileToTmp
	done
}

if [ ! -d ~/.local/share/icons/ ]; then
    mkdir -p ~/.local/share/icons/
fi

if [ -d ~/.local/share/icons/Bibata-Modern-Amber ]; then
    rm -rf ~/.local/share/icons/Bibata-Modern-Amber
fi
if [ -d ~/.local/share/icons/Bibata-Modern-Classic ]; then
    rm -rf ~/.local/share/icons/Bibata-Modern-Classic
fi
if [ -d ~/.local/share/icons/Bibata-Modern-Amber ]; then
    rm -rf ~/.local/share/icons/Bibata-Modern-Ice
fi

_installBibataCursors

# --------------------------------------------------------------
# Arc Cursors
# --------------------------------------------------------------

if [ -d ~/.local/share/icons/ArcAurora-cursors ]; then
    rm -rf ~/.local/share/icons/ArcAurora-cursors
fi

if [ -d ~/.local/share/icons/ArcDusk-cursors ]; then
    rm -rf ~/.local/share/icons/ArcDusk-cursors
fi

if [ -d ~/.local/share/icons/ArcStarry-cursors ]; then
    rm -rf ~/.local/share/icons/ArcStarry-cursors
fi

unzip $SCRIPT_DIR/cursors/ArcAurora-cursors.zip -d ~/.local/share/icons/
unzip $SCRIPT_DIR/cursors/ArcDusk-cursors.zip -d ~/.local/share/icons/
unzip $SCRIPT_DIR/cursors/ArcStarry-cursors.zip -d ~/.local/share/icons/
