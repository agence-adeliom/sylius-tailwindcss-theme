
## Requirement

- Be sure you have node 14 on your machine. You can use NVM to easily switch versions.
- Be sure you have docker on your machine.
- Be sure you have the Symfony binary on your machine `curl -sS https://get.symfony.com/cli/installer | bash`

## Installation

`make install`

- Go https://127.0.0.1:8000 (check your console)

This will run a Sylius app (the one in tests/Application/) with the plugin installed and all Sylius' sample data. It uses the symfony binary.

## Usage

### List all available commands

`make help`

### Running minimum plugin tests

- Lint twig

    `make test.twig`

[//]: # (- PHPUnit)

[//]: # ()
[//]: # (    `make test.phpunit`)

[//]: # ()
[//]: # (- PHP CS fixer)

[//]: # ()
[//]: # (    `make test.phpcs` Tip: You can fix your code with `make test.phpcs.fix`!)

[//]: # ()
[//]: # (- PHPSpec)

[//]: # ()
[//]: # (    `make test.phpspec`)

[//]: # ()
[//]: # (- PHPStan)

[//]: # ()
[//]: # (    `make test.phpstan`)

### Build assets

The Sylius app is installed here `tests/Application/`

- Build assets

    ```bash
    $ make build-theme
    $ make watch-theme
    ```

- Apply change : `ROOT THEME FILES` from / to `PROJECT THEME FILES `

    ```bash
    $ make apply-theme # Update tests/Application project theme files with root theme files)

    $ make reset-theme # Reversed operation
    ```

### Stop

`make down`

### Reset project

`make reset`

