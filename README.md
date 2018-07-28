# sam-forwarder
Forward a local port to i2p over the SAM API.

## building

Just:

        make deps build

and it will be in the folder ./bin/

## usage

        ./bin/ephsite -host=host -port=port

So, to serve an eepSite version of a local service on port 8080 -

        ./bin/ephsite -host=127.0.0.1 -port=8080

For more information, [look here](USAGE.md)

## ini-like configuration

I make it parse INI-like configuration files, optionally, which allows it to
generate tunnels from snippets of i2pd tunnel configuration files. That's kinda
useful. It appears to be more-or-less compatible with i2pd's tunnels.conf
format, but it only supports the following options:

        [EXAMPLE-CONFIG]
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
