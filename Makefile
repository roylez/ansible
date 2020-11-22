APPLY_LOCAL = ansible-playbook --become --inventory=localhost, --ask-vault-pass --extra-vars='remote_user=root'

.PHONY: *
local_node: 
	$(APPLY_LOCAL) node.yml
local_vps: 
	$(APPLY_LOCAL) vps.yml
local_api_node: 
	$(APPLY_LOCAL) api.yml
