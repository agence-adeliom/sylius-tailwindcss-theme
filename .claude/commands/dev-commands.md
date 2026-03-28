# Development commands

## Docker (recommended)
```bash
make init           # Init environment + dependencies
make database-init  # Init DB + migrations
make load-fixtures  # Load fixtures (optional)
make up / make down
make php-shell
make node-shell
```

## Frontend
```bash
composer run frontend-clear  # Rebuild Tailwind assets
```

## Tests
```bash
vendor/bin/phpunit
make phpunit   # Docker

vendor/bin/behat --strict --tags="~@javascript&&~@mink:chromedriver"
make behat     # Docker
```

## Code quality
```bash
vendor/bin/phpstan analyse -c phpstan.neon -l max src/
vendor/bin/ecs check
```
