Vagrant-Metasploit
==================
Vagrant Box that will deploy Ubuntu 14.04 Server with bleeding edge Nmap and Metasploit Framework all from latest sources what could be better? The CPU/Memory resources are set dynamically by default to utilize half the available cores and ram but feel free to tweak as needed. Also this build supports Virtualbox, VMware Fusion + Parallels. If you want additional stuff on top like Veil-Evasion of it see the extras section. The whole build takes few minutes so go grab coffee after this thing starts.

Don't want to use Vagrant? That’s cool, run this shell script on any fresh Ubuntu box and you're ready to rock. 

for the particularly brave
```shell
curl https://raw.githubusercontent.com/maus-/vagrant-metasploit/master/scripts/buildmsf.sh | sh
```

##Extras* 
Everyone loves extras. For additional tools that take forever to build like Veil-Evasion pass the argument 'extras' into the script via the Vagrantfile or the crazy 'lets pipe curl to sh method' and you will have it all. Be forewarned it'll take about an hour or so extra to build it on this VagrantBox with all the extra package dependencies. (Working on that). Expect to see some more tools being dropped in here soon enough too.

##Contributors

Maus Stearns

Michael Carlson (Prandium)

Alex Levinson