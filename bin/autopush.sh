#!/bin/bash

cd ~/dev/dotfiles
source ~/.bash_profile
git add . > /dev/null
git commit -a -m 'auto-saved changes' > /dev/null
git push origin master > /dev/null

