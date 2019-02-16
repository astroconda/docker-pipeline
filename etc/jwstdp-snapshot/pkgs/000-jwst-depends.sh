#!/bin/bash
deps=(
    freetds
    unixodbc
)
sudo yum install -y ${deps[@]}
