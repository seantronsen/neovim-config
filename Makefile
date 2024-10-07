SHELL ::= /bin/bash
BUILD ?= $(shell mkdir -p build && echo "build")
NVIM_DEPENDENCIES=${BUILD}/neovim-packages

# assuming the user has `git` (required binary dependency)
NVIM_DEPENDENCIES_LIST=wget xz unxz zip gcc g++ file python3 pip
NVIM_PREREQS = nodejs ripgrep fdfind submodules
OBJS ?= ${BUILD}

define shell-prep
source bash-common-lib/lib.bash
export PATH="$$USER_BIN:$$PATH"
export PATH="$$HOME/.cargo/bin:$$PATH"
endef


# load bash library to initialize several directory target variables
USER_BIN := $(shell source bash-common-lib/lib.bash && echo $$USER_BIN)
USER_SRC := $(shell source bash-common-lib/lib.bash && echo $$USER_SRC)
USER_DOTCONFIG := $(shell source bash-common-lib/lib.bash && echo $$USER_DOTCONFIG)

${USER_BIN}:
	mkdir -vp $@

${USER_SRC}:
	mkdir -vp $@

${USER_DOTCONFIG}:
	mkdir -vp $@




.ONESHELL:
${BUILD}/neovim: ${NVIM_DEPENDENCIES}
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


submodules:
	git submodule update --init --recursive
	@echo "repository submodules initialized and ready for use."



${NVIM_DEPENDENCIES}: ${NVIM_SUBMODULES}
	$(shell-prep)
	binary_dependency_check ${NVIM_DEPENDENCIES_LIST}
	touch ${NVIM_DEPENDENCIES}


.PHONY: node npm fd rg
fd: uname ln rm wget tar grep ${USER_SRC} ${USER_BIN}
	$(shell-prep)
	if ! command -v fd &> /dev/null; then
		URL_TARGET=""
		if uname -s | grep -i "Darwin"; then
			URL_TARGET="https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-aarch64-apple-darwin.tar.gz"
		elif uname -s | grep -i "Linux"; then
			URL_TARGET="https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz"
		else
			@echo "target operating system $$(uname -s) not supported."
			exit 1
		fi

		mkdir -v "STAGING"
		wget -O "fd.tar.gz" $URL_TARGET
		tar -xzvf "fd.tar.gz" -C "STAGING"
		DIR_TARGET=$$(ls "STAGING")
		rm -v "fd.tar.gz"
		mv -v "STAGING"/$$DIR_TARGET ${USER_SRC}/
		rmdir -v "STAGING"
		cd ${USER_BIN} && ln -s $$USER_SRC/$$DIR_TARGET/fd .



	fi
	fd --version

${BUILD}/nodejs: ${NVIM_DEPENDENCIES}
	$(shell-prep)
	if ! which node; then
		DEP_NODEJS_VERSION="v20.5.1"
		if uname | egrep -oi --quiet linux; then
			DEP_NODEJS="node-$$DEP_NODEJS_VERSION-linux-x64"
			DEP_NODEJS_URL="https://nodejs.org/dist/$$DEP_NODEJS_VERSION/$$DEP_NODEJS.tar.xz"
		elif uname | egrep -oi --quiet darwin; then
			DEP_NODEJS="node-$$DEP_NODEJS_VERSION-darwin-arm64"
			DEP_NODEJS_URL="https://nodejs.org/dist/$$DEP_NODEJS_VERSION/$$DEP_NODEJS.tar.gz"
		else
			uname -a
			error "host operating system is not supported"
		fi

		DEP_NODEJS_BINPATH="$$USER_SRC/$$DEP_NODEJS/bin"
		(
			cd "$$USER_SRC"
			wget -v "$$DEP_NODEJS_URL"
			tar xzvf "$$DEP_NODEJS.tar.*"
			rm -v "$$DEP_NODEJS.tar.*"
		)
		(
			cd "$$USER_BIN"
			ln -svf "$$DEP_NODEJS_BINPATH/node" "node"
			ln -svf "$$DEP_NODEJS_BINPATH/npm" "npm"
		)
		node --version
		npm --version
	fi
	touch $@

${BUILD}/ripgrep: ${BUILD}/cargo
	$(shell-prep)
	if ! which rg; then
		cargo install ripgrep
		(
			cd "$$USER_BIN"
			ln -svf "$$HOME/.cargo/bin/rg" "rg"
		)
		ripgrep --version
	fi
	touch $@

${BUILD}/fdfind: ${NVIM_DEPENDENCIES}
	$(shell-prep)
	if ! which fd; then
		cargo install fd-find
		(
			cd "$$USER_BIN"
			ln -svf "$$HOME/.cargo/bin/fd" "fd"
		)
		fd --version
	fi
	touch $@


# fdfind target: Depends on wget being available
fdfind: wget
	@command -v fd &> /dev/null || { echo "info: no installation found for 'fd'. attempting installation."; }
	@echo "Building fdfind..."
	# TODO: Add real build commands here
	@exit 1  # Placeholder for further steps


.PHONY: wget xz unxz zip gcc g++ file python3 pip xattr git rm ln uname grep

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

# ln target: Ensures ln is available (part of core utilities, should always be available)
ln:
	@command -v ln >/dev/null 2>&1 || { echo "Error: could not find 'ln'."; exit 1; }
	@echo "Found 'ln' binary."

# rm target: Ensures rm is available (part of core utilities, should always be available)
rm:
	@command -v rm >/dev/null 2>&1 || { echo "Error: could not find 'rm'."; exit 1; }
	@echo "Found 'rm' binary."

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

# grep target: Ensures grep is installed
grep:
	@command -v grep >/dev/null 2>&1 || { echo "Error: could not find 'grep'."; exit 1; }
	@echo "Found 'grep' binary."
	@grep --version



.PHONY: clean

clean:
	rm -vrf ${OBJS}
