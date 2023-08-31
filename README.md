## What is this?

This repository contains everything you need to set up a **decent** Tibia 7.7 server. Keyword here is **decent**. What you see here can likely be improved in many ways (feel free to do so!), so make sure that you know what you are doing and read through the code carefully. Most of the stuff contained here is based on the following tutorials:

* [https://otland.net/threads/tutorial-running-cipsoft-server-files.244579/](https://otland.net/threads/tutorial-running-cipsoft-server-files.244579/)
* [https://otland.net/threads/tutorial-for-running-7-7-cipsoft-server-on-ubuntu.274678/](https://otland.net/threads/tutorial-for-running-7-7-cipsoft-server-on-ubuntu.274678/)
* [https://otland.net/threads/script-and-tutorial-to-automate-install-of-leaked-7-70-server.284492/](https://otland.net/threads/script-and-tutorial-to-automate-install-of-leaked-7-70-server.284492/)
* [https://otland.net/threads/tutorial-how-to-run-a-fresh-7-7-cipsoft-server.284993/#post-2731906](https://otland.net/threads/tutorial-how-to-run-a-fresh-7-7-cipsoft-server.284993/#post-2731906)

## Quickstart

**If** you know what you're doing, then just run:

```bash
git clone https://github.com/minhkey/tibia-770-setup.git && bash tibia-770-setup/install.sh
```

It is, however, **highly** suggested that you keep on reading before doing that.

## Detailed information 

### Getting a VPS up and running

First of all you need a VPS or a self-hosted server. I like [Hetzner](https://www.hetzner.com/cloud), but feel free to use whatever you want. The only requirements are that you install [Ubuntu 20.04](https://releases.ubuntu.com/focal/) and that you get a static IP address. You *can* get around the static IP requirement e.g. by using a dynamic DNS, but that is not covered here.

After you get your server up and running, make sure to create a new user (with sudo rights), add an SSH key, activate the `ufw` firewall with some sane defaults, and finally deactivate root login and password authentication. Hetzner has a good tutorial [here](https://community.hetzner.com/tutorials/howto-initial-setup-ubuntu). 

### The install script

After a fresh OS install, running the main install script, `install.sh`, should take care of everything. It does the following:

#### Check OS compatability

If you're not using Ubuntu 20.04 it will abort.

#### Create MySQL credentials and set necessary environment variables

A username, password, and database name (the latter is the same as username), containing a mix of numbers and upper and lowercase letters, is generated from `/dev/urandom` and appended to `~/.bashrc`. You'll never need to actually write them, and **they are not stored anywhere else**! The user/database name is 25 characters long and the password is 50 characters long, which [should be enough](https://i.redd.it/5g3ayy7pwxl51.jpg).

Several environment variables are set, including the server/world name (default "Atlantis"), MOTD, game path (default `/home/game`), correct port, your public IP, and number of CPU cores. Some additional directories are also created (`pids`, `logs`, `backup`).

#### Install dependencies and utilities

I like a modular approach, so the actual install scripts are separated. I find it usually makes for easier troubleshooting. There are six in total, and the first one, `install/01_dependencies.sh`, well, installs necessary dependencies. Note that some additional software is required to support legacy i386 software, so that you'll be able to use the `/home/game/bin/.gsc` command. Some other nice-to-haves are also installed, like `ranger`, `fail2ban` and `htop`.

Finally, one of my admin scripts requires R. I know, I know, this is a "heavy" dependency, but R is my main language. Feel free to rewrite the relevant script in Python or Bash, and we can get rid of this requirement.

#### Prepare game files

Next up is `install/02_game.sh`. The game files come shipped with this repository, located in `resources/tibia-game.tar.gz`. Some additional libraries that you'll need are located in `resources/dennis-libraries.tar.gz`. This script will extract everything to where it needs to be and replace some stuff with correct settings (e.g. your chosen server/world name and public IP).

#### Apache 

We also need an Apache webserver running. It's aready installed, so `install/03_apache.sh` will just allow the necessary ports in `ufw` and copy some stricter config files to tighten up security a bit.

#### MySQL

In `install/04_mysql`, a new user is created with the username and password that was generated earlier. A schema is loaded (`resources/otserv-schema.tar.gz`) and the correct IP is set. Then the database is cleaned up, and the `mysql_secure_installation` command is run. **This requires manual input**! Just answer `Y` to everything.

#### Prepare the query manager 

I've made a custom fork of [https://github.com/Olddies710/realots-query-manager](https://github.com/Olddies710/realots-query-manager) that allows passwords to be hashed using [SHA-512](http://www.zedwood.com/article/cpp-sha512-function) and MySQL credentials to be read directly from environment variables. No more hardcoding that stuff! In `install/05_query.sh`, my fork is cloned and the correct server/world name and IP is set.

#### Prepare the login server

Again, I've made a custom fork of [https://github.com/HeavenIsLost/realotsloginserver](https://github.com/HeavenIsLost/realotsloginserver) that allows SHA-512 hashing and reading MySQL credentials from environment variables (and some other minor fixes). As above, `install/06_login.sh` will clone my fork and set the correct server/world name and IP.

#### Configure fail2ban

`fail2ban` should already be installed by now, but you need to configure it to work properly. An additional filter for SQL injection protection is downloaded, and my copy of `config/jail.local` is moved to the right place. 

### That's it!

Well, almost. With some luck, you should have breezed through the install script without any errors. If so, you can start everything (in the correct order!) by running `bash admin/start_services.sh`. 

The process IDs are placed in the `pids` directory, should you want to kill them, **but there is no need to unless you want to change things**. The game will reboot itself (i.e. to a server save) every morning at 06:00.  
