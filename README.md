# Continuous Cooking

Chef recipes for continuous integration, code review, and overall code management.
The goal is to have recipes for Gitosis, Hudson, Gerrit, and perhaps more.
This is a work in progress...

I only aim to support ubuntu and nginx, but adding apache or other platforms should
be easy if you have the need.

## Hacking

I'm using Vagrant to help develop the cookbooks. See the [Vagrant](http://vagrantup.com)
site/docs for more info on how Vagrant works.

To use vagrant you will need to have installed [VirtualBox](http://www.virtualbox.org/wiki/Downloads) *and ran it once*.  After that
these commands should get you up and running:

    gem install bundler
    bundle install
    git submodule update --init
    bundle install
    bundle exec vagrant box add lucid64 http://s3.lds.li/vagrant/lucid64.box
    bundle exec vagrant up

This will take a while the first time since it is downloading all the needed packages. If this runs
successfully you should be able to hit the various services:

 * **Hudson** - http://localhost:4088
 * **Hudson via nginx** - http://hudson.codebox:4080
 * **ssh** - via `bundle exec vagrant ssh`

For the services proxied via nginx you will need to add the appropriate entries to your `hosts` file.
One easy way to do this is with the ghost gem:

    gem install ghost
    sudo ghost add hudson.codebox

To rerun chef you can either type `bundle exec vagrant reload` or `bundle exec vagrant provision`.  The `provision` command is much faster and is preferred.  The `reload` command will restart the VM, remount the FS, and setup the port forwarding.

## TODO
 * Gerrit
