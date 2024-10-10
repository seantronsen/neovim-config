SHELL ::= /bin/bash
.ONESHELL:


# CONFIGURATION VARIABLES
DIRNAME_BASE_STAGING:="STAGING"
PATH_BUILD:=build
PATH_STAGE:=${PATH_BUILD}/staging
PATH_ARTIFACTS:=${PATH_BUILD}/artifacts


# DETERMINE HOST PROPERTIES
HOST_DIST := $(shell uname -s)
HOST_ARCH := $(shell uname -m)

# LOAD BASH LIBRARY TO INITIALIZE SEVERAL DIRECTORY TARGET VARIABLES
USER_BIN := $(shell source bash-common-lib/lib.bash && echo $$USER_BIN)
USER_SRC := $(shell source bash-common-lib/lib.bash && echo $$USER_SRC)
USER_DOTCONFIG := $(shell source bash-common-lib/lib.bash && echo $$USER_DOTCONFIG)

# GENERAL SCRIPTING
OBJS:=${PATH_BUILD}

################################################################################
################################################################################
# work items: over goal is to switch this to something that can either install
# immediately, or defer installment until the payload is received by the target
# host.
# - change all downloadables to be unpackaged in the build directory
# - convert to: build first to local dir, archive or install now, and install
#   from archive
#
#
#
################################################################################
################################################################################

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
# TODO: SWITCH TO AN EXTERNAL SCRIPT (IN PROGRESS)
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

define download-tool-macro-new
	set -e
	mkdir -vp ${PATH_ARTIFACTS}
	mkdir -vp ${PATH_STAGE}
	URL_TARGET=${${@F}_${HOST_DIST}_${HOST_ARCH}_url}
	if [ -z "$${URL_TARGET}" ]; then
		@echo "error: explicit support for '${HOST_ARCH}' on '${HOST_DIST}' has not been configured."
		exit 1
	fi

	case "$${URL_TARGET##*.}" in
		gz)
			UNZIP=gunzip
			;;
		xz)
			UNZIP=unxz
			;;
		*)
			exit 1
			;;
	esac


	wget -O "${PATH_STAGE}/${@F}.tar.$${URL_TARGET##*.}" "$${URL_TARGET}"
	$${UNZIP} "${PATH_STAGE}/${@F}.tar"*
	mkdir -v "${PATH_STAGE}/${@F}"
	tar -xvf  "${PATH_STAGE}/${@F}.tar" -C "${PATH_STAGE}/${@F}"
	mv -v "${PATH_STAGE}/${@F}"/$$(ls "${PATH_STAGE}/${@F}") "${PATH_ARTIFACTS}/${@F}"
	rm -vrf "${PATH_STAGE}/${@F}"*
endef


###############################################################################
###############################################################################
# GENERAL PURPOSE RECIPES
###############################################################################
###############################################################################
.PHONY: build initialize install
build: $(addprefix ${PATH_ARTIFACTS}/, nvim fd rg node npm config.nvim) git submodules wget xz
	@echo "build complete. artifacts assembled in '${PATH_ARTIFACTS}'"

initialize: $(addprefix ${PATH_ARTIFACTS}/, nvim fd rg node npm config.nvim)
	@echo "initialization step not yet configured. "
	exit 1

.PHONY: submodules fd rg node npm nvim nvim-config
install: submodules fd rg node npm nvim nvim-config
	echo "installer source code incomplete"
	exit 1

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
	rm -vrf "$$HOME/.local/state/nvim" # logs dir

	# CLONE CURRENT CONFIGURATION
	cd "$$USER_DOTCONFIG" && git clone https://github.com/seantronsen/neovim-config.git nvim

${PATH_ARTIFACTS}/config.nvim: 
	@echo "downloading configuration files"
	@if [ -a "$@" ]; then exit 1; fi
	git clone https://github.com/seantronsen/neovim-config.git $@

# todo: add check to ensure user dotconfig isn't the empty string
${USER_DOTCONFIG}/nvim: ${PATH_ARTIFACTS}/config.nvim
	if [ -a $@ ]; then exit 1; fi
	mv -v $@ $<

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

${PATH_ARTIFACTS}/nvim:
	$(download-tool-macro-new)

fd_internal_bin_dir:=
fd_Linux_x86_64_url:=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz
fd_Darwin_arm64_url:=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-aarch64-apple-darwin.tar.gz
fd: wget xz ${USER_SRC} ${USER_BIN}
	$(download-tool-macro)

${PATH_ARTIFACTS}/fd:
	$(download-tool-macro-new)

rg_internal_bin_dir:=
rg_Linux_x86_64_url:=https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
rg_Darwin_arm64_url:=https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-aarch64-apple-darwin.tar.gz
rg: wget xz ${USER_SRC} ${USER_BIN}
	$(download-tool-macro)

${PATH_ARTIFACTS}/rg:
	$(download-tool-macro-new)

node_internal_bin_dir:=/bin
node_Linux_x86_64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz
node_Darwin_arm64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-darwin-arm64.tar.gz
node: wget xz ${USER_SRC} ${USER_BIN}
	$(download-tool-macro)


${PATH_ARTIFACTS}/node:
	$(download-tool-macro-new)

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


${PATH_ARTIFACTS}/npm: ${PATH_ARTIFACTS}/node
	@echo "npm implicitly obtained during build process for $<"


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

################################################################################
################################################################################
# ASSUMED CLI BINARY FEATURES
################################################################################
################################################################################

define verify-command-installation-macro
	@if ! command -v $@ &> /dev/null; then
		@echo "error: could not find '$@' on PATH"
		@exit 1
	@fi

	@echo "Found '$@' binary."
	@$@ --version
endef

.PHONY: wget xz zip gcc g++ file xattr git
wget:
	$(verify-command-installation-macro)

xz:
	$(verify-command-installation-macro)

zip:
	$(verify-command-installation-macro)

gcc:
	$(verify-command-installation-macro)

g++:
	$(verify-command-installation-macro)

file:
	$(verify-command-installation-macro)

xattr:
	$(verify-command-installation-macro)

git:
	$(verify-command-installation-macro)


.PHONY: clean
clean:
	-rm -vrf ${OBJS}
