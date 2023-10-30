#!/bin/bash

set -e -x
I_SCRIPT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
(
	cd "$I_SCRIPT_DIR"
	git submodule init
	git submodule update
)

source "$I_SCRIPT_DIR/bash-common-lib/lib.bash"
binary_dependency_check git wget xz unxz zip gcc g++ file python3 pip
python_dependency_check virtualenv

# REMOVE EXISTING CONFIGURATIONS TO AVOID CONFLICTS
rm -vrf "$USER_DOTCONFIG/nvim"
rm -vrf "$HOME/.local/share/nvim"

# ENSURE INSTALLATION IS NOT OCCURRING IN THE ROOT DIRECTORY
export PATH="$USER_BIN:$PATH"

if [[ "$PWD" != "$HOME" ]]; then error "script must be run in the home directory: '$HOME'"; fi

# MAKE INITIAL DIRECTORY TARGETS
mkdir -vp bin sources .config .fonts
export PATH="$(realpath bin):$PATH"

# DOWNLOAD DEPENDENCIES
# NODEJS
if ! which node; then
	DEP_NODEJS_VERSION="v20.5.1"
	DEP_NODEJS="node-$DEP_NODEJS_VERSION-linux-x64"
	DEP_NODEJS_URL="https://nodejs.org/dist/$DEP_NODEJS_VERSION/$DEP_NODEJS.tar.xz"
	DEP_NODEJS_BINPATH="$USER_SRC/$DEP_NODEJS/bin"
	(
		cd "$USER_SRC"
		wget -v "$DEP_NODEJS_URL"
		unxz -v "$DEP_NODEJS.tar.xz"
		tar -xvf "$DEP_NODEJS.tar"
		rm -v "$DEP_NODEJS.tar"
	)
	(
		cd "$USER_BIN"
		ln -sv "$DEP_NODEJS_BINPATH/node" "node"
		ln -sv "$DEP_NODEJS_BINPATH/npm" "npm"
	)
	node --version
	npm --version
fi

# RUST & CARGO
if ! which cargo; then
	SCRIPT_RUSTUP="rustup.sh"
	wget https://sh.rustup.rs
	mv index.html $SCRIPT_RUSTUP
	sh $SCRIPT_RUSTUP -y --profile default
	rm $SCRIPT_RUSTUP
	export PATH="$HOME/.cargo/bin:$PATH"
	cargo --version
fi

# TREE-SITTER-CLI
if ! which tree-sitter; then
	cargo install tree-sitter-cli
	(
		cd "$USER_BIN"
		ln -sv "$HOME/.cargo/bin/tree-sitter" "tree-sitter-cli"
	)
	tree-sitter-cli --version
fi

# RIPGREP
if ! which rg; then
	DIR_RIPGREP="ripgrep-13.0.0-x86_64-unknown-linux-musl"
	(
		cd "$USER_SRC"
		wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/$DIR_RIPGREP.tar.gz
		tar xzvf $DIR_RIPGREP.tar.gz
		rm $DIR_RIPGREP.tar*
	)
	(
		cd "$USER_BIN"
		ln -sv "$USER_SRC/$DIR_RIPGREP/rg"
	)
	rg --version
fi

# FDFIND
if ! which fd; then
	DIR_FD="fd-v8.7.0-x86_64-unknown-linux-musl"
	(
		cd "$USER_SRC"
		wget https://github.com/sharkdp/fd/releases/download/v8.7.0/$DIR_FD.tar.gz
		tar xzvf $DIR_FD.tar.gz
		rm $DIR_FD.tar*
	)
	(
		cd "$USER_BIN"
		ln -sv "$USER_SRC/$DIR_FD/fd"
	)
	fd --version
fi

# PYTHON
PATH_PDB_ENV="$HOME/.virtualenvs/debugenv"
python3 --version
if ! python3 -m pip show --quiet virtualenv; then
	python3 -m pip install virtualenv

fi

if [[ ! -d "$PATH_PDB_ENV" ]]; then
	python3 -m virtualenv "$PATH_PDB_ENV"
	source "$PATH_PDB_ENV/bin/activate"
	pip install debugpy
	python3 -m debugpy --version
	deactivate
fi

# INSTALL CODELLDB VSCODE EXTENSION DEPENDENCY
if ! which codelldb; then
	DEP_CODELLDB="codelldb-x86_64-linux"
	DEP_CODELLDB_INFLATED_DIRNAME="extension"
	DEP_CODELLDB_URL="https://github.com/vadimcn/vscode-lldb/releases/download/v1.8.1/$DEP_CODELLDB.vsix"
	CODELLDB_PATH="$USER_SRC/codelldb-1.8.1/$DEP_CODELLDB"
	(
		cd "$USER_SRC"
		mkdir codelldb-1.8.1
		cd codelldb-1.8.1
		wget -v "$DEP_CODELLDB_URL"
		unzip "$DEP_CODELLDB.vsix"
		mv -v "$DEP_CODELLDB_INFLATED_DIRNAME" "$DEP_CODELLDB"
	)
	(
		cd "$USER_BIN"
		ln -vs "$CODELLDB_PATH/adapter/codelldb"
		ln -vs "$CODELLDB_PATH/lldb/bin/lldb"
		ln -vs "$CODELLDB_PATH/lldb/bin/lldb-argdumper"
		ln -vs "$CODELLDB_PATH/lldb/bin/lldb-server"
	)
	lldb --version
	codelldb --version
	lldb-server --version
	lldb-argdumper --version
fi

# INSTALL FAVORITE EDITOR FONTS
(
	cd "$HOME/.fonts"
	DEP_FIRACODE="FiraCode"
	DEP_FIRACODE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/$DEP_FIRACODE.zip"
	wget -v "$DEP_FIRACODE_URL"
	unzip "$DEP_FIRACODE.zip"
	rm "$DEP_FIRACODE.zip"
)

# DOWNLOAD / CONFIGURE NVIM
(
	cd "$USER_DOTCONFIG"
	git clone https://github.com/seantronsen/neovim-config.git nvim
)
(
	NVIM_VERSION="0.9.4"
	NVIM_NAME="nvim-$NVIM_VERSION"
	NVIM_ARCHIVE="nvim.appimage"
	if uname -a | egrep -oi --quiet darwin; then
		NVIM_ARCHIVE="nvim-macos.tar.gz"
	fi

	cd "$USER_SRC"
	wget --verbose "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/$NVIM_ARCHIVE"
	wget --verbose "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/$NVIM_ARCHIVE.sha256sum"

	if [[ ! -z "$(shasum -a 256 "$NVIM_ARCHIVE" | diff "$NVIM_ARCHIVE.sha256sum" -)" ]]; then
		error "sha256 checksums do not match" 1
	fi

	rm -v "$NVIM_ARCHIVE.sha256sum"

	if uname -a | egrep -oi --quiet darwin; then
		binary_dependency_check xattr
		xattr -c "$NVIM_ARCHIVE"
		tar xzvf "$NVIM_ARCHIVE"
		mv -v nvim-macos "$NVIM_NAME"
		ln -sv "$USER_SRC/nvim-0.9.4/bin/nvim"

	else
		chmod -v u+x "$NVIM_ARCHIVE"
		"./$NVIM_ARCHIVE" --appimage-extract
		mv -v squashfs-root "$NVIM_NAME"
		cd "$USER_BIN"
		ln -sv "$USER_SRC/nvim-0.9.4/usr/bin/nvim"

	fi

)
nvim --version

info "CHANGE THE TERMINAL FONT WITHIN THE PREFERENCES MENU."
info "ADD THE $HOME/bin TO YOUR PATH VARIABLE"
