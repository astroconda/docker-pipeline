#!/bin/bash -x
if [[ ! -f /.dockerenv ]]; then
    echo "This script cannot be executed outside of a docker container."
    exit 1
fi

rm -rf "${HOME}/.astropy"
rm -rf "${HOME}/.cache"
rm -rf "${HOME}"/*

sudo yum clean all
sudo rm -rf /tmp/*
sudo rm -rf /var/cache/yum

for logfile in /var/log/*
do
    sudo truncate --size=0 "${logfile}"
done
