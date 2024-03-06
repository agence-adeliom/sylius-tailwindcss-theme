## Quickstart Installation

### Prerequis

- Install [DDEV](https://ddev.readthedocs.io/en/stable/)

### Localhost

1. Adjust ddev configuration and choose your php, database and node version.
2. Run install command : 



```bash
$ make install
```
Default values : XX=1.12.13 and YY=6.4 and ZZ=8.2

To test other versions :
```bash
$ make install -e SYLIUS_VERSION=XX SYMFONY_VERSION=YY
```

To reset (drop database and delete files) dev environment:
```bash
$ make reset
```
