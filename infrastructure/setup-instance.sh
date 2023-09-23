#!/bin/sh
set -e

sudo apt update
sudo apt upgrade -y

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create github user
sudo mkdir -p /home/app
sudo useradd --no-create-home --home-dir /home/app --shell /bin/bash github
sudo usermod --append --groups docker github
sudo usermod --append --groups docker ubuntu
sudo chown github:github -R /home/app

github_pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7HQZSqZgYv3ieNiWlxTU4TcQHdeQ0oQDr5CAYsG3s4iLB9TK7o8uaooyMeJoJHSHhwMgGA29rErc/vtx6Md/LRsKd1w+hlqXPqbqHgbcO8PA91mk0GUmJaO/Ht5U0eIq8IBOzysRz4V76HmD9tiKY7HJeSOW4FU80xryC097qLKo/GWU9f/KOYssX5dPv9By/T/hG41lIevdv8BkWlHdSp3Xk8n8OyvbRk2cYOYr11ZyACsm2Ce2q16aCqctXAbNE6rgaTHCAcYzcDHQoSRNwVT2jTux5ADOTUSxC6+GDqF/IWP4AeoQhME+GpMoUNB9tCp9gAqyCMRD6Y4onwUuLco77XEqwiGNj9aINcMj3IL/swJnqliAXarj5UnH67DLyM4TWZOiVOhYdYoBeqK5Kieyhum+F3p0+dqDWm8A3k6O8TZ8tjTnw6vQNqebdNoWcJGu7UlsRrfAz97p6YthyUSw5hJcExEURIUNhb528fFs2LHOGowzDNTW8SGmBTAKnA8vE4SHEAkSzvR2LE1Yj1DGFJfHQUyppG5HV+YYgI/O++T6Ez49cw0e7XhOmkHzNPJOhCh1Hytsm9/hLwAKrcghtqTf7TwKBLjC5s7aYUxEuFaptW71+3opV9PJUcggSHj6DJaHOcd8IWI3trSCkCnLYkFvXV4YMGWTAvKBE5w== 201160@ppu.edu.ps~
'

sudo -u github sh -c "mkdir -p /home/app/.ssh && echo $github_pubkey > /home/app/.ssh/authorized_keys"

sudo reboot