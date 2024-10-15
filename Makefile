SHELL ::= /bin/bash
.ONESHELL:


# CONFIGURATION VARIABLES
DIRNAME_BASE_STAGING:="STAGING"
PATH_BUILD:=build
PATH_STAGE:=${PATH_BUILD}/staging
PATH_ARTIFACTS:=${PATH_BUILD}/artifacts
PATH_CONFIG:=${PATH_BUILD}/config
PATH_DATA:=${PATH_BUILD}/data


# DETERMINE HOST PROPERTIES
HOST_DIST := $(shell uname -s)
HOST_ARCH := $(shell uname -m)

# LOAD BASH LIBRARY TO INITIALIZE SEVERAL DIRECTORY TARGET VARIABLES
USER_BIN := $(shell source bash-common-lib/lib.bash && echo $$USER_BIN)
USER_SRC := $(shell source bash-common-lib/lib.bash && echo $$USER_SRC)
USER_DOTCONFIG := $(shell source bash-common-lib/lib.bash && echo $$USER_DOTCONFIG)
USER_DATA :=${HOME}/.local/share

# GENERAL SCRIPTING
OBJS:=${PATH_BUILD}

PROGRAMS:=nvim fd rg node npm
CONFIGS:=nvim
PROGRAM_DATA:=nvim


################################################################################
################################################################################
# TARGET SPECIFIC CONFIGURATION
################################################################################
################################################################################
nvim_internal_bin_dir:=/bin
nvim_Linux_x86_64_url:=https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
nvim_Darwin_arm64_url:=https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-macos.tar.gz

fd_internal_bin_dir:=
fd_Linux_x86_64_url:=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-gnu.tar.gz
fd_Darwin_arm64_url:=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-aarch64-apple-darwin.tar.gz

rg_internal_bin_dir:=
rg_Linux_x86_64_url:=https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
rg_Darwin_arm64_url:=https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-aarch64-apple-darwin.tar.gz

node_internal_bin_dir:=/bin
node_Linux_x86_64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz
node_Darwin_arm64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-darwin-arm64.tar.gz

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

.PHONY: environment-check build initialize install
environment-check: cp echo wget xz zip gcc g++ file xattr git python3 mkdir mv rm readlink dirname realpath tar gzip unzip unxz submodules
	@echo "environment verified. no build errors anticipated."

	@echo "check for existing local installations not configured."
	exit 1

build: $(addprefix ${PATH_ARTIFACTS}/, ${PROGRAMS})
	@echo "verified build. artifacts located in '${PATH_ARTIFACTS}'"

initialize: build $(addprefix ${PATH_DATA}/, ${PROGRAM_DATA})
	@echo "verified initialization. artifact plugins and dependencies located in '${PATH_DATA}'."

# install: submodules fd rg node npm nvim nvim-config
install: \
	${USER_SRC} \
	${USER_BIN} $(addprefix ${USER_BIN}/, ${PROGRAMS}) \
	${USER_DOTCONFIG} $(addprefix ${USER_DOTCONFIG}/, ${CONFIGS})  \
	${USER_DATA} $(addprefix ${USER_DATA}/, ${PROGRAM_DATA})

	@echo "installation successful."


################################################################################
################################################################################
# TOOLING INSTALLATION
################################################################################
################################################################################
${USER_BIN}/nvim: ${USER_SRC}/nvim
	exit 1

${USER_SRC}/nvim: ${PATH_ARTIFACTS}/nvim
	@cp -vr 
	exit 1


################################################################################
################################################################################
# TOOLING INITIALIZATION
################################################################################
################################################################################

${PATH_DATA}/nvim: $(addprefix ${PATH_ARTIFACTS}/, nvim node npm) $(addprefix ${PATH_CONFIG}/, nvim)
	@echo "preparing nvim instance for future deployment. an instance of the"
	@echo "application will open to install plugins and plugin specific"
	@echo "dependencies."
	mkdir -vp "${PATH_DATA}"
	export \
		XDG_CONFIG_HOME=$$(realpath "${PATH_CONFIG}") \
		XDG_DATA_HOME=$$(realpath "${PATH_DATA}") \
		PATH=$$(realpath "${PATH_ARTIFACTS}/node${node_internal_bin_dir})"):${PATH} && \
		./${PATH_ARTIFACTS}/nvim${nvim_internal_bin_dir}/nvim


################################################################################
################################################################################
# TOOLING DOWNLOADS
################################################################################
################################################################################

${PATH_ARTIFACTS}/nvim:
	$(download-tool-macro-new)

${PATH_ARTIFACTS}/fd:
	$(download-tool-macro-new)

${PATH_ARTIFACTS}/rg:
	$(download-tool-macro-new)

${PATH_ARTIFACTS}/node:
	$(download-tool-macro-new)

# NOTE: npm is a runnable packaged with node. no fancy download logic here.
${PATH_ARTIFACTS}/npm: ${PATH_ARTIFACTS}/node
	set -e
	mkdir -vp $@
	@echo "${@F} implicitly obtained during build process for $<"

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
# CONFIGURATION DOWNLOADS
################################################################################
################################################################################

${PATH_CONFIG}/nvim:
	set -e
	@echo "downloading configuration files"
	mkdir -vp "${PATH_CONFIG}"
	git clone https://github.com/seantronsen/neovim-config.git $@

# todo: add check to ensure user dotconfig isn't the empty string
# todo: if the user already has one installed in this location, it fails to check that
# can be fixed with convert to phony
${USER_DOTCONFIG}/nvim: ${PATH_ARTIFACTS}/config.nvim
	set -e
	if [ -a $@ ]; then exit 1; fi
	mv -v $@ $<



################################################################################
################################################################################
# INSTALLATION DIRECTORY TARGETS
################################################################################
################################################################################

# todo: these should be configurable. could just use of the xdg env vars?
${USER_BIN}:
	mkdir -vp $@

${USER_SRC}:
	mkdir -vp $@

${USER_DOTCONFIG}:
	mkdir -vp $@

${USER_DATA}:
	mkdir -vp $@

################################################################################
################################################################################
# REPOSITORY BUILD-TIME DEPENDENCY TARGETS
################################################################################
################################################################################

.PHONY: submodules

submodules: git
	@git submodule update --init --recursive && \
	echo "verified installation of required submodules.";

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

	@echo "found '$@' binary."
	# @$@ --version
endef

.PHONY: cp wget xz zip gcc g++ file xattr git python3 mkdir mv rm readlink dirname realpath tar gzip unzip unxz
echo:
	$(verify-command-installation-macro)

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

python3:
	$(verify-command-installation-macro)

mkdir:
	$(verify-command-installation-macro)

mv:
	$(verify-command-installation-macro)

rm:
	$(verify-command-installation-macro)

readlink:
	$(verify-command-installation-macro)

dirname:
	$(verify-command-installation-macro)

realpath:
	$(verify-command-installation-macro)

tar:
	$(verify-command-installation-macro)

gzip:
	$(verify-command-installation-macro)

unzip:
	$(verify-command-installation-macro)

unxz:
	$(verify-command-installation-macro)

cp:
	$(verify-command-installation-macro)

.PHONY: clean
clean:
	-rm -vrf ${OBJS}
