# Relative root dir ("."|".."|"../.."|…)
_ROOT_DIR := $(patsubst ./%,%,$(patsubst %/.makefile/Makefile,%,./$(filter %.makefile/Makefile,$(MAKEFILE_LIST))))
# Is current dir root ? (""|"1")
_ROOT := $(if $(filter .,$(_ROOT_DIR)),1)
# Relative current dir ("."|"foo"|"foo/bar"|…)
_DIR := $(patsubst ./%,%,.$(patsubst $(realpath $(CURDIR)/$(_ROOT_DIR))%,%,$(CURDIR)))

include $(_ROOT_DIR).makefile/helper/_text.mk
include $(_ROOT_DIR).makefile/helper/_help.mk
include $(_ROOT_DIR).makefile/helper/_os.mk
include $(_ROOT_DIR).makefile/helper/_git.mk
