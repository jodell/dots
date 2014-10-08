default : git link

all: update git link

git :
	git submodule update --init --recursive
link :
	bin/linkify

update :
	git fetch && git pull origin master

apt :
	sudo apt-get install htop git-core tree vim
