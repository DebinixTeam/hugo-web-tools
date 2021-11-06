# Install Hugo theme example, and use a Makefile for workflow automation

The purpose of my `Makefile` is to have useful terminal commands readily available during development
and to test a new Hugo website. Place the included `Makefile` in the root of your new site, 
e.g.,`/srv/www/example.com`. Run `make help` to see available make commands.

The `Makefile` has commands to install, update, and remove the site to a locally installed Apache server 
to ensure that the new site will behave appropriately on a widespread web server platform. 
Apache will run the site under `/var/www/example.com`. Browse to it with `localhost`.

The makefile currently supports following commands:

        build --------- builds the site files with Hugo
        server -------- launch Hugo server at localhost:1313

        init ---------- creates the site Apache root directory
        install ------- installs static files to local Apache site
        clean --------- removes all sites file at local Apache web server

        deploy -------- uploads finished site to GitHub pages repository

For quick access, I wrote this document if I needed them later. Maybe someone else will find the notes helpful as well.

- [See also Hugo's excellent documentaion](https://gohugo.io/documentation/)


## Hugo installation (Linux - Debian, Ubuntu or derivatives)

Update and install hugo, apache and git with:

        sudo apt update
        sudo apt upgrade
        sudo apt install hugo git apache2

Check installed version:

        apt-cache policy hugo
                hugo:
                  Installed: 0.89.0-1
                  Candidate: 0.89.0-1
                  Version table:
                 *** 0.89.0-1 500
                        500 http://httpredir.debian.org/debian sid/main amd64 Packages
                        100 /var/lib/dpkg/status
                     0.80.0-6+b5 500
                        500 http://deb.debian.org/debian stable/main amd64 Packages

## Setting up the directory structure for domain 'example.com'

I prefer to have my Hugo development site under /srv and not in my user home tree. 
So now, create the directories and change `root` access to $USER.

        sudo mkdir -p /srv/www
        sudo chown -R $USER:$USER /srv

## Adding a Hugo theme (here 'Shadocs')

Select one of all [Hugo's themes](https://themes.gohugo.io), and then `git clone` the theme to the `example.com`:

        # Create the new site 'example.com'
        cd /srv/www
        hugo new site example.com

Clone the theme to the themes directory.

        cd example.com
        git clone https://github.com/jgazeau/shadocs.git themes/shadocs

## Copy the example site contents

Copy the entire contents of the `themes/shadocs/exampleSite` folder to the root folder of your Hugo site, i.e., `example.com.` 
To copy the files using terminal, make sure you are at the root of the project, i.e., the `example.com` folder with:

        cd example.com
        cp -a themes/shadocs/exampleSite/. .

## Update site configuration file

Update the `baseURL`, `themesDir`, and `theme` values in `example.com/config.toml` in the root folder of your Hugo site.

        baseURL = "/"
        themesDir = "themes"
        theme = "shadocs"


## Exclude all generated content with `.gitignore` file

Create the gitignore file and add:

        # Exclude vscode files
        .vscode
        # Exclude Hugo generated files
        public/
        resources/_gen/*
        # Exclude the themes and subdirectories
        themes/*
        # Exclude lock file, new in hugo v0.89
        .hugo_build.lock

## Create the git repository

Initialize the site git repository and add site contents.

        git init
        git add .  
        git com -m 'initial commit'

Add the theme directory as a submodule, but with -f (i.e. --force), and update the dependent git repositories

        git submodule add -f https://github.com/jgazeau/shadocs.git themes/shadocs
                Adding existing repo at 'themes/shadocs' to the index

        git submodule update --init --recursive
                Submodule 'assets/bulma' (https://github.com/jgthms/bulma.git) registered for path 'themes/shadocs/assets/bulma'
                Cloning into '/srv/www/example.com/themes/shadocs/assets/bulma'...
                Submodule path 'themes/shadocs/assets/bulma': checked out '4508573d932670ff922280a2f6fbf2a3851c20b1'

Finally, add the new files to git.

        git add .
        git com -m 'second commit'

## Generate site content

After this, generate the Hugo site.

        cd /srv/www/example.com
        hugo
                Start building sites … 
                hugo v0.88.1+extended linux/amd64 BuildDate=2021-10-31T23:44:00Z VendorInfo=debian:0.88.1-1

                                | EN | FR  
                -------------------+----+-----
                Pages            | 86 | 86  
                Paginator pages  |  0 |  0  
                Non-page files   |  0 |  0  
                Static files     | 72 | 72  
                Processed images |  0 |  0  
                Aliases          |  1 |  0  
                Sitemaps         |  2 |  1  
                Cleaned          |  0 |  0  

                Total in 1834 ms


Then, start the server and open a browser at `localhost:1313`.

        hugo server

# Site development with a Makefile

These are just simple shortcuts for useful terminal commands and to simplify workflow during site development.
Just copy the `Makefile` to the root of your site and use the `make help` to see all available options.

