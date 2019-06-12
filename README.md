# sam-forwarder

Forward a local port to i2p over the SAM API, or proxy a destination to a port
on the local host. This is a work-in-progress, but the basic functionality is,
there and it's already pretty useful. Everything TCP works, but UDP forwarding
has much less real use than TCP. Turns out UDP was less broken than I thought
though.

Since it seems to be doing UDP now, if you'd like to donate to further
development there are some wallet addresses at the bottom of this readme for
now.

## getting

        go get -u github.com/eyedeekay/sam-forwarder/samcatd

## building

Just:

        make deps build

and it will be in the folder ./bin/

[![Build Status](https://travis-ci.org/eyedeekay/sam-forwarder.svg?branch=master)](https://travis-ci.org/eyedeekay/sam-forwarder)

## Usage:

There are a number of ways to use sam-forwarder:

### [usage/configuration](docs/USAGE.md) as an application(Start here for samcatd)

### [embedding](docs/EMBEDDING.md) in other applications

### [encapsulate](docs/PACKAGECONF.md) configuration for i2p-enabled packages

### [implement](interface/README.md) the interface for fine-grained control over SAM connections

## binaries

Two binaries are produced by this repo. The first, ephsite, is only capable
of running one tunnel at a time and doesn't have VPN support. I'm only updating
it to make sure that the embeddable interface in existing applications doesn't
change. It will go away and be replaced with a wrapper to translate it to
'samcatd -s' commands whenever I complete [docs/CHECKLIST.md](docs/CHECKLIST.md).

The second, samcatd, is more advanced. It can start multiple tunnels with their
own settings, or be used to start tunnels on the fly like ephsite by passing the
-s option. Eventually I'm probably just going to use this to configure all of my
tunnels.

Current limitations:
====================

I need to document it better.
[Besides fixing up the comments, this should help for now.](docs/USAGE.md). I
also need to control output verbosity better.

I need samcatd to accept a configuration folder identical to
/etc/i2pd/tunnels.conf.d, since part of the point of this is to be compatible
with i2pd's tunnels configuration. Once this is done, I'll resume turning it
into a .deb package.

It doesn't encrypt the .i2pkeys file by default, so if someone can steal them,
then they can use them to construct tunnels to impersonate you. Experimental
support for encrypted saves has been added. The idea is that only the person
with the key will be able to decrypt and start the tunnels. It is up to the user
to determine how to go about managing these keys. Right now this system is
pretty bad. I'll be addressing that soon too.

TCP and UDP are both working now. but UDP requires the service to already be
configured to work. Changes to address this shortcoming are pending.

Experimental support for KCP-based error correction and streaming-over-datagrams
is in the works. Some kind of reverse-proxy or filter is also an obvious choice.

I've only enabled the use of a subset of the i2cp and tunnel configuration
options, the ones I use the most and for no other real reason assume other
people use the most. They're pretty easy to add, it's just boring. *If you*
*want an i2cp or tunnel option that isn't available, bring it to my attention*
*please.* I'm pretty responsive when people actually contact me, it'll probably
be added within 24 hours. I intend to have configuration options for all
relevant i2cp and tunnel options, which I'm keeping track of
[here](config/CHECKLIST.md).

I need to just change how the configuration is done entirely. I want it to work
with the configuration formats used by each I2P router.

TLS configuration is experimental.

## Stuff that's using it:

Mostly mine, but this is all Free-as-in-Freedom for anyone to use:

  * [eephttpd](https://github.com/eyedeekay/eephttpd)
  * [my fork of wikigopher](https://github.com/eyedeekay/wikigopher)
  * [orangeforum](https://github.com/s-gv/orangeforum)

Donate
------

### Monero Wallet Address

  XMR:43V6cTZrUfAb9JD6Dmn3vjdT9XxLbiE27D1kaoehb359ACaHs8191mR4RsJH7hGjRTiAoSwFQAVdsCBToXXPAqTMDdP2bZB

### Bitcoin Wallet Address

  BTC:159M8MEUwhTzE9RXmcZxtigKaEjgfwRbHt

Index
-----

 * [readme](index.html)
 * [usage](usage.html)
 * [configuration](packageconf.html)
 * [embedding](embedding.html)
 * [interface](interface.htnl)
