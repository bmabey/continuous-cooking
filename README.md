# Continuous Cooking

Chef cookbooks for continuous integration, code review, and overall code management.  The following cookbooks are provided: [Gitosis][gitosis], [Hudson][hudson], [Gerrit][gerrit].

I only aim to support ubuntu and nginx, but adding Apache or other platforms should be easy if you have the need.

## Why?

I've set up many CI servers in my day.  It is usually the first thing I do at a new job if I find out they don't have one running already.  Setting up a CI *program* is an easy task.  Hudson (my favorite open source CI server)  is especially dead simple to set up and doesn't take more than a minute.  However, I tend to always get bogged down with other environmental issues.  Such as needing to run multiple versions of Ruby (via [rvm][rvm]), or remembering to install other dependencies. Additionaly, if you need to fire up additional Hudson slaves in the cloud then having the process automated is a must.  The goal of this project is to automate this to a point where anyone can start up a base install and have a decent CI program and environment up and running within minutes.

## Whats Done

* Hudson

  * Ability to declare what plugins to install

    * Common base ones are installed by default (i.e git) and are configurable via an attribute.

  * nginx recipe for proxying
  * Ruby recipe to add RVM support to hudson user
    * Flexible RVM cookbook to declare needed ruby versions and base gems (i.e bundler).
    * Installs common ruby plugins.
 * Gitosis (see below on how to use)
 * Gerrit - right now it is set to proxy behind nginx, but it would not be hard to change.

## TODO
 * Cloud bootstrapping script
 * Documentation
 * Create/publish base vagrant image?

   * Maybe have a base image with dummy Hudson/Gerrit projects setup to give idea of workflow?

## Hacking and Experimenting With Setups

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

 (see Troubleshooting section if any of these doesn't appear to be running)

 * **Hudson** - <http://localhost:4088>
 * **Hudson via nginx** - <http://hudson.codebox:4080>
 * **Gerrit** - <http://localhost:4070>
 * **Gerrit via nginx** - <http://gerrit.codebox:4080>
 * **ssh** - via `./vagrant ssh`

For the services proxied via nginx you will need to add the appropriate entries to your `hosts` file.
One easy way to do this is with the ghost gem:

    gem install ghost
    sudo ghost add hudson.codebox
    sudo ghost add gerrit.codebox

To rerun chef you can either type `./vagrant reload` or `./vagrant provision`.  The `provision` command is much faster and is preferred.  The `reload` command will restart the VM, remount the FS, and setup the port forwarding.

### Gitosis

To experiment with gitosis you will need to have vagrant write to your ssh config:

    ./vagrant ssh-config >> ~/.ssh/config

Now you will be able to clone the gitosis repo:

    git clone gitosis@vagrant:gitosis-admin.git

Once that is done you can modify the `gitosis.conf` as you normally would to manage repositories.

### Gerrit

To learn more about Gerrit see the [docs](http://gerrit.googlecode.com/svn/documentation/2.1.2/index.html).  This [wiki page](http://en.wikibooks.org/wiki/Git/Gerrit_Code_Review#Importing_project_into_Gerrit) provides a nice summary as well.

Please note that using both Gerrit and Gitosis at the same time doesn't really make sense.  Gerrit provides much finer-grain permission control that gitosis does.  They are both setup on the vagrant box just to provide a playground for both.  When you use the cookbooks on your own server you should choose one or the other.

### Troubleshooting

 * **Hudson isn't running after `./vagrant up`** - When bootstrapping for the first time Hudson sometimes fails to restart after installing the plugins (something about being restarted too soon I think).  If this happens you simply need to restart the service by `ssh`ing in and typing `sudo /etc/init.d/hudson restart`.

 * **Gerrit isn't running after `./vagrant up`** - Again, try running the service manually: `sudo /etc/init.d/gerrit restart`.

[gitosis]: http://www.ohloh.net/p/gitosis "Gitosis - git management"
[hudson]: http://hudson-ci.org/ "Hudson - CI Server"
[gerrit]: http://code.google.com/p/gerrit/ "Gerrit - Git-based code-review tool"
[rvm]: http://rvm.beginrescueend.com/ "Ruby Version Manager"
