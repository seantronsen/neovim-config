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
REQUIRED_SYSTEM_COMMANDS:=cp echo wget xz zip gcc g++ file xattr git python3 \
													mkdir mv rm readlink dirname realpath tar gzip unzip \
													unxz grep

# LOAD BASH LIBRARY TO INITIALIZE SEVERAL DIRECTORY TARGET VARIABLES
USER_BIN ?= ${HOME}/bin
USER_SRC ?= ${HOME}/src
USER_DOTCONFIG ?= ${HOME}/.config
USER_DATA ?=${HOME}/.local/share

# GENERAL SCRIPTING
OBJS:=${PATH_BUILD}

PROGRAMS:=nvim fd rg node npm
CONFIGS:=nvim
PROGRAM_DATA:=nvim

################################################################################
################################################################################
# issue
################################################################################
################################################################################
# describe the problem: need to prevent the user attempting to install into the
# target path while existing at the target path or a child path of the target
# path.
#
# example: running `make install` when the target path is `~/.config/nvim` and
# the shell PWD=`~/.config/nvim` or PWD=`~/.config/nvim/childA/childB/...`
#
#
# therefore, for each illegal path (`~/.config/nvim` and children in this case)
# assert the target path does not match
#
#
# just use grep dumbasss.
#
#
#
#


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
npm_internal_bin_dir:=${node_internal_bin_dir}
node_Linux_x86_64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-linux-x64.tar.xz
node_Darwin_arm64_url:=https://nodejs.org/dist/v20.18.0/node-v20.18.0-darwin-arm64.tar.gz

################################################################################
################################################################################
# CANNED RECIPES / MACROS
################################################################################
################################################################################


# NOTE: for editing from within an instance of this editor, I recommend tossing
# this under a temporary makefile recipe so the syntax highlights appear properly
# TODO: SWITCH TO AN EXTERNAL SCRIPT (IN PROGRESS)
define download-tool-macro
	set -e
	mkdir -vp ${PATH_ARTIFACTS}
	mkdir -vp ${PATH_STAGE}
	URL_TARGET=${${@F}_${HOST_DIST}_${HOST_ARCH}_url}
	if [ -z "$${URL_TARGET}" ]; then
		@echo "error: explicit support for '${HOST_ARCH}' on '${HOST_DIST}' has not been configured."
		exit 1
	fi

	case "$${URL_TARGET##*.}" in
		gz) UNZIP=gunzip ;;
		xz) UNZIP=unxz ;;
		*) exit 1 ;;
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
INSTALLATION_PATHS:=${USER_SRC} \
										${USER_BIN} $(addprefix ${USER_BIN}/, ${PROGRAMS}) \
										${USER_DOTCONFIG} $(addprefix ${USER_DOTCONFIG}/, ${CONFIGS})  \
										${USER_DATA} $(addprefix ${USER_DATA}/, ${PROGRAM_DATA})
ILLEGAL_PWDS:=${INSTALLATION_PATHS}

.PHONY: environment-check build initialize install
environment-check: ${REQUIRED_SYSTEM_COMMANDS} submodules
	@echo "environment verified. no build errors anticipated."
	@echo "check for existing local installations not configured."
	@for illegal_path in ${ILLEGAL_PWDS}; do \
		if echo "${PWD}" | grep -iq $${illegal_path}; then \
			echo "error: detected illegal installation path component: '$${illegal_path}'"; \
			echo "installation will not proceed while the current working directory"; \
			echo "matches any of the following paths: ";\
			for pn in ${ILLEGAL_PWDS}; do \
				echo "- $${pn}"; \
			done; \
			echo "${ILLEGAL_PWDS}"; \
			exit 1; \
		fi; \
	done;

	@if [ -e "${USER_BIN}/nvim" ]; then \
		echo "error: detected existing local nvim installation. terminating build sequence."; \
		exit 1; \
	fi; \

	exit 0

