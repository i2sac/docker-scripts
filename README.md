# docker-scripts

Collection de scripts utilitaires pour faciliter la gestion de Docker et Docker Compose.

## 📋 Description

Ce dépôt contient une série de scripts shell pratiques pour simplifier les opérations courantes avec Docker. Ces scripts permettent de gérer facilement le cycle de vie des conteneurs, images et volumes Docker.

## 📦 Prérequis

- **Docker** : Le moteur Docker doit être installé (ou utilisez le script `docker-reinstall.sh`)
- **Docker Compose** : Requis pour les scripts `docker-up.sh` et `docker-down.sh`
- **lazydocker** (optionnel) : Interface TUI pour Docker, utilisé par `docker-up.sh`
- **Système d'exploitation** : Ubuntu/Debian (pour le script de réinstallation)

## 🚀 Scripts disponibles

### `docker-up.sh`
Lance les services Docker Compose et ouvre lazydocker pour le monitoring.

**Fonctionnalités :**
- Démarre les conteneurs avec `docker-compose up -d`
- Reconstruit les images (`--build`)
- Force la recréation des conteneurs (`--force-recreate`)
- Lance lazydocker pour la gestion visuelle

**Usage :**
```bash
./docker-up.sh
```

### `docker-down.sh`
Arrête et supprime les conteneurs Docker Compose.

**Fonctionnalités :**
- Arrête tous les conteneurs définis dans docker-compose.yml
- Supprime les volumes (`-v`)
- Supprime les conteneurs orphelins (`--remove-orphans`)

**Usage :**
```bash
./docker-down.sh
```

### `docker-cleanup.sh`
Script interactif pour nettoyer les ressources Docker.

**Options disponibles :**
1. Supprimer tous les conteneurs
2. Supprimer toutes les images
3. Supprimer tous les volumes
4. Supprimer tout (conteneurs, images, volumes)
5. Quitter

**Usage :**
```bash
./docker-cleanup.sh
```

**⚠️ Attention :** Ce script supprime définitivement les données. Utilisez avec précaution en production.

### `docker-reinstall.sh`
Installe ou réinstalle Docker CE sur Ubuntu.

**Fonctionnalités :**
- Met à jour les paquets système
- Installe les prérequis nécessaires
- Ajoute le dépôt officiel Docker
- Installe Docker CE
- Vérifie le statut de l'installation

**Usage :**
```bash
./docker-reinstall.sh
```

## 💻 Installation

1. Clonez ce dépôt :
```bash
git clone https://github.com/i2sac/docker-scripts.git
cd docker-scripts
```

2. Rendez les scripts exécutables :
```bash
chmod +x *.sh
```

3. (Optionnel) Ajoutez le répertoire à votre PATH pour un accès global :
```bash
export PATH=$PATH:$(pwd)
```

## 📝 Exemples d'utilisation

### Démarrage rapide d'un projet
```bash
# Démarrer les services
./docker-up.sh

# Travailler sur votre projet...

# Arrêter les services
./docker-down.sh
```

### Nettoyage après développement
```bash
# Nettoyer les ressources Docker non utilisées
./docker-cleanup.sh
# Sélectionnez l'option 4 pour un nettoyage complet
```

### Installation de Docker sur une nouvelle machine
```bash
# Installer Docker
./docker-reinstall.sh
```

## ⚙️ Configuration

Ces scripts utilisent les fichiers `docker-compose.yml` présents dans le répertoire courant où ils sont exécutés. Assurez-vous d'avoir un fichier `docker-compose.yml` valide avant d'utiliser `docker-up.sh` et `docker-down.sh`.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer de nouvelles fonctionnalités
- Soumettre des pull requests

## 📄 Licence

Ce projet est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🔗 Liens utiles

- [Documentation Docker](https://docs.docker.com/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)
- [lazydocker](https://github.com/jesseduffield/lazydocker)

## 👤 Auteur

**i2sac**

---

*Ces scripts sont fournis "tels quels" sans garantie. Utilisez-les à vos propres risques.*