#!/usr/bin/env bash

prefix="BASTION_USER_"

# Check environment variables
_checkEnv() {
    if ! (env | grep -q ${prefix}); then
        echo "Error: not found environment variables \"${prefix}*\", exiting..."
        exit 1
    fi
}

# Preparing system parameters
_sysPrep() {
    if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
        ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
    fi

    if [ ! -f /etc/ssh/ssh_host_dsa_key ]; then
        ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
    fi

    if [ ! -f /etc/ssh/ssh_host_ecdsa_key ]; then
        ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
    fi

    if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
        ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
    fi
}

# Create users and add 'authorized_keys' file
_createUsers() {
    userVars=$(compgen -v ${prefix})
    for userVar in ${userVars}; do
        userName=$(echo ${userVar} | cut -d _ -f 3 | awk '{print tolower($0)}')
        userKey=$(eval echo \$${userVar})
        
        if ! (id -u ${userName} >/dev/null 2>&1); then
            adduser -D ${userName} -s /bin/false
            passwd -u ${userName}
            mkdir -p /home/${userName}/.ssh
            echo ${userKey} > /home/${userName}/.ssh/authorized_keys
            chown -R ${userName}:${userName} /home/${userName}/.ssh
            chmod 700 /home/${userName}/.ssh
            chmod 600 /home/${userName}/.ssh/*
        fi
    done
}

# Starting sshd
_startSSHD() {
    if (pgrep -fl sshd >/dev/null 2>&1); then
        echo "Info: sshd process already running, killing..."
        pkill -9 sshd
    fi

    /usr/sbin/sshd -D -p 22 -f /etc/sshd_config &
    sleep 1
    echo "Info: sshd process started!"
}

# Checking process is running
_healthCheck() {
    while (pgrep -fl sshd >/dev/null 2>&1)
    do
        sleep 5
    done

    echo "Error: sshd is not running, exiting..."
    exit 1
}

_checkEnv
_sysPrep
_createUsers
_startSSHD
_healthCheck
