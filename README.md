Farstrider
----------

This app uses a Mac OS X background service to share a laptop's location with a remote backend and display the location history in an iPhone app.

It's a proof of concept to demonstrate an understanding of the underlying technology, and to explore some architectural designs for framework and service based application structure.

Farstrider Agent
=================

The main process is a launch service agent that tries to sense times to check for a new location, and is responsible for marshalling location detection and reporting.

The process itself only contains the main runloop. It links to a framework, Farstrider Tracker, which has a controller responsible for sensing cues that the device location may have changed, determining the device position, and sending it to the backend.

Right now the tracker's Sensor Controller just looks for power wake events. When they happen, it informs its Location Controller, which spins up CLLocationManager to get the device's GPS coordinates. Once it has the coordinates, it sends them to the Event Recorder class, which acts as the reporting module.

The Event Recorder is responsible for communicating location events to the backend.

It utilizes a framework, Farstrider Network, which talks to the server's API. The framework's FarstriderNetworkController protocol exposes two methods corresponding to the server API's get locations and add locations endpoints, although the Event Recorder doesn't call them directly.

Instead, for robustness and security, an XPC service (farstrider-network-client) links to the network framework and exposes its controller protocol and controller as a remote object. The agent invokes the network-client as a separate process when it has a location to report.

Farstrider Server
=================

A bare bones Node.js server to receive logging events from the client, store them in a Mongo DB, and spit them out as JSON. It uses the Koa framework for nice ES6 async syntax (generators + yield).

The Node app and the DB run on separate Docker containers, stored in Docker Hub and linked together with Docker Compose. They live on an AWS server.

It has a very simple API with two endpoints for adding a location and getting all locations.

Farstrider Client
=================

A simple iOS app that displays the location data tracked by the Mac agent and stored by the server.

It displays an MKMapView, and drops pins on every location the Mac has visited, in chronological order.

It links to an iOS build of the Farstrider Network framework to retrieve the locations.

To-Do
=====

* The background agent should use several sub-modules, each responsible for monitoring one particular aspect of the environment for indications that the laptop might have moved:
	* Power wake events (currently)
	* Accelerometer data (eventually)
	* Network changes (eventually)
* Offline logging
	* This module will be responsible for recording changes to the device location. It will be fed a stream of sensor events and filters these down to discrete location events. Those events will get persisted by Core Data to continue monitoring while a device is offline.
	* This module will own the Core Data stack, so it also will be responsible for fetching and deleting events as they are spooled to the backend.
* More sophisticated event reporting
	* In the future the event recorder will watch network availability, and try to regularly pop records out of the logging module and send them to the server. Currently, it's linked directly to the Tracker and immediately sends all location events to the server.
