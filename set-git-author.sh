#!/bin/sh

# Include this file in ~/.profile

SSHFINGERPRINT=$(ssh-add -l 2>/dev/null | cut -d" " -f2)

if [ -z "${SSHFINGERPRINT}" ]; then
	return 0;
fi

for fp in $SSHFINGERPRINT; do
	USERLINE=$(grep "${fp}" /etc/gitusers 2>/dev/null)

	if [ ! -z "${USERLINE}" ]; then
		break;
	fi
done

USERLINE=$(grep "${SSHFINGERPRINT}" /etc/gitusers 2>/dev/null)

if [ -z "${USERLINE}" ]; then
	return 0;
fi

GIT_AUTHOR_NAME=$(echo ${USERLINE} | cut -d"|" -f2)
GIT_AUTHOR_EMAIL=$(echo ${USERLINE} | cut -d"|" -f3)

unset HASAGENT
unset SSHFINGERPRINT
unset USERLINE

export GIT_AUTHOR_NAME
export GIT_AUTHOR_EMAIL
