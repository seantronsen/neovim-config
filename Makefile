SHELL ::= /bin/bash
BUILD ?= $(shell mkdir -p build && echo "build")
NVIMB_DEPENDENCIES=${BUILD}/neovim-bpackages

# assuming the user has `git` (required binary dependency)
NVIMB_DEPENDENCIES_LIST=wget xz unxz zip gcc g++ file python3 pip
NVIM_SUBMODULES=${BUILD}/neovim-submodules
NVIM_PREREQS = locals cargo tree-sitter nodejs ripgrep fdfind py-virtualenv codelldb dotfonts
NVIM_PREREQ_PATHS = $(foreach ARG, ${NVIM_PREREQS}, ${BUILD}/${ARG})
OBJS ?= ${BUILD}

define shell-prep
source bash-common-lib/lib.bash
export PATH="$$USER_BIN:$$PATH"
export PATH="$$HOME/.cargo/bin:$$PATH"
endef

.ONESHELL:
${BUILD}/neovim: ${NVIMB_DEPENDENCIES} ${NVIM_PREREQ_PATHS}
	$(shell-prep)

	# REMOVE EXISTING CONFIGURATION
	rm -vrf "$$USER_DOTCONFIG/nvim"
	rm -vrf "$$HOME/.local/share/nvim"

	# CLONE CURRENT CONFIGURATION
	(
		cd "$$USER_DOTCONFIG"
		git clone https://github.com/seantronsen/neovim-config.git nvim
	)

	# DOWNLOAD NVIM BINARIES
	NVIM_VERSION="0.9.4"
	NVIM_NAME="nvim-$$NVIM_VERSION"
	if uname -a | egrep -oi --quiet linux; then
		NVIM_ARCHIVE="nvim.appimage"
		NVIM_BINARY="$$USER_SRC/$$NVIM_NAME/usr/bin/nvim"
	elif uname -a | egrep -oi --quiet darwin; then
		NVIM_ARCHIVE="nvim-macos.tar.gz"
		NVIM_BINARY="$$USER_SRC/$$NVIM_NAME/bin/nvim"
	else
		uname -a
		error "host operating system is not supported"
	fi
	(
		cd "$$USER_SRC"
		wget --verbose "https://github.com/neovim/neovim/releases/download/v$$NVIM_VERSION/$$NVIM_ARCHIVE"
		wget --verbose "https://github.com/neovim/neovim/releases/download/v$$NVIM_VERSION/$$NVIM_ARCHIVE.sha256sum"

		# VALIDATE CHECKSUMS
		if [[ ! -z "$$(shasum -a 256 "$$NVIM_ARCHIVE" | diff "$$NVIM_ARCHIVE.sha256sum" -)" ]]; then
			error "sha256 checksums do not match" 1
		fi
		rm -v "$$NVIM_ARCHIVE.sha256sum"

		# CREATE SYMLINKS
		if uname -a | egrep -oi --quiet linux; then
			chmod -v u+x "$$NVIM_ARCHIVE"
			"./$$NVIM_ARCHIVE" --appimage-extract
			mv -v squashfs-root "$$NVIM_NAME"
		elif uname -a | egrep -oi --quiet darwin; then
			binary_dependency_check xattr
			xattr -c "$$NVIM_ARCHIVE"
			tar xzvf "$$NVIM_ARCHIVE"
			mv -v nvim-macos "$$NVIM_NAME"
	)
	(
		cd "$$USER_BIN"
		ln -sv "$$NVIM_BINARY"
	)
	nvim --version


.PHONY: all clean
${NVIM_SUBMODULES}:
	git submodule init
	git submodule update
	touch $@



${NVIMB_DEPENDENCIES}: ${NVIM_SUBMODULES}
	$(shell-prep)
	binary_dependency_check ${NVIMB_DEPENDENCIES_LIST}
	touch ${NVIMB_DEPENDENCIES}

${BUILD}/locals:
	$(shell-prep)
	mkdir -vp $$USER_BIN $$USER_SRC $$USER_DOTCONFIG $$USER_FONTS
	touch $@

${BUILD}/cargo: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	if ! which cargo; then
		SCRIPT_RUSTUP="rustup.sh"
		wget https://sh.rustup.rs
		mv index.html $$SCRIPT_RUSTUP
		sh $$SCRIPT_RUSTUP -y --profile default
		rm $$SCRIPT_RUSTUP
		cargo --version
	fi
	touch $@

${BUILD}/tree-sitter: ${BUILD}/cargo
	$(shell-prep)
	if ! which tree-sitter; then
		cargo install tree-sitter-cli
		(
			cd "$$USER_BIN"
			ln -sv "$$HOME/.cargo/bin/tree-sitter" "tree-sitter-cli"
		)
		tree-sitter-cli --version
	fi
	touch $@


