default : git link

all: update git link

git :
	git submodule update --init --recursive
link :
	bin/linkify

update :
	git fetch && git pull origin master
