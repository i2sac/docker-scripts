# Mise à jour des paquets
sudo apt update

# Installation des prérequis
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Ajout de la clé GPG
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Ajout du dépôt Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Installation de Docker
sudo apt update
sudo apt install -y docker-ce

# Vérification de l'installation
sudo systemctl status docker