var koa = require('koa');
var route = require('koa-route');

var app = koa();

app.use(route.get('/', index));

function *index() {
	this.body = "<h1>farstrider-server</h1>";
}


app.listen(8080);
