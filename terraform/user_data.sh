#!/bin/bash
# Update sistema i instalacija docker-a
yum update -y
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# Instalacija docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Promena vlasnika na home folderu jer git klonira fajlove kao root
chown -R ec2-user:ec2-user /home/ec2-user

# Prelazak na home folder i kloniranje repozitorijuma
cd /home/ec2-user
if [ ! -d iso-projekat2 ]; then
  git clone https://github.com/AjlaFazlic/iso-projekat2.git
fi
cd iso-projekat2

# Montiranje EBS volumena na mongo-data (ako postoji /dev/xvdf)
if [ -b /dev/xvdf ]; then
  # Provera da li je volumen već formatiran
  FILESYSTEM=$(blkid -o value -s TYPE /dev/xvdf)
  if [ -z "$FILESYSTEM" ]; then
    mkfs -t ext4 /dev/xvdf
  fi

  mkdir -p /home/ec2-user/iso-projekat2/mongo-data

  # Provera da li je već montiran, ako nije montiraj
  if ! mountpoint -q /home/ec2-user/iso-projekat2/mongo-data; then
    mount /dev/xvdf /home/ec2-user/iso-projekat2/mongo-data
  fi

  # Dodaj u fstab samo ako već nije dodat
  grep -q "/dev/xvdf" /etc/fstab || echo "/dev/xvdf /home/ec2-user/iso-projekat2/mongo-data ext4 defaults,nofail 0 2" >> /etc/fstab
fi

# Pokretanje docker-compose kontejnera
docker-compose up -d
