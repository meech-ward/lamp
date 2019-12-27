# meech-ward/lamp

A lamp stack vagrant box using docker containers.

## Stack

* Ubuntu 18.04
* Apache 2.4
* PHP 7.4
* Mysql 8.0
* Node 12.14

## Vagrant

To use this box, you must first have vagrant up and running. Download the example directory and run `vagrant up`. Then, visit 192.168.55.10/test.php from your web browser.

## Packer

To build the box with packer, run the following command:

```
cd packer/
packer build main.json
```