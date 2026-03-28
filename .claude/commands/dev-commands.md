# Commandes de développement

## Docker (recommandé)
```bash
make init           # Init environnement + dépendances
make database-init  # Init BDD + migrations
make load-fixtures  # Charger les fixtures (optionnel)
make up / make down
make php-shell
make node-shell
```

## Frontend
```bash
composer run frontend-clear  # Rebuild assets Tailwind
```

## Tests
```bash
vendor/bin/phpunit
make phpunit   # Docker

vendor/bin/behat --strict --tags="~@javascript&&~@mink:chromedriver"
make behat     # Docker
```

## Qualité de code
```bash
vendor/bin/phpstan analyse -c phpstan.neon -l max src/
vendor/bin/ecs check
```
