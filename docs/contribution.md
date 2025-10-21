
## Requirement

- Be sure you have php 8.2 on your machine.
- Be sure you have docker on your machine.
- Create `composer.mk` file in `.makefile` directory and put you're composer token in it:
```
GITHUB_TOKEN ?= ghp_xxxxxxxxxxxxx
```
https://getcomposer.org/doc/articles/authentication-for-private-packages.md#github-oauth

## Installation

`make install`

## Usage

### Run theme plugin test

`make test.all`

### List all available commands

`make help`

### Stop

`make down`

### Reset project

`make reset`

