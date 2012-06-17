Description
===========

Installs and configures the Distributed Replicated Block Device (DRBD) service
for mirroring block devices between pairs of hosts.

Platform
--------

Tested on Debian 6.03 with DRBD 8.3.

Recipes
=======

default
-------

Installs `drbd` and, if there is `node[:drbd]`, creates
`/etc/drbd.d/global_common.conf` with specified (or default) options.

pair
----

Can configure a number of pairs of resources across number of hosts. Configures
each resource:

* writes `/etc/drbd.d/<resource>.res`
* sets up primary:

        drbdadm -- --force create-md res
        drbdadm up res
        drbdadm -- --overwrite-data-of-peer primary res

* sets up secondary:

        drbdadm create-md res
        drbdadm attach res
        drbdadm -- --discard-my-data connect pair

For more details how it is done and what checks are peformed, consult
`providers/pair.rb`.

Attributes
==========

Attributes for global configuration are:

* `node[:drbd][:usage_count]`. `yes` or `no` or `ask`. Default `no`.
* `node[:drbd][:protocol]`. Synchronization protocol to use. Default is `C`. For
  more information, see the docs for [DRBD Replication
  Modes](http://www.drbd.org/users-guide-emb/s-replication-protocols.html).
* `node[:drbd][:sync_rate]`. Default `40M`.

Every resource should be in `node[:drbd][:resource]`. Take `pair` as an
example. Then the following are written:

* `node[:drbd][:resources][:pair][:disk]` - required. Disk for replication.
* `node[:drbd][:resources][:pair][:remote_host]` - FQDN of pair.
* `node[:drbd][:resources][:pair][:device]` - default `/dev/drbd0`.
* `node[:drbd][:resources][:pair][:master]` - default `false`. Controls which
   node initializes the DRBD device.

* `node[:drbd][:resources][:pair][:local_ip]` - default is node.ipaddress. Set
   this if node has another IP.
* `node[:drbd][:resources][:pair][:local_port]` - default is 7789.
* `node[:drbd][:resources][:pair][:remote_ip]` - default is remote.ipaddress.
* `node[:drbd][:resources][:pair][:remote_port]` - default is 7789.

TODO
====

* Make dynamic sync_rate default.
* Improve checks in destructive DRBD commands
