APPLY_LOCAL = ansible-playbook --become --ask-vault-pass --extra-vars='remote_user=root'

role ?= vps 			# default role
file ?= node.yml		# default playbook

.PHONY: *
playbook: deb
	$(APPLY_LOCAL) $(file)

proxmox:
	ansible-playbook proxmox.yml

role:
	ansible localhost -o --ask-vault-pass -m include_role -a name=$(role)

deb:
	@grep -E 'Ubuntu|Debian' /etc/issue &>/dev/null || (echo "This is not a Debian/Ubuntu machine!"; exit 1)

