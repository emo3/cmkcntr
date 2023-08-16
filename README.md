# cmkcntr

This cookbook installs and run's CheckMK container within podman.
The CheckMK Enterprize 
https://download.checkmk.com/checkmk/2.1.0p26/check-mk-enterprise-docker-2.1.0p26.tar.gz

# create self-signed keys
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout checkmks.key -out checkmks.crt -subj "/CN=checkmks.vagrantup.com" \
  -addext "subjectAltName=DNS:checkmks,DNS:checkmks.vagrant.com,IP:10.1.1.20"
# access shell inside a podman container
podman exec -it dvomon bash