${BUILD}/nodejs: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	if ! which node; then
		DEP_NODEJS_VERSION="v20.5.1"
		DEP_NODEJS="node-$$DEP_NODEJS_VERSION-linux-x64"
		DEP_NODEJS_URL="https://nodejs.org/dist/$$DEP_NODEJS_VERSION/$$DEP_NODEJS.tar.xz"
		DEP_NODEJS_BINPATH="$$USER_SRC/$$DEP_NODEJS/bin"
		(
			cd "$$USER_SRC"
			wget -v "$$DEP_NODEJS_URL"
			unxz -v "$$DEP_NODEJS.tar.xz"
			tar -xvf "$$DEP_NODEJS.tar"
			rm -v "$$DEP_NODEJS.tar"
		)
		(
			cd "$$USER_BIN"
			ln -sv "$$DEP_NODEJS_BINPATH/node" "node"
			ln -sv "$$DEP_NODEJS_BINPATH/npm" "npm"
		)
		node --version
		npm --version
	fi
	touch $@



clean::
	rm -vrf ${OBJS}


${BUILD}/ripgrep: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	if ! which rg; then
		DIR_RIPGREP="ripgrep-13.0.0-x86_64-unknown-linux-musl"
		(
			cd "$$USER_SRC"
			wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/$$DIR_RIPGREP.tar.gz
			tar xzvf $$DIR_RIPGREP.tar.gz
			rm $$DIR_RIPGREP.tar*
		)
		(
			cd "$$USER_BIN"
			ln -sv "$$USER_SRC/$$DIR_RIPGREP/rg"
			rg --version
		)
	fi
	touch $@

${BUILD}/fdfind: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	if ! which fd; then
		DIR_FD="fd-v8.7.0-x86_64-unknown-linux-musl"
		(
			cd "$$USER_SRC"
			wget https://github.com/sharkdp/fd/releases/download/v8.7.0/$$DIR_FD.tar.gz
			tar xzvf $$DIR_FD.tar.gz
			rm $$DIR_FD.tar*
		)
		(
			cd "$$USER_BIN"
			ln -sv "$$USER_SRC/$$DIR_FD/fd"
			fd --version
		)
	fi
	touch $@

${BUILD}/py-virtualenv: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	PATH_PDB_ENV="$$HOME/.virtualenvs/debugenv"
	if ! python3 -m pip show --quiet virtualenv; then
		python3 -m pip install virtualenv
	fi
	if [[ ! -d "$$PATH_PDB_ENV" ]]; then
		python3 -m virtualenv "$$PATH_PDB_ENV"
		source "$$PATH_PDB_ENV/bin/activate"
		pip install debugpy
		python3 -m debugpy --version
		deactivate
	fi
	touch $@

${BUILD}/codelldb: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	if ! which codelldb; then
		DEP_CODELLDB="codelldb-x86_64-linux"
		DEP_CODELLDB_INFLATED_DIRNAME="extension"
		DEP_CODELLDB_URL="https://github.com/vadimcn/vscode-lldb/releases/download/v1.8.1/$$DEP_CODELLDB.vsix"
		CODELLDB_PATH="$$USER_SRC/codelldb-1.8.1/$$DEP_CODELLDB"
		(
			cd "$$USER_SRC"
			mkdir codelldb-1.8.1
			cd codelldb-1.8.1
			wget -v "$$DEP_CODELLDB_URL"
			unzip "$$DEP_CODELLDB.vsix"
			mv -v "$$DEP_CODELLDB_INFLATED_DIRNAME" "$$DEP_CODELLDB"
		)
		(
			cd "$$USER_BIN"
			ln -vs "$$CODELLDB_PATH/adapter/codelldb"
			ln -vs "$$CODELLDB_PATH/lldb/bin/lldb"
			ln -vs "$$CODELLDB_PATH/lldb/bin/lldb-argdumper"
			ln -vs "$$CODELLDB_PATH/lldb/bin/lldb-server"
		)
		lldb --version
		codelldb --version
		lldb-server --version
		lldb-argdumper --version
	fi
	touch $@

# INSTALL FAVORITE EDITOR FONTS
${BUILD}/dotfonts: ${NVIMB_DEPENDENCIES}
	$(shell-prep)
	(
		cd "$$USER_FONTS"
		DEP_FIRACODE="FiraCode"
		DEP_FIRACODE_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/$$DEP_FIRACODE.zip"
		wget -v "$$DEP_FIRACODE_URL"
		unzip -o "$$DEP_FIRACODE.zip"
		rm "$$DEP_FIRACODE.zip"
	)
	touch $@
