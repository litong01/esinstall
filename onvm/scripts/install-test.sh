#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

random-string()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}