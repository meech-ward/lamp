# meech-ward/lamp

A lamp stack vagrant box using docker containers.

## Stack

* Ubuntu 18.04
* Apache 2.4
* PHP 7.4
* Mysql 8.0
* Node 12.14

## Packer

To build the box with packer, run the following command:

```
cd packer/
packer build main.json
```