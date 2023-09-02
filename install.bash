#!/bin/bash

function logger() {
	echo "[$(date --utc) UTC] $1"
}

function info() {
	logger "[INFO]: $1"
}

function error() {
	logger "[ERROR]: $1"
	exit $2
}

PATH_USER_SOURCES="$HOME/sources"
PATH_USER_BIN="$HOME/bin"
PATH_USER_DOTCONFIG="$HOME/.config"

set -e -x

# REMOVE EXISTING CONFIGURATIONS TO AVOID CONFLICTS
rm -v "$HOME/.config/nvim" -rf
rm -v "$HOME/.local/share/nvim" -rf

# ENSURE INSTALLATION IS NOT OCCURRING IN THE ROOT DIRECTORY
dir_start=$PWD
U_BIN=$dir_start/bin
export PATH="$U_BIN:$PATH"

if [[ "$dir_start" == "/" ]]; then error "cannot install at '/'"; fi

# MAKE INITIAL DIRECTORY TARGETS
mkdir -vp bin sources .config .fonts
export PATH="$(realpath bin):$PATH"

# DOWNLOAD DEPENDENCIES
# NODEJS
cd sources
DEP_NODEJS_VERSION="v20.5.1"
DEP_NODEJS="node-$DEP_NODEJS_VERSION-linux-x64"
DEP_NODEJS_URL="https://nodejs.org/dist/$DEP_NODEJS_VERSION/$DEP_NODEJS.tar.xz"
wget -v "$DEP_NODEJS_URL"
unxz -v "$DEP_NODEJS.tar.xz"
tar -xvf "$DEP_NODEJS.tar"
rm -v "$DEP_NODEJS.tar"
DEP_NODEJS_BINPATH="$PWD/$DEP_NODEJS/bin"
cd $dir_start/bin

# EXPLICIT NAMING SINCE IMPLICIT MAY RESULT IN A `.JS` SUFFIX
ln -sv "$DEP_NODEJS_BINPATH/node" "node"
ln -sv "$DEP_NODEJS_BINPATH/npm" "npm"
cd $dir_start
node --version
npm --version

# RUST & CARGO
SCRIPT_RUSTUP="rustup.sh"
wget https://sh.rustup.rs
mv index.html $SCRIPT_RUSTUP
sh $SCRIPT_RUSTUP -y --profile default
rm $SCRIPT_RUSTUP
export PATH="$HOME/.cargo/bin:$PATH"
cargo --version

# TREE-SITTER-CLI
cargo install tree-sitter-cli
cd bin
ln -sv $dir_start/.cargo/bin/tree-sitter
ln -sv ./tree-sitter tree-sitter-cli
cd $dir_start
tree-sitter-cli --version

# RIPGREP
cd sources
DIR_RIPGREP="ripgrep-13.0.0-x86_64-unknown-linux-musl"
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/$DIR_RIPGREP.tar.gz
tar xzvf $DIR_RIPGREP.tar.gz
rm $DIR_RIPGREP.tar*
cd $dir_start/bin
ln -sv $dir_start/sources/$DIR_RIPGREP/rg
cd $dir_start
rg --version

# FDFIND
cd sources
DIR_FD="fd-v8.7.0-x86_64-unknown-linux-musl"
wget https://github.com/sharkdp/fd/releases/download/v8.7.0/$DIR_FD.tar.gz
tar xzvf $DIR_FD.tar.gz
rm $DIR_FD.tar*
cd $dir_start/bin
ln -sv $dir_start/sources/$DIR_FD/fd
cd $dir_start
fd --version

# PYTHON
# LAZY ASSUMPTION
python3 --version # ensure installed ( fail exit via `set -e` )
cd bin
ln -sv $(which python3) python
cd $dir_start
python --version

# INSTALL CODELLDB VSCODE EXTENSION DEPENDENCY
cd sources
mkdir codelldb-1.8.1
cd codelldb-1.8.1
DEP_CODELLDB="codelldb-x86_64-linux"
DEP_CODELLDB_INFLATED_DIRNAME="extension"
DEP_CODELLDB_URL="https://github.com/vadimcn/vscode-lldb/releases/download/v1.8.1/$DEP_CODELLDB.vsix"
wget -v "$DEP_CODELLDB_URL"
unzip "$DEP_CODELLDB.vsix"
mv -v "$DEP_CODELLDB_INFLATED_DIRNAME" "$DEP_CODELLDB"
CODELLDB_PATH="$dir_start/sources/codelldb-1.8.1/$DEP_CODELLDB"
cd $dir_start/bin
ln -v -s "$CODELLDB_PATH/adapter/codelldb"
ln -v -s "$CODELLDB_PATH/lldb/bin/lldb"
ln -v -s "$CODELLDB_PATH/lldb/bin/lldb-argdumper"
ln -v -s "$CODELLDB_PATH/lldb/bin/lldb-server"
cd $dir_start
lldb --version
codelldb --version
lldb-server --version
lldb-argdumper --version

# INSTALL FAVORITE EDITOR FONTS
cd .fonts
DEP_FIRACODE="FiraCode"
DEP_FIRACODE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/$DEP_FIRACODE.zip"
wget -v "$DEP_FIRACODE_URL"
unzip "$DEP_FIRACODE.zip"
ls -larthR .
rm "$DEP_FIRACODE.zip"
cd $dir_start

# DOWNLOAD / CONFIGURE NVIM
cd .config
git clone https://github.com/seantronsen/neovim-config.git nvim
cd $dir_start/sources
wget --verbose https://github.com/neovim/neovim/releases/download/v0.8.3/nvim.appimage
wget --verbose https://github.com/neovim/neovim/releases/download/v0.8.3/nvim.appimage.sha256sum
if [[ ! -z "$(shasum -a 256 nvim.appimage | diff nvim.appimage.sha256sum -)" ]]; then error "sha256 checksums do not match" 1; fi
rm -v nvim.appimage.sha256sum
chmod -v u+x nvim.appimage
./nvim.appimage --appimage-extract
mv -v squashfs-root nvim-0.8.3
cd $dir_start/bin
ln -sv "$dir_start/sources/nvim-0.8.3/usr/bin/nvim"
cd $dir_start
nvim --version

info "CHANGE THE TERMINAL FONT WITHIN THE PREFERENCES MENU."
info "ADD THE $HOME/bin TO YOUR PATH VARIABLE"
