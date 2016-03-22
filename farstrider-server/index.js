var koa = require('koa')
var route = require('koa-route')
var parse = require('co-body')

var mongoose = require('mongoose')
var Schema = mongoose.schema;
var locationSchema = mongoose.Schema({
	timestamp :Date,
	latitude :Number,
	longitude :Number
})

var koa_mongoose = require('koa-mongoose')
var Location = mongoose.model('Location', locationSchema)

var app = koa()

app.use(koa_mongoose({
	host: 'mongo',
	port: '27017',
	database :'locations',
	db: {
		native_parser: true
	},
	server: {
		poolSize: 5
	}
	
}))

app.use(route.get('/', index));
app.use(route.get('/locations', getLocations))
app.use(route.post('/api/v1/location/add/', addLocation))

function *index() {
	this.body = "<h1>farstrider-server</h1>";
}

function *addLocation() {
	console.log("Hit addLocation: " + this)
	var body = yield parse.json(this)
	console.log("Adding location: " + JSON.stringify(body))
	var location = new Location({
		timestamp: body.timestamp,
		latitude: body.latitude,
		longitude: body.longitude
	})
	console.log("Storing in Mongo: +", location)
	yield location.saveQ()
	console.log("Added location")
	this.body = 'OK'
}

function *getLocations() {
	console.log("hit get locations")
	var locations = yield Location.find()
	this.body = locations
}

console.log("listening")
app.listen(8080);
