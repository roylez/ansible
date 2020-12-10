#!/bin/bash
#

HOOK_URL=https://n.roylez.info/webhook/0db27f52-d126-4697-9742-216484f71b9e

host=$(hostname -f)
payload="{ \"text\": \"🐣 [<b>$host</b>] $*\" }"
curl -H 'Content-Type:application/json' -d "$payload" $HOOK_URL 