build: environment-check $(addprefix ${PATH_ARTIFACTS}/, ${PROGRAMS})
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
# todo: fixme: need edge case for nvim to install anyways
define standard-install-macro
	@if ! command -v ${@F}; then \
		set -e; \
		cp -vr $$(realpath "$<") $$(realpath "$@"); \
		echo "installed '${@F}' at path: '$@'"; \
	fi
endef

define standard-symlink-macro
	@if ! command -v ${@F}; then \
		set -e; \
		ln -vs $$(realpath "$<")${${@F}_internal_bin_path}/${@F} $$(realpath "$@"); \
		echo "symlinked '${@F}' to user local bin directory at path: '$@'"; \
	fi
endef

${USER_BIN}/nvim: ${USER_SRC}/nvim
	$(standard-symlink-macro)

${USER_SRC}/nvim: ${PATH_ARTIFACTS}/nvim
	$(standard-install-macro)

${USER_BIN}/rg: ${USER_SRC}/rg
	$(standard-symlink-macro)

${USER_SRC}/rg: ${PATH_ARTIFACTS}/rg
	$(standard-install-macro)

${USER_BIN}/fd: ${USER_SRC}/fd
	$(standard-symlink-macro)

${USER_SRC}/fd: ${PATH_ARTIFACTS}/fd
	$(standard-install-macro)

${USER_BIN}/node: ${USER_SRC}/node
	$(standard-symlink-macro)

${USER_SRC}/node: ${PATH_ARTIFACTS}/node
	$(standard-install-macro)

${USER_BIN}/npm: ${USER_SRC}/node
	$(standard-symlink-macro)

################################################################################
################################################################################
# PROGRAM DATA (PLUGINS, ETC.) INSTALLATION
################################################################################
################################################################################
${USER_DATA}/nvim: ${PATH_DATA}/nvim
	$(standard-install-macro)

################################################################################
################################################################################
# CONFIGURATION INSTALLATION
################################################################################
################################################################################
${USER_DOTCONFIG}/nvim: ${PATH_CONFIG}/nvim
	$(standard-install-macro)


################################################################################
################################################################################
# TOOLING INITIALIZATION / BUILD PROGRAM DATA DEPENDENCIES (PLUGINS, ETC.)
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
	$(download-tool-macro)

${PATH_ARTIFACTS}/fd:
	$(download-tool-macro)

${PATH_ARTIFACTS}/rg:
	$(download-tool-macro)

${PATH_ARTIFACTS}/node:
	$(download-tool-macro)

# NOTE: npm is a runnable packaged with node. no fancy download logic here.
${PATH_ARTIFACTS}/npm: ${PATH_ARTIFACTS}/node
	@set -e
	@mkdir -vp $@
	@echo "${@F} implicitly obtained during build process for $<"

################################################################################
################################################################################
# CONFIGURATION DOWNLOADS
################################################################################
################################################################################

${PATH_CONFIG}/nvim:
	@set -e
	@echo "verifying '${@F}' configuration files"
	@mkdir -vp "${PATH_CONFIG}"
	@git clone https://github.com/seantronsen/neovim-config.git $@

################################################################################
################################################################################
# INSTALLATION DIRECTORY TARGETS
################################################################################
################################################################################

# todo: add check to ensure user dotconfig isn't the empty string
# todo: if the user already has one installed in this location, it fails to check that
# can be fixed with convert to phony
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
$(1):
	@if ! command -v $(1) &> /dev/null; then
		@echo "error: could not find '$(1)' on PATH"
		@exit 1
	@fi

	@echo "found '$(1)' binary."
endef


.PHONY: ${REQUIRED_SYSTEM_COMMANDS}
$(foreach command_name,${REQUIRED_SYSTEM_COMMANDS},$(eval $(call verify-command-installation-macro,$(command_name))))


.PHONY: clean
clean:
	-rm -vrf ${OBJS}
