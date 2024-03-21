.DEFAULT_GOAL := help
SHELL=/bin/bash

-include .makefile/global.mk

###
### ENV VERSIONS
### ¯¯¯

SYLIUS_VERSION=1.12.3
SYMFONY_VERSION=6.4
PLUGIN_NAME=agence-adeliom/sylius-tailwindcss-theme

###
### DEVELOPMENT
### ¯¯¯¯¯¯¯¯¯¯¯

-include .makefile/dev.mk

###
### CI
### ¯¯¯¯¯¯¯¯¯¯¯

-include .makefile/ci.mk




