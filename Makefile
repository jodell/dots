default : git link

git :
	git submodule update --init --recursive
link :
	bin/linkify
