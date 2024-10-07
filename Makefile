SHELL ::= /bin/bash
.ONESHELL:

# load bash library to initialize several directory target variables
USER_BIN := $(shell source bash-common-lib/lib.bash && echo $$USER_BIN)
USER_SRC := $(shell source bash-common-lib/lib.bash && echo $$USER_SRC)
USER_DOTCONFIG := $(shell source bash-common-lib/lib.bash && echo $$USER_DOTCONFIG)

define shell-prep
set -e
@source bash-common-lib/lib.bash
@export PATH="$$USER_BIN:$$PATH"
endef

.PHONY: install submodules fd rg node npm nvim nvim-config

install: submodules fd rg node npm nvim nvim-config
	echo "installer source code incomplete"
	exit 1

nvim: xattr xz uname wget
	$(shell-prep)
	if ! command -v $@ &>/dev/null; then
		echo "$@ not found"
		URL_TARGET=""
		if uname -s | grep -i "Darwin"; then
			URL_TARGET="https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-macos.tar.gz"
		elif uname -s | grep -i "Linux"; then
			URL_TARGET="https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz"
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

nvim-config: git submodules
	$(shell-prep)
	CWD="$$(pwd)"
	CONFIG_DIR="$$USER_DOTCONFIG/nvim"

	if [ "$$CWD" = "$$CONFIG_DIR" ]; then
		echo "illegal action: installer cannot be executed inside '$$CONFIG_DIR'."
		exit 1
	fi

	# REMOVE EXISTING CONFIGURATION
	rm -vrf "$$CONFIG_DIR"
	rm -vrf "$$HOME/.local/share/nvim"

	# CLONE CURRENT CONFIGURATION
	cd "$$USER_DOTCONFIG" && git clone https://github.com/seantronsen/neovim-config.git nvim


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
	$(shell-prep)
	if ! command -v $@ &> /dev/null; then
		echo "$@ not found"
		NODE_PATH=$$(dirname $$(readlink $$(command -v node)))
		if [ ! -f "$$NODE_PATH/$@" ]; then
				echo "$@ installation could not be found at $$NODE_PATH"
				exit 1
		fi
		cd ${USER_BIN} && ln -s $$NODE_PATH/$@ .
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


.PHONY: wget xz zip gcc g++ file xattr uname git

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
