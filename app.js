
var express = require('express'),
	http = require('http'),
	path = require('path'),
	expressHbs = require('express3-handlebars'),
	_ = require('underscore');




var app = express();

// For testing // Add headers
app.use(function (req, res, next) {
	// Website you wish to allow to connect
	res.setHeader('Access-Control-Allow-Origin', 'http://localhost:9000');

	// Request methods you wish to allow
	res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
	next();
});


// Configuration
app.configure(function() {
    app.set('port', process.env.PORT || 3333);
    app.set('views', path.join(__dirname, 'server/views'));

    app.use(express.bodyParser());
    app.use(express.methodOverride());

    app.use(app.router);
    app.use(express.static(__dirname + "/public"));

    app.engine('hbs', expressHbs({extname:'hbs', defaultLayout:__dirname+'/server/views/layouts/main.hbs'}));
	app.set('view engine', 'hbs');

    app.use(function (req,res) {
		res.render('err', {status:404, msg:"Page not found."});
	});	
});




// Data - Hardcode for now
var db = require("./data.json");

/*******
 * URLs
 * /courses - with query params
 * /domains
 * /domains/:id/subjects
 * /skill_levels
 ******/

// Put custom routes here

// Specialized route for courses
app.get("/courses", function(req, res) {
	var params = {};
	if (req.query.subject)
		params.subject_id = req.query.subject;
	if (req.query.skill_level) {
		// Get skill level
		var skill_level = _.findWhere(db.skill_levels, {id: parseInt(req.query.skill_level, 10)}); // REPLACE
		if (skill_level)
			params.rigors = _.range(skill_level.rigor_min, skill_level.rigor_max);
	}

	// Data lookup
	res.json( _.filter(db.courses, function(course) {
		return (!params.subject_id || course.subject_id == params.subject_id) && (!params.rigors || params.rigors.indexOf(course.rigor) > -1);
	}));
});

// Get subject for domain
app.get("/domains/:domain_id/subjects", function(req, res) {
	var domain_id = parseInt(req.params.domain_id, 10);
	res.json( _.where(db.subjects, {domain_id: domain_id}));
});

// Get list of type
app.get("/:collection", function(req, res) {
	var collection = req.params.collection;
	if (collection && db[collection]) {
		res.json(db[collection]); // Replace with mongo
	} else {
		res.send(400, {error: 'Bad url', url: req.url});
	}
});

// Get specific entity
app.get("/:collection/:entity", function(req, res) {
	var collection = req.params.collection;
	var entity = parseInt(req.params.entity, 10);

	if (collection && entity && db[collection]) {
		var object = _.findWhere(db[collection], {id:entity});
		if (!object)
			return res.send(404, {error: 'Not found', url: req.url});
		res.json(object); // Replace with mongo
	} else {
		res.send(400, {error: 'Bad url', url: req.url});
	}
});


http.createServer(app).listen(app.get('port'), function() {
    console.log("Express server listening on port " + app.get('port'));
});