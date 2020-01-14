# sshd-bastion-dockerfile
Dockerfile for ssh-bastion server on Alpine Linux.

Features
----------
- It is possible to specify multiple users with their public ssh key by environment variables

- Supported Environment variables:
  - `BASTION_USER_XXX` - Username and ssh public key (required), for example:
    -e BASTION_USER_IIVANOV="ssh-rsa AAA..De7 iivanov@local" \
    -e BASTION_USER_PPETROV="ssh-rsa AAA..jB2 ppetrov@local"

- Exposed Ports:
  - 22/tcp

## For internal use.

## This repository is still in the alpha stage, and frequently changes. The program comes with no warranty expressed or implied.
