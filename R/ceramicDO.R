
library(analogsea)

run = FALSE

if (run) {
account()

regions()

droplet_create(name = "CeramicI",
                size = "s-1vcpu-2gb",
                image = "ubuntu-22-04-x64",
                region =  "sgp1")
 # Using default ssh keys: alex_id_rsa_digitalocean_1, macbookaartumsleutel, ssh-key, id_rsa.pub, lucia@MacBook-Pro.local, DOcomposeDBtrest

# <droplet>CeramicI (375795422)
# IP:        178.128.107.124
# Status:    active
# Region:    Singapore 1
# Image:     22.04 (LTS) x64
# Size:      s-1vcpu-2gb
# Volumes:

volume_create( name = "ceramicvol", size = 20,  description = "Storage for CeramicIVol",  region = "sgp1")
# <volume> ceramicvol (6d33e1c6-5876-11ee-a010-0a58ac14a457)
# Descr.:     Storage for CeramicIVol
# Region:     sgp1
# Size (GB):  20
# Created:    2023-09-21T12:00:15Z

volume_attach("ceramicvol", "CeramicI", region = "sgp1")

# Install jq, nodejs, npm, postgres
# sudo su - postgres
# psql
# CREATE DATABASE ceramic;
# CREATE ROLE ceramic WITH PASSWORD 'Nova1994' LOGIN;
# GRANT ALL PRIVILEGES ON DATABASE "ceramic" to ceramic;

# Project Name toetsteel
# File to save DID private key to? (Escape to skip) /root/toetsteel/admin.sk
# Generated DID: did:key:z6Mkv1wDZBtj24ayJkSF6RztsKh5kRNc7LR5Ez5UX2a73fho

#  npm install -g @ceramicnetwork/cli

pk <- capture.output(droplet_ssh(droplet = "CeramicI", code = "less ~/toetsteeel/admin.sk"))
daemon <- capture.output(droplet_ssh(droplet = "CeramicI", code = "less ~/toetsteeel/daemon_config.json"))
did <- "did:key:z6MkuWQxGjMtpdSCzfTRYCXZ3viiL855jaxBYzqKsd9PpmEf"

getCeramicStatus(key = did, url = "http://178.128.107.124:7007/")

}
