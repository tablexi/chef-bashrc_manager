# bashrc_manager cookbook

[![Circle CI](https://circleci.com/gh/tablexi/chef-bashrc_manager.svg?style=svg)](https://circleci.com/gh/tablexi/chef-bashrc_manager)

This cookbook provides a simple `bashrc_manager` LWRP.

It create multiple files in bashrc.d folder and merge them into bashrc file without loosing any local existing version.

This cookbook was heavily influenced by the [bash cookbook](https://github.com/guilhem-cookbooks/bash).

## Usage
Just add `bashrc_manager` to your cookbook dependency list.

## Requirement

* Chef 12.5
* Linux Distro (Tested on CentOS, Debian, Amazon, & Ubuntu)

## Resource / Provider
* `bashrc_manager` : does the init/setup/parse/merge process. This LWRP will create bashrc.d folder if not present.

If an existing bashrc file exists in user home folder, it will be saved in a permanent init file at the very first run and then will be merged each time LWRP is called.

### Action
* `add:` (default) - add a specified file to bashrc.d folder and merge all files from this folder to given user bashrc file.
* `remove:` - remove a specified file from bashrc.d folder.

## Attributes

* `filename` - name of the file

* `user` - user to interact with. Group and home folder will be automaticly resolved from system informations.

* `content` - String to be set on the new profile file. It easily works with simple string, multiline string, or strings loaded from a file.

#### Syntax

    bashrc_manager 'profile.addin' do
      user 'jdoe'
      content "PATH=/home/jdoe/my_bin:$PATH"
    end

## Testing

Includes basic [chefspec](sethvargo/chefspec) support and matchers.

1. `bundle install`
2. `rspec`

## Author

Author:: Table XI (<sysadmins@tablexi.com>)
