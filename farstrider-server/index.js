var koa 		= require('koa')
var route 		= require('koa-route')
var parse 		= require('co-body')
var mongoose	= require('mongoose')

mongoose.connect('mongodb://mongo:27017/locations')
var Schema = mongoose.schema;
var locationSchema = mongoose.Schema({
	timestamp :Date,
	latitude :Number,
	longitude :Number
})
var Location = mongoose.model('Location', locationSchema)

var app = koa()
app.use(route.get(	'/', index));
app.use(route.get(	'/api/v1/locations', getLocations))
app.use(route.post(	'/api/v1/location/add', addLocation))

function *index() {
	this.body = "<h1>farstrider-server</h1>";
}

function *addLocation() {
	var body = yield parse.json(this)
	console.log("Adding location: " + JSON.stringify(body))
	var location = new Location({
		timestamp: body.timestamp,
		latitude: body.latitude,
		longitude: body.longitude
	})
	yield location.save()
	this.body = 'OK'
}

function *getLocations() {
	var locations = yield Location.find()
	this.body = locations
}

app.listen(8080);