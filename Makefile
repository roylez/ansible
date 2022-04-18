APPLY_LOCAL = ansible-playbook --become --ask-vault-pass --extra-vars='remote_user=root'

role ?= vps 			# default role
file ?= vps.yml			# default playbook

.PHONY: *
playbook:
	$(APPLY_LOCAL) $(file)

proxmox:
	ansible-playbook proxmox.yml

mac:
	ansible-playbook --ask-become-pass mac.yml

role:
	ansible localhost -o --ask-vault-pass -m include_role -a name=$(role)

deb:
	@grep -E 'Ubuntu|Debian' /etc/issue &>/dev/null || (echo "This is not a Debian/Ubuntu machine!"; exit 1)

test:
	sudo ignite run roylez/ansible-ubuntu --cpus 1 --memory 2GB --ssh -f ${PWD}:/root/ansible --name ubuntu
	sudo ignite ssh ubuntu
