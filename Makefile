SHELL:=/bin/bash
B_DEPENDENCIES_LIST=git wget xz unxz zip gcc g++ file python3 pip
P_DEPENDENCIES_LIST=virtualenv
D_BUILD=${PWD}/build
B_DEPENDENCIES=${D_BUILD}/bpackages
P_DEPENDENCIES=${D_BUILD}/ppackages
SUBMODULES=${D_BUILD}/submodules
DCOMMON=${D_BUILD}
ACOMMON=${B_DEPENDENCIES} ${P_DEPENDENCIES} ${SUBMODULES}
OBJS=${D_BUILD}


all: ${ACOMMON}

${B_DEPENDENCIES}: ${DCOMMON}
	source bash-common-lib/lib.bash; binary_dependency_check ${B_DEPENDENCIES_LIST};
	touch $@

${P_DEPENDENCIES}: ${DCOMMON} ${B_DEPENDENCIES}
	source bash-common-lib/lib.bash; python_dependency_check ${P_DEPENDENCIES_LIST};
	touch $@

${SUBMODULES}: ${DCOMMON} ${B_DEPENDENCIES}
	git submodule init
	git submodule update
	touch $@

${D_BUILD}:
	mkdir -v $@


.PHONY: list
list:
	ls -lath ${D_BUILD}


.PHONY: clean
clean:
	rm -vrf ${D_BUILD}
