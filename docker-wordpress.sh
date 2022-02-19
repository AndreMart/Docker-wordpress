#!/bin/sh

set -o errexit
set -o nounset

IFS=$(printf '\n\t')

# Docker
sudo apt remove --yes docker docker-engine docker.io containerd runc || true
sudo apt update
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository --yes "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"
sudo systemctl enable docker
printf '\nDocker installed successfully\n\n'

printf 'Waiting for Docker to start...\n\n'
sleep 5

# Docker Compose
sudo wget --output-document=/usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/$(wget --quiet --output-document=- https://api.github.com/repos/docker/compose/releases/latest | grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')/run.sh"
sudo chmod +x /usr/local/bin/docker-compose
sudo wget --output-document=/etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose"
printf '\nDocker Compose installed successfully\n\n'

# Wordpress
read -p 'Project Name: ' PROJECT_NAME
read -sp 'DB Password: ' MYSQL_PASS
done

mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME" && touch docker-compose.yml

cat > docker-compose.yml <<EOL
version: "2"
services:
  mariadb:
    image: mariadb
    ports:
      - "8081:3306"
    restart: on-failure:5
    environment:
      MYSQL_ROOT_PASSWORD: $MYSQL_PASS
  wordpress:
    image: wordpress
    volumes:
      - ./public:/var/www/html
    ports:
      - "8080:80"
    restart: on-failure:5
    links:
      - mariadb:mysql
    environment:
      WORDPRESS_DB_PASSWORD: $MYSQL_PASS
EOL

docker-compose up -d

  production:
    vhost: "<your_domain_name>"
    wordpress_path: "<absolute_path_to_wp_installation>"
    database:
        name: "<db_name>"
        user: "<username>"
        password: "<password>"
        host: "localhost"
        charset: "utf8"
    ssh:
        host: "<hostname>"
        user: "<user>"
  #      password: "<password>"
EOL
fi
