## Quickstart Installation

### Prerequis

- Install [DDEV](https://ddev.readthedocs.io/en/stable/)

### Test project locally with DDEV

1. Adjust ddev configuration and choose your php, database and node version.

2. Run install command : 
    
    ```bash
    $ make install-project
    ```
    Default values : XX=1.12.13 and YY=6.4 and ZZ=8.2
    
    To test other versions :
    ```bash
    $ make install-project -e SYLIUS_VERSION=XX SYMFONY_VERSION=YY
    ```

3. Navigate here : https://sylius-tailwindcss-theme.ddev.site/

4. To reset (drop database and delete files) dev environment:

    ```bash
    $ make remove-project
    ```

### Modify code

After project installation, you can modify themes files here `templates/bundles/`.
To send files into your installed test project just execute following command after changes :

1. Apply changes

    ```bash
    $ make apply-changes
    ```

2. Build changes

    ```bash
    $ make build-changes
    # Or
    $ make watch-changes
    ```

3. Lint changes

    ```bash
    $ make lint-changes
    ```

