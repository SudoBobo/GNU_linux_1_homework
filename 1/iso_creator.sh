#!/bin/sh

#set -u

OK_MSG="done"
ERR_MSG="error"

# Defaults
ISO_NAME="iso_image"
DIR="test_dir1"

# Reading named args
while getopts i:d:u:g: option
do
case "${option}"
in
i) ISO_NAME=${OPTARG};;
d) DIR=${OPTARG};;
u) I_USER=${OPTARG};;
g) GROUP=${OPTARG};;
esac
done

# Here we could check args (for example, check that given DIR exists and
# current user has -r access to it) But as task says "print 'error' for all errors"
# we don't do it. If something would go wrong, mkisofs will return non-zero.


# Run the command that do the job.
mkisofs -J -o "${ISO_NAME}" "${DIR}" &>/dev/null
if [[ $? != 0 ]];
then
    echo "${ERR_MSG}" && exit 1
fi

# Change user and group of resulting file.
if [ -n "${I_USER}" ];
then
    chown "${I_USER}" "${ISO_NAME}" &>/dev/null
fi

if [ -n "${GROUP}" ];
then
    chown "${I_USER}":"${GROUP}" "${ISO_NAME}" &>/dev/null
fi

# Check user/group changing for errors.
if [[ $? != 0 ]]
then
    echo "${ERR_MSG}" && exit 1
fi

echo "${OK_MSG}" && exit 0
