Farstrider
----------

This app uses a Mac OS X background service to share a laptop's location with a remote backend.

It's a proof of concept to demonstrate an understanding of the underlying technology, and to explore some architectural designs for application structure.

Farstrider Agent
=================

The main process is a launch service agent that tries to sense times to check for a new location, and is responsible for marshalling logging and reporting. Logging and reporting are their own separate XPC services for robustness.

The process itself only contains the main runloop. It links to a framework, Farstrider Tracker, which is responsible for sensing cues that the device location may have changed, and notifying the logging and reporting services. It should use several sub-modules, each responsible for monitoring one particular aspect of the environment for indications that the laptop might have moved:

* Power wake events (currently)
* Accelerometer data (eventually)
* Network changes (eventually)

### Logging (eventually) ###

This module will be responsible for recording changes to the device location. It will be fed a stream of sensor events and filters these down to discrete location events. Those events will get persisted by Core Data to continue monitoring while a device is offline.

This module will own the Core Data stack, so it also will be responsible for fetching and deleting events as they are spooled to the backend.

### Reporting ###

This module is responsible for communicating location events to the backend.

In the future it will watch network availability, and try to regularly pop records out of the logging module and send them to the server. Currently, it's linked directly to the Tracker and immediately sends all location events to the server.

It takes the form of a framework, Farstrider Network, which talks to the server's API. The framework's FarstriderNetworkController protocol exposes two methods corresponding to the server API's get locations and add locations endpoints.

An XPC service, farstrider-network-client, links to the framework and exposes its controller protocol and controller as a remote object. Then the Tracker invokes the network-client as a separate process when it has a location to report.

Farstrider Server
=================

A bare bones Node.js server to receive logging events from the client, store them in a Mongo DB, and spit them out as JSON. It uses the Koa framework for nice ES6 async syntax (generators + yield).

The Node app and the DB run on separate Docker containers, stored in Docker Hub and linked together with Docker Compose. They live on an AWS server.

It has a very simple API with two endpoints for adding a location and getting all locations.
