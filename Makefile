# Portable dotfiles. `make` installs; `make check` and `make test` verify.

SHELL := /bin/bash
UNAME := $(shell uname -s)

.PHONY: default all install link git update minimal deps check test test-docker helptags allowed-signers ale help

default: git link

all: update git link

## install -- init submodules and symlink everything
install: git link

## git -- fetch vim plugin submodules (shallow: much faster on a Pi)
git:
	git submodule update --init --recursive --depth 1

## link -- symlink the repo into $HOME
link:
	bin/linkify

## minimal -- shell/git/ssh only, no vim plugin tree. For servers.
minimal:
	git submodule update --init --depth 1 -- vendor/inkpot 2>/dev/null || true
	bin/linkify --minimal

## update -- pull this repo and refresh submodules
update:
	git fetch && git pull --ff-only origin main
	$(MAKE) git

## deps -- install the handful of packages these dotfiles assume
deps:
ifeq ($(UNAME),Darwin)
	brew bundle install --file=Brewfile
else
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && sudo apt-get install -y git vim tmux tree htop silversearcher-ag; \
	elif command -v dnf >/dev/null 2>&1; then \
		sudo dnf install -y git vim tmux tree htop the_silver_searcher; \
	elif command -v pacman >/dev/null 2>&1; then \
		sudo pacman -S --needed git vim tmux tree htop the_silver_searcher; \
	else \
		echo "no known package manager; install git vim tmux tree htop by hand" >&2; exit 1; \
	fi
endif

## check -- syntax-check every shell file and config in the repo
check:
	@fail=0; \
	for f in etc/shell/* etc/bashrc etc/bash_profile etc/profile; do \
		sh -n "$$f" || { echo "sh -n FAILED: $$f" >&2; fail=1; }; \
		bash -n "$$f" || { echo "bash -n FAILED: $$f" >&2; fail=1; }; \
	done; \
	for f in etc/zshrc etc/zprofile etc/shell/*; do \
		if command -v zsh >/dev/null 2>&1; then \
			zsh -n "$$f" || { echo "zsh -n FAILED: $$f" >&2; fail=1; }; \
		fi; \
	done; \
	for f in bin/* ; do \
		head -1 "$$f" | grep -q bash && { bash -n "$$f" || { echo "bash -n FAILED: $$f" >&2; fail=1; }; }; \
	done; \
	git config -f etc/gitconfig --list >/dev/null || { echo "gitconfig FAILED" >&2; fail=1; }; \
	ssh -G -F etc/ssh/config example.com >/dev/null 2>&1 || { echo "ssh config FAILED" >&2; fail=1; }; \
	if command -v tmux >/dev/null 2>&1; then \
		err=$$(mktemp); \
		tmux -f etc/tmux.conf new-session -d -s dotscheck 'sleep 30' 2>"$$err" || \
			{ echo "tmux.conf FAILED to load" >&2; fail=1; }; \
		if [ -s "$$err" ]; then echo "tmux.conf errors:" >&2; cat "$$err" >&2; fail=1; fi; \
		tmux kill-session -t dotscheck >/dev/null 2>&1 || true; \
		rm -f "$$err"; \
	fi; \
	if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck -s bash bin/linkify || fail=1; \
		shellcheck -s sh etc/shell/*.sh etc/profile || fail=1; \
	else \
		echo "(shellcheck not installed -- skipping lint)"; \
	fi; \
	[ $$fail -eq 0 ] && echo "check: OK"; exit $$fail

## test -- run the login-shell smoke test against this machine
test: check
	bin/smoke-test

## test-docker -- run the smoke test on Debian and Ubuntu
test-docker:
	@command -v docker >/dev/null 2>&1 || { echo "docker not installed" >&2; exit 1; }
	@for image in debian:stable-slim ubuntu:latest; do \
		echo "=== $$image ==="; \
		docker run --rm -v "$(PWD)":/dots:ro "$$image" \
			sh -c 'apt-get update -qq && apt-get install -qq -y git bash zsh >/dev/null && \
			       cp -r /dots /root/dots && cd /root/dots && bin/linkify --minimal >/dev/null && \
			       bin/smoke-test' || exit 1; \
	done
	@echo "test-docker: OK"

## allowed-signers -- rebuild ~/.ssh/allowed_signers from your signing key
allowed-signers:
	@key=$$(git config --get user.signingkey); \
	email=$$(git config --get user.email); \
	[ -n "$$key" ] && [ -n "$$email" ] || { echo "set user.email and user.signingkey in ~/.gitconfig.local" >&2; exit 1; }; \
	printf '%s %s\n' "$$email" "$$(cut -d" " -f1,2 "$${key/#\~/$$HOME}")" > "$$HOME/.ssh/allowed_signers"; \
	chmod 600 "$$HOME/.ssh/allowed_signers"; \
	echo "wrote ~/.ssh/allowed_signers for $$email"

## helptags -- regenerate vim help tags for the vendored plugins
helptags:
	vim --not-a-term -c 'silent! helptags ALL' -c 'qall!' </dev/null >/dev/null 2>&1 || true

## ale -- add the ALE linter (replaces syntastic; needs network)
ale:
	git submodule add https://github.com/dense-analysis/ale.git vendor/ale
	git submodule update --init --depth 1 -- vendor/ale
	bin/linkify

help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## /  make /'
