SHELL ::= /bin/bash

# load bash library to initialize several directory target variables
USER_BIN := $(shell source bash-common-lib/lib.bash && echo $$USER_BIN)
USER_SRC := $(shell source bash-common-lib/lib.bash && echo $$USER_SRC)
USER_DOTCONFIG := $(shell source bash-common-lib/lib.bash && echo $$USER_DOTCONFIG)

define shell-prep
set -e
@source bash-common-lib/lib.bash
@export PATH="$$USER_BIN:$$PATH"
endef

install: fd rg node npm submodules nvim-config nvim
	echo "installer source code incomplete"
	exit 1



.ONESHELL:
${BUILD}/neovim: fd rg node npm submodules
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
		fi
	)
	(
		cd "$$USER_BIN"
		rm -vf nvim
		ln -svf "$$NVIM_BINARY" nvim
	)
	nvim --version

.PHONY: node npm fd rg
fd: uname wget xz ${USER_SRC} ${USER_BIN}
	$(shell-prep)
	if ! command -v $@ &>/dev/null; then
		echo "$@ not found"
		URL_TARGET=""
		if uname -s | grep -i "Darwin"; then
			URL_TARGET="https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-aarch64-apple-darwin.tar.gz"
		elif uname -s | grep -i "Linux"; then
			URL_TARGET="https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz"
		else
			@echo "target operating system $$(uname -s) not supported."
			exit 1
		fi
		wget -O "$@.tar.gz" $$URL_TARGET
		mkdir -v "STAGING-$@"
		tar -xzvf "$@.tar.gz" -C "STAGING-$@"
		DIR_TARGET=$$(ls "STAGING-$@")
		rm -v "$@.tar.gz"
		mv -v "STAGING-$@"/$$DIR_TARGET ${USER_SRC}/
		rmdir -v "STAGING-$@"
		cd ${USER_BIN} && ln -s $$USER_SRC/$$DIR_TARGET/$@ .

	fi
	echo "$@ binary located at $$(command -v $@)"
	$@ --version


# todo: abstract out a common routine for this and fd
rg: uname wget xz ${USER_SRC} ${USER_BIN}
	$(shell-prep)
	if ! command -v $@ &> /dev/null; then
		echo "$@ not found"
		URL_TARGET=""
		if uname -s | grep -i "Darwin"; then
			URL_TARGET="https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-aarch64-apple-darwin.tar.gz"
		elif uname -s | grep -i "Linux"; then
			URL_TARGET="https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz"
		else
			@echo "target operating system $$(uname -s) not supported."
			exit 1
		fi
		wget -O "$@.tar.gz" $$URL_TARGET
		mkdir -v "STAGING-$@"
		tar -xzvf "$@.tar.gz" -C "STAGING-$@"
		DIR_TARGET=$$(ls "STAGING-$@")
		rm -v "$@.tar.gz"
		mv -v "STAGING-$@"/$$DIR_TARGET ${USER_SRC}/
		rmdir -v "STAGING-$@"
		cd ${USER_BIN} && ln -s $$USER_SRC/$$DIR_TARGET/$@ .
	fi
	echo "$@ binary located at $$(command -v $@)"
	$@ --version


node: uname wget xz ${USER_SRC} ${USER_BIN}
	$(shell-prep)
	if ! command -v $@ &> /dev/null; then
		echo "$@ not found"
		URL_TARGET=""
		if uname -s | grep -i "Darwin"; then
			URL_TARGET="https://nodejs.org/dist/v20.18.0/node-v20.18.0-darwin-arm64.tar.gz"
		elif uname -s | grep -i "Linux"; then
			URL_TARGET="https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz"
		else
			@echo "target operating system $$(uname -s) not supported."
			exit 1
		fi
		wget -O "$@.tar.gz" $$URL_TARGET
		mkdir -v "STAGING-$@"
		tar -xzvf "$@.tar.gz" -C "STAGING-$@"
		DIR_TARGET=$$(ls "STAGING-$@")
		rm -v "$@.tar.gz"
		mv -v "STAGING-$@"/$$DIR_TARGET ${USER_SRC}/
		rmdir -v "STAGING-$@"
		cd ${USER_BIN} && ln -s $$USER_SRC/$$DIR_TARGET/bin/$@ .
	fi
	echo "$@ binary located at $$(command -v $@)"
	$@ --version


