APPLY_LOCAL = ansible-playbook --become --ask-vault-pass --extra-vars='remote_user=root'
APPLY       = ansible-playbook

.PHONY: *
deb:
	 @grep -E 'Ubuntu|Debian' /etc/issue &>/dev/null || (echo "This is not a Debian/Ubuntu machine!"; exit 1)

node: deb
	$(APPLY_LOCAL) node.yml
vps:  deb 
	$(APPLY_LOCAL) vps.yml
api_node:  deb
	$(APPLY_LOCAL) api.yml

proxmox:
	$(APPLY) proxmox.yml
