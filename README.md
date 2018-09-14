# sam-forwarder
Forward a local port to i2p over the SAM API, or proxy a destination to a port
on the local host. This is a work-in-progress, but the basic functionality is,
there and it's already pretty useful. Everything TCP works, but UDP forwarding
is still not well tested, and UDP clients aren't enabled yet. I'm out of excuses
not to finish it now, too.

## building
Just:

        make deps build

and it will be in the folder ./bin/

[![Build Status](https://travis-ci.org/eyedeekay/sam-forwarder.svg?branch=master)](https://travis-ci.org/eyedeekay/sam-forwarder)

## [usage/configuration](USAGE.md)

## binaries

Two binaries are produced by this repo. The first, ephsite, is only capable
of running one tunnel at a time. The second, samcatd, is more advanced. It can
start multiple tunnels with their own settings, or be used to start tunnels on
the fly like ephsite by passing the -s option. Eventually I'm probably just
going to use this to configure all of my tunnels.

Current limitations:
====================

I need to document it better.
[Besides fixing up the comments, this should help for now.](USAGE.md). I also
need to control output verbosity better.

TCP is working very well. HTTP mode also exists, which just adds the X-I2P-DEST
headers in. It does this both ways, for applying the dest headers inbound to
identify clients to the server and outbound to identify servers to clients.
DestHash's don't get added correctly due to a bug in sam3 I think? I'm working
on making sure that's what it is. Datagrams are still a work-in-progress.
They're enabled, but I don't know for sure how well they'll work yet.

I'm in the process of adding client proxying to a specific i2p destination by
base32 or (pre-added)jump address. TCP works well. UDP exists, but is not
thoroughly tested.

I've only enabled the use of a subset of the i2cp and tunnel configuration
options, the ones I use the most and for no other real reason assume other
people use the most. They're pretty easy to add, it's just boring. *If you*
*want an i2cp or tunnel option that isn't available, bring it to my attention*
*please.* I'm pretty responsive when people actually contact me, it'll probably
be added within 24 hours. I intend to have configuration options for all
relevant i2cp and tunnel options, which I'm keeping track of
[here](config/CHECKLIST.md). In particular, *Encrypted leasesets are only*
*half-implemented. The option seems to do nothing at the moment. Soon it will*
*be configurable.*

I should probably have some options that are available in other general network
utilities. I've started to do this with samcatd.

I want it to be able to save ini files based on the settings used for a running
forwarder. Should be easy, I just need to decide how I want to do it. Also to
focus a bit more.

Example tools built using this are being broken off into their own repos. Use
the other repos where appropriate, so I can leave the examples un-messed with.

It would be really awesome if I could make this run on Android. So I'll make
that happen eventually. I started a daemon for managing multiple tunnels and I
figure I give it a web interface to configure stuff with. I'll probably put that
in a different repo though. This is looking a little cluttered.

TLS configuration is experimental.

I'm eventually going to make the manager implement net.Conn. This won't be
exposed in the default application probably though, but rather as a library.
