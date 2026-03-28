# Détecter et migrer les templates Sylius modifiés entre deux versions

Identifie les templates ShopBundle qui ont changé entre deux tags Sylius sur GitHub,
puis applique la migration Tailwind CSS / daisyUI pour chacun d'eux.

**Usage :** `/check-sylius-updates v2.2.3 v2.2.4`

`$ARGUMENTS` = deux tags séparés par un espace, ex: `v2.2.3 v2.2.4`
Si un seul tag est fourni, il est utilisé comme `TO_VERSION` et la version mémorisée est `FROM_VERSION`.
Si aucun argument, comparer la version mémorisée avec la dernière release GitHub.

---

## Étapes

### 1. Déterminer FROM_VERSION et TO_VERSION

- **2 arguments** : `FROM_VERSION` = premier, `TO_VERSION` = second.
- **1 argument** : `TO_VERSION` = argument fourni. `FROM_VERSION` = version mémorisée en mémoire projet (`v2.2.3` au 2026-03-28).
- **0 argument** : `FROM_VERSION` = version mémorisée. Récupérer la dernière release comme `TO_VERSION` :

```bash
gh api repos/Sylius/Sylius/releases/latest --jq '.tag_name'
```

**Version mémorisée (vendor actuel) : `v2.2.3`**

### 2. Appeler l'API GitHub Compare

```bash
gh api "repos/Sylius/Sylius/compare/{FROM_VERSION}...{TO_VERSION}" \
  --jq '{
    status: .status,
    total_commits: .total_commits,
    files_count: (.files | length),
    template_files: [
      .files[] | select(.filename | contains("Bundle/ShopBundle/templates")) | {
        file: .filename,
        status: .status
      }
    ]
  }'
```

**Si `files_count` == 300 et `total_commits` > 300** : la réponse est tronquée.
Dans ce cas, passer à l'étape 2b.

### 2b. Fallback pour les grands écarts (si tronqué)

Itérer sur les commits de l'intervalle en filtrant par path :

```bash
# Page 1
gh api "repos/Sylius/Sylius/commits?sha={TO_VERSION}&per_page=100&page=1" \
  --jq '.[] | {sha: .sha, message: .commit.message}'

# Pour chaque commit SHA, récupérer les fichiers modifiés
gh api "repos/Sylius/Sylius/commits/{SHA}" \
  --jq '.files[] | select(.filename | contains("Bundle/ShopBundle/templates")) | {file: .filename, status: .status}'
```

Continuer jusqu'à atteindre un commit antérieur à `FROM_VERSION` (vérifier avec le compare).

> Note : cette étape est coûteuse en appels API. Préférer des comparaisons patch→patch pour éviter ce cas.

### 3. Filtrer et classer les templates

Pour chaque fichier trouvé, extraire le chemin relatif depuis `templates/` :

- Source : `src/Sylius/Bundle/ShopBundle/templates/{path}`
- Thème  : `themes/TailwindTheme/templates/bundles/SyliusShopBundle/{path}`

Classer les fichiers en 3 catégories :
- **À mettre à jour** : fichier `modified` ET présent dans le thème
- **À créer** : fichier `added` OU `modified` ET absent du thème
- **Supprimé upstream** : fichier `removed` (vérifier si présent dans le thème pour le supprimer)

```bash
# Vérifier si un template existe dans le thème
ls themes/TailwindTheme/templates/bundles/SyliusShopBundle/{path} 2>/dev/null
```

### 4. Afficher le rapport de détection

Présenter un rapport structuré avant de commencer les migrations :

```
## Templates Sylius modifiés entre {FROM_VERSION} et {TO_VERSION}

### À mettre à jour dans le thème (X fichiers)
- account/order/show/content/breadcrumbs.html.twig [modified]

### À créer dans le thème (Y fichiers)
- checkout/summary/content/main.html.twig [added]

### Supprimés upstream — à vérifier (Z fichiers)
- ...
```

Si aucun template ShopBundle n'a changé, s'arrêter ici.

### 5. Migrer chaque template — fichier par fichier

Traiter les fichiers dans cet ordre : d'abord les `modified`, puis les `added`.
**Ne pas traiter plusieurs fichiers en parallèle** — procéder un par un et attendre validation si nécessaire.

#### Cas A — Fichier `modified` (existait déjà dans le thème)

L'objectif est d'intégrer les changements upstream dans la version Tailwind existante **sans écraser le travail déjà fait**.

1. Récupérer l'ancienne version du fichier source (avant le changement) via l'API GitHub :
```bash
gh api "repos/Sylius/Sylius/contents/{path}?ref={FROM_VERSION}" --jq '.content' | base64 -d
```

2. Lire la nouvelle version depuis le vendor local :
```
vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/templates/{path}
```

3. Analyser **ce qui a changé** entre les deux versions Bootstrap :
   - Nouvelle structure HTML ajoutée ?
   - Attribut Twig modifié (bloc, variable, include) ?
   - Logique métier ajoutée/modifiée ?
   - Simple correction de classe CSS Bootstrap ?

4. Lire la version Tailwind existante dans le thème :
```
themes/TailwindTheme/templates/bundles/SyliusShopBundle/{path}
```

5. Appliquer l'équivalent du changement dans la version Tailwind :
   - Si c'est un changement de logique Twig → le reporter tel quel
   - Si c'est un ajout HTML avec classes Bootstrap → convertir en Tailwind/daisyUI
   - Si c'est une correction CSS Bootstrap → adapter en Tailwind
   - Conserver intacts tous les composants Symfony UX Live (`data-controller`, `data-model`, etc.)

#### Cas B — Fichier `added` (nouveau upstream, absent du thème)

Conversion Bootstrap → Tailwind from scratch :

1. Lire le fichier source depuis le vendor local
2. Créer le répertoire cible si nécessaire
3. Convertir en appliquant les règles de la table de correspondance (voir CLAUDE.md)
4. Utiliser daisyUI pour les composants interactifs
5. Utiliser la classe `heading` pour les titres `h1`–`h6`

#### Cas C — Fichier `removed` (supprimé upstream)

1. Vérifier si le fichier existe dans le thème
2. Si oui : signaler à l'utilisateur et demander confirmation avant suppression — le fichier thème peut avoir une raison d'exister indépendamment

### 6. Mettre à jour la version mémorisée

Après avoir traité tous les fichiers, si `TO_VERSION` correspond à la version dans `vendor/sylius/sylius/composer.json` :
- Mettre à jour `~/.claude/projects/-Users-adeliom-Documents-Projets-SyliusTailwindcssPlugin/memory/project_plugin_context.md` : ligne `Version Sylius dans vendor` → nouvelle version + date du jour.
- Mettre à jour ce fichier : **Version mémorisée** et exemple **Usage**.

### 7. Résumé final

```
## Migration terminée

- X fichiers mis à jour
- Y fichiers créés
- Z fichiers supprimés upstream (en attente de décision)

Version de référence mise à jour : {TO_VERSION} ({date})
```
