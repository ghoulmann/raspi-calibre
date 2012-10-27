---"Raspliance Core"---

Raspliance Core is a remix of Raspian/Raspbian that intends to make the most of Raspberry Pi's potentials as a server platform.

It's as much a remix of Raspian/Raspbian as it is of TurnKey Linux Core 12.0, which it's modeled after.

The devs at Turnkey Linux have made an art of the dedicated appliance platform; I've tried to follow their lead while relying heavily on their code and wise decisions.

---Calibre---

Doesn't work yet: problem with /etc/init.d/calibre!

Ebook management, reader, maker, server. This patch installs calibre to /opt/calibre, and configures it to startup on boot with daemon in /etc/init.d. The server will look for a calibre library in /var/calibre-data. Calibre is configured to listen on port 80; no username or password is configured by default.

This is built with the expectation that a calibre library and database will be managed in another machine, and that the library will be synced with rsync or another tool.

In addition to Calibre on port 80: shellinabox (:12320), webmin (:12321). Also, TKL inithook mechanism configures root password on first boot. Confconsole displays your IP and directory of services.

---Use---
Run compile_tklpatch.sh in order to make the tool to apply this patch to raspian. or raspbian.

Use this command to apply the patch (assuming your in the directory with the git clone):
tklpatch-apply / ./raspi-calibre/
This applies the root directory to your running instance of raspian. Don't quit reading here.

---Contents---
compile_tklpatch.sh compiles tklpatch, the SDK developed by TurnKey Linux and which has really created a community of appliance builders and contributors.
1. Install dependencies for compile
2. Use git to clone source code to /tmp/tklpatch
3. change directory to /tmp/tklpatch
4. go to the users home directory

---core/---
1. Includes an overlay that injects webmin - and relevant modules - and a theme - into the file system. These components are lifted directly out of a running instance of Turnkey Linux Core 12.0 (squeeze).
2. Includes an overlay that inject .bashrc etc files into /root and /etc/skel.
3. Inject the modified services.txt file for confconsole into /etc/confconsole.
2. Purges Raspian/Raspbian packages that could obviously be purged.
3. Uses apt-get to install packages. The list of packages is intended to match those in the Turnkey Linux Core 12.0 manifest (with the exception of webmin and modules).

---Assumptions---
1. You have created a password for root: if you're logged in to another account, do sudo passwd root.
2. You have logged off any users that were logged in.
3. You have logged in as root.
4. You have installed git by doing apt-get install git.
5. You're starting from a fresh .img of Raspian.
6. You have resized your partition: 2 gig doesn't do it.

---Known Problems---
1. Can't log in to shellinabox as root. Don't know why.
2. 3 or 4 python modules that belong with confconsole are in /usr/bin. There's an appropriate place for them, I just couldn't get confconsole to work with them anywhere else but /usr/bin.
