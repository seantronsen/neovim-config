SHELL ::= /bin/bash
.ONESHELL:

# CONFIGURATION VARIABLES
DIRNAME_BASE_STAGING:="STAGING"

# DETERMINE HOST PROPERTIES
HOST_DIST := $(shell uname -s)
HOST_ARCH := $(shell uname -m)

# LOAD BASH LIBRARY TO INITIALIZE SEVERAL DIRECTORY TARGET VARIABLES
USER_BIN := $(shell source bash-common-lib/lib.bash && echo $$USER_BIN)
USER_SRC := $(shell source bash-common-lib/lib.bash && echo $$USER_SRC)
USER_DOTCONFIG := $(shell source bash-common-lib/lib.bash && echo $$USER_DOTCONFIG)


################################################################################
################################################################################
# CANNED RECIPES / MACROS
################################################################################
################################################################################

define shell-prep-macro
set -e
@source bash-common-lib/lib.bash
@export PATH="$$USER_BIN:$$PATH"
endef


# NOTE: for editing from within an instance of this editor, I recommend tossing
# this under a temporary makefile recipe so the syntax highlights appear properly
define download-tool-macro
	$(shell-prep-macro)
	if ! command -v $@ &> /dev/null; then
		echo "$@ not found"
		URL_TARGET="${$@_${HOST_DIST}_${HOST_ARCH}_url}"
		if [ -z "$$URL_TARGET" ]; then
			@echo "error: explicit support for '$HOST_ARCH' on '$HOST_DIST' has not been configured."
			exit 1
		fi
		EXTENSION=$${URL_TARGET##*.}


		# todo: add vars for TARBALL and STAGING_DIR to increase readability
		DIRNAME_STAGING="${DIRNAME_BASE_STAGING}-$@"
		INTERNAL_BIN_DIR="${$@_internal_bin_dir}"
		TARBALL_FILENAME="$@.tar.$$EXTENSION"
		wget -O "$$TARBALL_FILENAME" "$$URL_TARGET"
		if [ "$$EXTENSION" == "gz" ]; then
			@echo "info: artifact compressed with gzip"
			gunzip "$$TARBALL_FILENAME"
		elif [ "$$EXTENSION" == "xz" ]; then
			@echo "info: artifact compressed with xz"
			unxz "$$TARBALL_FILENAME"
		else
			@echo "error: artifact compressed in unsupported format '$$EXTENSION'"
			exit 1
		fi
		TARBALL_FILENAME="$@.tar"
		mkdir -v "$$DIRNAME_STAGING"
		tar -xvf "$$TARBALL_FILENAME" -C "$$DIRNAME_STAGING"
		DIR_TARGET=$$(ls "$$DIRNAME_STAGING")
		mv -v "$$DIRNAME_STAGING/$$DIR_TARGET" "${USER_SRC}/"
		(
			cd ${USER_BIN} && ln -s ${USER_SRC}/$$DIR_TARGET$$INTERNAL_BIN_DIR/$@ .
		)
		rm -v "$$TARBALL_FILENAME"
		rmdir -v "$$DIRNAME_STAGING"
	fi
	echo "runnable for '$@' located at $$(command -v $@)"
	$@ --version
endef


define ensure-cli-feature-macro
	@if ! command -v $@ &> /dev/null; then
		@echo "error: could not find '$@' on PATH"
		@exit 1
	@fi

	@echo "Found '$@' binary."
	@$@ --version
endef


###############################################################################
###############################################################################
# GENERAL PURPOSE RECIPES
###############################################################################
###############################################################################

.PHONY: install submodules fd rg node npm nvim nvim-config
install: submodules fd rg node npm nvim nvim-config
	echo "installer source code incomplete"
	exit 1

initialize-plugins: nvim nvim-config node fd
	$(shell-prep-macro)

	# ensure plugins are installed
	# todo: needs to point to the installation in the build directory (once we get there)
	nvim --headless "+Lazy! sync" +qa

	# ensure the mason tools are installed
	# todo: needs to use the downloaded configs plugins
	TARGET=$$(fd --type f mason-installs.lua .)
	CONTENTS=$$(sed -n '/local installs = {/,/}/p' "$$TARGET" | sed '1d;$d' | sed 's/[",]//g' | xargs echo)
	nvim --headless "+MasonInstall $$CONTENTS" +qa
	nvim --headless "+MasonToolsInstall" +qa

	# todo: revise for build directory
	TARGET=$$(fd --type f treesitter-parsers.lua .)
	CONTENTS=$$(sed -n '/local installs = {/,/}/p' "$$TARGET" | sed '1d;$d' | sed 's/[",]//g' | xargs echo)
	nvim --headless "+TSInstallSync $$CONTENTS" +qa



################################################################################
################################################################################
# CONFIGURATION INSTALLATIONS
################################################################################
################################################################################

nvim-config: git submodules
	$(shell-prep-macro)
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


################################################################################
################################################################################
# TOOLING INSTALLATIONS
################################################################################
################################################################################

nvim_internal_bin_dir:=/bin
nvim_Linux_x86_64_url:=https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
nvim_Darwin_arm64_url:=https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-macos.tar.gz
nvim: xz wget
	$(download-tool-macro)

fd_internal_bin_dir:=
fd_Linux_x86_64_url:=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz
fd_Darwin_arm64_url:=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-aarch64-apple-darwin.tar.gz
fd: wget xz ${USER_SRC} ${USER_BIN}
	$(download-tool-macro)

rg_internal_bin_dir:=
rg_Linux_x86_64_url:=https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
rg_Darwin_arm64_url:=https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-aarch64-apple-darwin.tar.gz
rg: wget xz ${USER_SRC} ${USER_BIN}
	$(download-tool-macro)

node_internal_bin_dir:=/bin
node_Linux_x86_64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz
node_Darwin_arm64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-darwin-arm64.tar.gz
node: wget xz ${USER_SRC} ${USER_BIN}
	$(download-tool-macro)

# NOTE: npm is a runnable packaged with node. no fancy download logic here.
npm: node ${USER_SRC} ${USER_BIN}
	$(shell-prep-macro)
	if ! command -v $@ &> /dev/null; then
		echo "$@ not found"
		DIRPATH=$$(dirname $$(readlink $$(command -v node)))
		if [ ! -f "$$DIRPATH/$@" ]; then
				echo "$@ installation could not be found at $$NODE_PATH"
				exit 1
		fi
		cd ${USER_BIN} && ln -s $$DIRPATH/$@ .
	fi
	echo "$@ binary located at $$(command -v $@)"
	$@ --version

################################################################################
################################################################################
# INSTALLATION DIRECTORY TARGETS
################################################################################
################################################################################

${USER_BIN}:
	mkdir -vp $@

${USER_SRC}:
	mkdir -vp $@

${USER_DOTCONFIG}:
	mkdir -vp $@


################################################################################
################################################################################
# REPOSITORY BUILD-TIME DEPENDENCY TARGETS
################################################################################
################################################################################

submodules: git
	git submodule update --init --recursive
	@echo "repository submodules initialized and ready for use."

# todo: add this as a requirement to anything that calls the web
internet: 
	@ping -c 1 -w 5 1.1.1.1

################################################################################
################################################################################
# ASSUMED CLI BINARY FEATURES
################################################################################
################################################################################

.PHONY: wget xz zip gcc g++ file xattr git


wget:
	$(ensure-cli-feature-macro)

xz:
	$(ensure-cli-feature-macro)

zip:
	$(ensure-cli-feature-macro)

gcc:
	$(ensure-cli-feature-macro)

g++:
	$(ensure-cli-feature-macro)

file:
	$(ensure-cli-feature-macro)

xattr:
	$(ensure-cli-feature-macro)

git:
	$(ensure-cli-feature-macro)
