#!/usr/bin/make
# Note: gmake syntax
#

SHELL = /bin/bash
SUDO = /usr/bin/sudo
MKDIR = /usr/bin/mkdir
RMDIR = /usr/bin/rmdir
RM = /usr/bin/rm
CHOWN = /usr/bin/chown
USER := $(shell echo $(USER))

HUGO = /usr/bin/hugo server --disableFastRender

CURRENT_DIRECTORY := $(shell pwd)
CURRENT_SITE := $(notdir $(CURRENT_DIRECTORY))

# Ensure git is installed
GITBIN := $(shell command -v git)
ifndef GITBIN
$(error Git is not installed, do 'sudo apt install git' before proceeding)
endif


help:
	@echo
	@echo "[develop site]----------------------------------------------------"
	@echo "init ---------- creates the site Apache root directory "
	@echo "build --------- builds the site files with Hugo"
	@echo "server -------- launch Hugo server at localhost:1313"
	@echo "clean --------- removes all sites file at local Apache web server"
	@echo "[test site install]-----------------------------------------------"
	@echo "install ------- installs static files to local Apache site"
	@echo "[public deployment]-----------------------------------------------"
	@echo "deploy -------- uploads finished site to GitHub pages repository"
	@echo


# Create a new site for Apache root
init:
	@echo "Creating site $(CURRENT_SITE) in Apache root..."
	@if [ ! -d /var/www/$(CURRENT_SITE) ] ; then \
		$(SUDO) $(MKDIR) /var/www/$(CURRENT_SITE) && $(SUDO) $(CHOWN) $(USER):$(USER) /var/www/$(CURRENT_SITE) ; \
	else \
		echo "Skipping - site $(CURRENT_SITE) already exists in Apache root!" ; \
	fi

build:
	@$(HUGO)

server: build
	@$(HUGO)

clean:
	@if [ -d /var/www/$(CURRENT_SITE) ] ; then \
		$(RM) -fr /var/www/$(CURRENT_SITE)/* ; \
		sudo $(RMDIR) /var/www/$(CURRENT_SITE) ; \
		echo "Removed all previous $(CURRENT_SITE) files at target Apache root." ; \
	else \
		echo "Skipping - nothing to erase!" ; \
	fi

install: clean build init
	@cp -r public/* /var/www/$(CURRENT_SITE)
	@echo "New site copied to Apache server. The new HTML pages can be browsed at localhost:80."

deploy:
	@echo "- Use these four commands to deploy to GitHub pages site:"
	@echo "git status"
	@echo "git add ."
	@echo "git commit -m 'message'"
	@echo "git push"
	@echo "- but requires GitHub action configuration to work. See documentation"
	@echo "- at 'https://gohugo.io/hosting-and-deployment/hosting-on-github/'"

.PHONY: help init build server clean install deploy
