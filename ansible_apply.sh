#!/bin/bash
ansible-playbook --become \
  --connection=local \
  --inventory=localhost, \
  --ask-vault-pass \
  --extra-vars='hosts=all remote_user=root' $*
