# Continuous Cooking

Chef recipes for continuous integration, code review, and overall code management.
The goal is to have recipes for [Gitosis][gitosis], [Hudson][hudson], [Gerrit][gerrit], and perhaps more.

I only aim to support ubuntu and nginx, but adding apache or other platforms should be easy if you have the need.

## Whats Done
* Hudson

  * Ability to declare what plugins to install

    * Common base ones are installed by default (i.e git) and are configurable via an attribute.

  * nginx recipe for proxying
  * Ruby recipe to add RVM support to hudson user
    * Flexible RVM cookbook to declare needed ruby versions and base gems (i.e bundler).
    * Installs common ruby plugins.
 * Gitosis (see below on how to use)

## TODO
 * Gerrit
 * Cloud bootstrapping script
 * Documentation
 * Create/publish base vagrant image?

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

Note: Prefixing all your `vagrant` commands with `bundle exec ` gets old fast so a `./vagrant` wrapper script is provided.

This will take a while the first time since it is downloading all the needed packages. If this runs
successfully you should be able to hit the various services:

 * **Hudson** - http://localhost:4088 (see Troubleshooting section if it doesn't appear to be running)
 * **Hudson via nginx** - http://hudson.codebox:4080
 * **ssh** - via `./vagrant ssh`

For the services proxied via nginx you will need to add the appropriate entries to your `hosts` file.
One easy way to do this is with the ghost gem:

    gem install ghost
    sudo ghost add hudson.codebox

To rerun chef you can either type `./vagrant reload` or `./vagrant provision`.  The `provision` command is much faster and is preferred.  The `reload` command will restart the VM, remount the FS, and setup the port forwarding.

### Gitosis

To experiment with gitosis you will need to have vagrant write to your ssh config:

    ./vagrant ssh-config >> ~/.ssh/config

Now you will be able to clone the gitosis repo:

    git clone gitosis@vagrant:gitosis-admin.git

Once that is done you can modify the `gitosis.conf` as you normally would to manage repositories.

### Troubleshooting

 * **Hudson isn't running after `./vagrant up`** - When bootstrapping for the first time Hudson sometimes fails to restart after installing the plugins (something about being restarted too soon I think).  If this happens you simply need to restart the service by `ssh`ing in and typing `/etc/init.d/hudson restart`.

[gitosis]: http://www.ohloh.net/p/gitosis "Gitosis - git management"
[hudson]: http://hudson-ci.org/ "Hudson - CI Server"
[gerrit]: http://code.google.com/p/gerrit/ "Gerrit - Git-based code-review tool"
[rvm]: http://rvm.beginrescueend.com/ "Ruby Version Manager"