npm: node ${USER_SRC} ${USER_BIN}
	if ! command -v $@ &> /dev/null; then
		echo "$@ not found"
		NODE_PATH=$$(dirname $(readlink $(command -v node)))
		if [ ! -f "$$NODE_PATH/npm" ]; then
				echo "$@ installation could not be found at $$NODE_PATH"
				exit 1
		fi
		cd ${USER_SRC} && ln -s $$NODE_PATH/npm .
	fi
	echo "$@ binary located at $$(command -v $@)"
	$@ --version


${USER_BIN}:
	mkdir -vp $@

${USER_SRC}:
	mkdir -vp $@

${USER_DOTCONFIG}:
	mkdir -vp $@


submodules: git
	git submodule update --init --recursive
	@echo "repository submodules initialized and ready for use."


.PHONY: wget xz unxz zip gcc g++ file python3 pip xattr git uname

# wget target: Ensures wget is installed
wget:
	@command -v wget &> /dev/null || { echo "Error: could not find 'wget'."; exit 1; }
	@echo "Found 'wget' binary."
	@wget --version

# xz target: Ensures xz is installed
xz:
	@command -v xz >/dev/null 2>&1 || { echo "Error: could not find 'xz'."; exit 1; }
	@echo "Found 'xz' binary."
	@xz --version

# unxz target: Ensures unxz is installed
unxz:
	@command -v unxz >/dev/null 2>&1 || { echo "Error: could not find 'unxz'."; exit 1; }
	@echo "Found 'unxz' binary."
	@unxz --version

# zip target: Ensures zip is installed
zip:
	@command -v zip >/dev/null 2>&1 || { echo "Error: could not find 'zip'."; exit 1; }
	@echo "Found 'zip' binary."
	@zip --version

# gcc target: Ensures gcc is installed
gcc:
	@command -v gcc >/dev/null 2>&1 || { echo "Error: could not find 'gcc'."; exit 1; }
	@echo "Found 'gcc' binary."
	@gcc --version

# g++ target: Ensures g++ is installed
g++:
	@command -v g++ >/dev/null 2>&1 || { echo "Error: could not find 'g++'."; exit 1; }
	@echo "Found 'g++' binary."
	@g++ --version

# file target: Ensures file is installed
file:
	@command -v file >/dev/null 2>&1 || { echo "Error: could not find 'file'."; exit 1; }
	@echo "Found 'file' binary."
	@file --version

# python3 target: Ensures python3 is installed
python3:
	@command -v python3 >/dev/null 2>&1 || { echo "Error: could not find 'python3'."; exit 1; }
	@echo "Found 'python3' binary."
	@python3 --version

# pip target: Ensures pip is installed
pip:
	@command -v pip >/dev/null 2>&1 || { echo "Error: could not find 'pip'."; exit 1; }
	@echo "Found 'pip' binary."
	@pip --version

# xattr target: Ensures xattr is installed
xattr:
	@command -v xattr >/dev/null 2>&1 || { echo "Error: could not find 'xattr'."; exit 1; }
	@echo "Found 'xattr' binary."
	@xattr --version || echo "'xattr' version information not available."

# uname target: Ensures uname is available (part of core utilities, should always be available)
uname:
	@command -v uname >/dev/null 2>&1 || { echo "Error: could not find 'uname'."; exit 1; }
	@echo "Found 'uname' binary."
	@uname --version || uname

# git target: Ensures git is installed
git:
	@command -v git >/dev/null 2>&1 || { echo "Error: could not find 'git'."; exit 1; }
	@echo "Found 'git' binary."
	@git --version
