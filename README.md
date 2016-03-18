Farstrider
----------

This app uses a Mac OS X daemon to share a laptop's location with a remote backend.

It's a proof of concept to demonstrate an understanding of the underlying technology, and to explore some architectural designs for application structure.

Farstrider Client
=================

The main process is a launch service daemon that tries to sense times to check for a new location, and is responsible for marshalling logging and reporting. Logging and reporting are their own separate XPC services for robustness.

The main process is responsible for sensing cues that the device location may have changed, and notifying the logging and reporting services. It should use several sub-modules, each responsible for monitoring one particular aspect of the environment for indications that the laptop might have moved:

* Power events
* Accelerometer data
* Network changes

### Logging ###

This module is responsible for recording changes to the device location. It is fed a stream of sensor events and filters these down to discrete location events. Those events get persisted by Core Data to continue monitoring while a device is offline.

This module owns the Core Data stack, so it also will be responsible for fetching and deleting events as they are spooled to the backend.

### Reporting ###

This module is responsible for communicating location events to the backend. It watches network availability, and tries to regularly pop records out of the logging module and send them to the server.

Farstrider Server
=================

A bare bones Node.js server to receive logging events from the client, store them in a DB, and display them on a simple web page.