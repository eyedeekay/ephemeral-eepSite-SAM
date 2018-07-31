# sam-forwarder
Forward a local port to i2p over the SAM API. This is a work-in-progress, but
the basic functionality is there and it's already pretty useful.

## building

Just:

        make deps build

and it will be in the folder ./bin/

[![Build Status](https://travis-ci.org/eyedeekay/sam-forwarder.svg?branch=master)](https://travis-ci.org/eyedeekay/sam-forwarder)

## usage

        ./bin/ephsite -host=host -port=port

So, to serve an eepSite version of a local service on port 8080 -

        ./bin/ephsite -host=127.0.0.1 -port=8080

For more information, [look here](USAGE.md)

## ini-like configuration

I made it parse INI-like configuration files, optionally, which allows it to
generate tunnels from snippets of i2pd tunnel configuration files. That's kinda
useful. It appears to be more-or-less compatible with i2pd's tunnels.conf
format, but it only supports the following options:

        host = 127.0.0.1
        port = 22
        inbound.length = 6
        outbound.length = 6
        inbound.lengthVariance = 6
        outbound.lengthVariance = 6
        inbound.backupQuantity = 5
        outbound.backupQuantity = 5
        inbound.quantity = 15
        outbound.quantity = 15
        inbound.allowZeroHop = true
        outbound.allowZeroHop = true
        i2cp.encryptLeaseSet = true
        gzip = true
        i2cp.reduceOnIdle = true
        i2cp.reduceIdleTime = 3000000
        i2cp.reduceQuantity = 4
        i2cp.enableWhiteList = false
        i2cp.enableBlackList = true
        i2cp.accessList = BASE64KEYSSEPARATEDBY,COMMAS
        keys = ssh.dat

Also it doesn't support sections. Didn't realize that at first. Will address
soon.

## Quick-And-Dirty i2p-enabled golang web applications

Normal web applications can easily add the ability to serve itself over i2p by
importing and configuring this forwarding doodad. Wherever it takes the argument
for the web server's listening host and/or port, pass that same host and/or port
to a new instance of the "SAMForwarder" and then run the "Serve" function of the
SAMForwarder as a gorouting. This simply forwards the running service to the i2p
network, it doesn't do any filtering, and if your application establishes
out-of-band connections, those may escape. Also, if your application is
listening on all addresses, it will be visible from the local network.

Here's a simple example with a simple static file server:

```Diff
package main																		package main

import (																			import (
	"flag"																				"flag"
	"log"																				"log"
	"net/http"																			"net/http"
)																				    )

																			      >	import "github.com/eyedeekay/sam-forwarder"
																			      >
func main() {																			func main() {
	port := flag.String("p", "8100", "port to serve on")														port := flag.String("p", "8100", "port to serve on")
	directory := flag.String("d", ".", "the directory of static file to host")											directory := flag.String("d", ".", "the directory of static file to host")
	flag.Parse()																			flag.Parse()
																			      >
																			      >		forwarder, err := samforwarder.NewSAMForwarderFromOptions(
																			      >			samforwarder.SetHost("127.0.0.1"),
																			      >			samforwarder.SetPort(*port),
																			      >			samforwarder.SetSAMHost("127.0.0.1"),
																			      >			samforwarder.SetSAMPort("7656"),
																			      >			samforwarder.SetName("staticfiles"),
																			      >		)
																			      >		if err != nil {
																			      >			log.Fatal(err.Error())
																			      >		}
																			      >		go forwarder.Serve()

	http.Handle("/", http.FileServer(http.Dir(*directory)))														http.Handle("/", http.FileServer(http.Dir(*directory)))

	log.Printf("Serving %s on HTTP port: %s\n", *directory, *port)													log.Printf("Serving %s on HTTP port: %s\n", *directory, *port)
	log.Fatal(http.ListenAndServe("127.0.0.1:"+*port, nil))														log.Fatal(http.ListenAndServe("127.0.0.1:"+*port, nil))
}																				    }

```

[This tiny file server taken from here and used for this example](https://gist.github.com/paulmach/7271283)

Current limitations:
====================

Datagrams are still a work-in-progress. They're enabled, but I don't know for
sure how well they'll work yet. TCP is pretty good though.

I've only enabled the use of a subset of the i2cp and tunnel configuration
options, the ones I use the most and for no other real reason assume other
people use the most. They're pretty easy to add, it's just boring. *If you*
*want an i2cp or tunnel option that isn't available, bring it to my attention*
*please.* I'm pretty responsive when people actually contact me, it'll probably
be added within 24 hours.

I should probably have some options that are available in other general network
utilities like netcat and socat(ephsite may have it's name changed to samcat at
that point). Configuring timeouts and the like. In order to do this, some of the
existing flags should also be aliased to be more familiar and netcat-like.

I want it to be able to use poorly formed ini files, in order to accomodate the
use of INI-like labels. For now, my workaround is to comment out the labels
until I deal with this.
