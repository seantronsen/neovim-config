#!/bin/bash

# todo: need to document this script and the expected env vars.

function download-tool() {
	TOOL_NAME=${1}
	TOOL_URL=${2}
	DIR_STAGING=${3}
	INTERNAL_BIN_DIR=${4}
	PATH_EXTENSION=${5}
	$6
	${6}

	if [ -n "$PATH_EXTENSION" ]; then
		export PATH="$PATH_EXTENSION:$PATH"
	fi

	if ! command -v $TOOL_NAME &>/dev/null; then
		echo "$TOOL_NAME not found"
		if [ -z "$TOOL_URL" ]; then
			echo "error: explicit support for '$(uname -m)' on '$(uname -s)' has not been configured."
			return 1
		fi

		EXTENSION=${URL_TARGET##*.}
		TARBALL_FILENAME="$TOOL_NAME.tar.$EXTENSION"
		wget -O "$TARBALL_FILENAME" "$TOOL_URL"
		if [ "$EXTENSION" == "gz" ]; then
			echo "info: artifact compressed with gzip"
			gunzip "$TARBALL_FILENAME"
		elif [ "$EXTENSION" == "xz" ]; then
			echo "info: artifact compressed with xz"
			unxz "$TARBALL_FILENAME"
		else
			echo "error: artifact compressed in unsupported format '$EXTENSION'"
			return 1
		fi
		TARBALL_FILENAME="$TOOL_NAME.tar"
		mkdir -v "$DIRNAME_STAGING"
		tar -xvf "$TARBALL_FILENAME" -C "$DIRNAME_STAGING"
		DIR_TARGET=$(ls "$DIRNAME_STAGING")
		mv -v "$DIRNAME_STAGING/$DIR_TARGET" "${USER_SRC}/"
		(
			cd ${USER_BIN} && ln -s ${USER_SRC}/$DIR_TARGET$INTERNAL_BIN_DIR/$TOOL_NAME .
		)
		rm -v "$TARBALL_FILENAME"
		rmdir -v "$DIRNAME_STAGING"
	fi
	echo "runnable for '$TOOL_NAME located at $(command -v $TOOL_NAME)"
	$TOOL_NAME --version
}

download-tool $@
