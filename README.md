# Continuous Cooking

Chef recipes for continuous integration, code review, and overall code management.
The goal is to have recipes for Gitosis, Hudson, Gerrit, and perhaps more.
This is a work in progress and so far only Hudson is done.

## Hacking

I'm using Vagrant to help develop the cookbooks. See the [Vagrant](http://vagrantup.com)
site/docs for more info on how Vagrant works.

To use vagrant you will need to have installed [VirtualBox](http://www.virtualbox.org/wiki/Downloads) *and ran it once*.  After that
these commands should get you up and running:

    gem install vagrant
    vagrant box add lucid64 http://s3.lds.li/vagrant/lucid64.box
    vagrant up

This will take a while the first time since it is downloading all the needed packages. If this runs
successfully you should be able to hit Hudson at http://localhost:4088.  You can also ssh into the box
with `vagrant ssh`.  Again, refer to Vagrant's docs for more info.

To rerun chef you can either type `vagrant reload` on the host machine or go to `/tmp/vagrant_chef` on
the VM and type `sudo chef-solo -c solo.rb -j dna.json`. I like running chef-solo on the VM since the
reload command actually takes the VM down, brings it up, and remounts everything.

# Troubleshooting

If vagrant throws an error on `#to_json` then try downgrading the json gems:

    gem install json --version 1.2.4
    gem install json_pure --version 1.2.4
    gem uninstall json # uninstall the more recent versions
    gem uninstall json_pure # uninstall the more recent versions


