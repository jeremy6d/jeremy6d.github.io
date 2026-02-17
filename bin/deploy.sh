#!/bin/sh
hugo && rsync -avzp --delete -e 'ssh -p 24197 -i ~/.ssh/1984_id_rsa' public/ jeremy@oswg1:/var/www/jeremyweiland.com/
exit 0
