
var express = require('express'),
	http = require('http'),
	path = require('path'),
	expressHbs = require('express3-handlebars'),
	mongoose = require("mongoose");
	_ = require('underscore');




var app = express();

// For testing // Add headers
if (!process.env.IS_LIVE) {
	app.use(function (req, res, next) {
		// Website you wish to allow to connect
		res.setHeader('Access-Control-Allow-Origin', 'http://localhost:9000');

		// Request methods you wish to allow
		res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
		next();
	});
}


// Configuration
app.configure(function() {
    app.set('port', process.env.PORT || 3333);
    app.set('views', path.join(__dirname, 'server/views'));

    app.use(express.bodyParser());
    app.use(express.methodOverride());

    app.use(app.router);
    app.use(express.static(path.join(__dirname, "public")));

    app.engine('hbs', expressHbs({extname:'hbs', defaultLayout:__dirname+'/server/views/layouts/main.hbs'}));
	app.set('view engine', 'hbs');

    app.use(function (req,res) {
		res.render('err', {status:404, msg:"Page not found."});
	});	
});

//bryan look at this
var MONGOHQ_URL="mongodb://team4:alexisgreat@dogen.mongohq.com:10031/io-db"
mongoose.connect(MONGOHQ_URL);

//Schemas
var CourseSchema = new mongoose.Schema({
  author_id: String,
  course_medium: String,
  description: String,
  img: String,
  is_free: Boolean,
  language: String,
  length: String,
  name: String,
  prereq: String,
  producer_id: String,
  producer_name: String,
  rating: Array,
  rigor: Array,
  subject: String,
  subject_id: String,
  tags: Array,
  url: String,
}, 
  { collection: 'Courses' });

var DomainSchema = new mongoose.Schema({
  color_code: String,
  domain: String,
}, 
  { collection: 'Domains' });

var ProducerSchema = new mongoose.Schema({
  about: String,
  logo: String,
  name: String,
  rating: Array,
  website: String,
}, 
  { collection: 'Producers' });

var RigorSchema = new mongoose.Schema({
  level: String,
  rigor_max: Number,
  rigor_min: String,
}, 
  { collection: 'Producers' });

var SubjectSchema = new mongoose.Schema({
  domain_id: String,
  subject: String,
}, 
  { collection: 'Subjects' });

//Models
var CourseModel = mongoose.model( 'Courses', CourseSchema );
var DomainModel = mongoose.model( 'Domain', DomainSchema );
var ProducerModel = mongoose.model( 'Producer', ProducerSchema );
var SubjectModel = mongoose.model( 'Subject', SubjectSchema );



// Data - Hardcode for now
//var db = require("./data.json");

/*******
 * URLs
 * /courses - with query params
 * /courses/:id
 * /domains
 * /domains/:id/subjects
 * /skill_levels
 * 
 ******/

// Put custom routes here

// Specialized route for courses
/*app.get( '/courses', function( request, response ) {
    return CourseModel.find(function( err, Courses ) {
        if( !err ) {
            return response.json(Courses);
        } else {
            console.log( err );
            return response.send('ERROR');
        }
    });
});*/

/*	var params = {};
	if (req.query.subject)
		params.subject_id = req.query.subject;
	if (req.query.skill_level) {
		// Get skill level
		var skill_level = _.findWhere(db.skill_levels, {id: req.query.skill_level}); // REPLACE
		if (skill_level)
			params.rigors = _.range(skill_level.rigor_min, skill_level.rigor_max);
	}


	// Data lookup
	res.json( _.filter(db.courses, function(course) {
		return (!params.subject_id || course.subject_id == params.subject_id) && (!params.rigors || params.rigors.indexOf(course.rigor) > -1);
	}));
});
*/
// Get subject for domain
/*app.get( '/domains', function( request, response ) {
    return DomainModel.find(function( err, Domains ) {
        if( !err ) {
            return response.json(Domains);
        } else {
            console.log( err );
            return response.send('ERROR');
        }
    });
});*/

var models = {
	'courses': CourseModel,
	'domains': DomainModel,
	'producers': ProducerModel,
	'subjects': SubjectModel
}

//TEST FOR VARIABLE URL
app.get( '/:collection/:entity', function( request, response ) {
	var collection = request.params.collection;
	var Model = models[collection];
	var entity = request.params.entity;
	var object = Model.findById(entity, function (err, courseINFO) {
		console.log(err);
		console.log(entity, courseINFO)
		if( !err ) {
	            return response.json(courseINFO);
	        } else {
	            console.log( err );
	            return response.send('ERROR');
	        }		
	});
	/*console.log("test", collection)
	console.log("entity", entity)
	//console.log(Model)
	console.log(object)
	return Model.find(function(err, info) {
	        if( !err ) {
	            return response.json(info);
	        } else {
	            console.log( err );
	            return response.send('ERROR');
	        }
	});*/
});

/*
	if (collection == 'domains') {

	    return DomainModel.find(function( err, Domains ) {
	        if( !err ) {
	            return response.json(Domains);
	        } else {
	            console.log( err );
	            return response.send('ERROR');
	        }
	    });
	}
	else if (collection == 'courses') {
		console.log("i'm batman")
	    return CoursesModel.find(function( err, Courses ) {
	        if( !err ) {
	            return response.json(Courses);
	        } else {
	            console.log( err );
	            return response.send('ERROR');
	        }
    	});
	}
});
*/

//OLD CODE!!!!!!!!!!!!!!!!!!
/*
app.get("/domains/:domain_id/subjects", function(req, res) {
	var domain_id = req.params.domain_id;
	res.json( _.where(db.subjects, {domain_id: domain_id}));
});



// Get list of type
app.get("/:collection(domains|subjects|courses|skill_levels)", function(req, res) {
	var collection = req.params.collection;
	if (collection && db[collection]) {
		res.json(db[collection]); // Replace with mongo
	} else {
		res.send(400, {error: 'Bad url', url: req.url});
	}
});


// Get specific entity
app.get("/:collection(domains|subjects|courses|skill_levels)/:entity", function(req, res) {
	var collection = req.params.collection;
	var entity = req.params.entity;

	if (collection && entity && db[collection]) {
		var object = _.findWhere(db[collection], {id:entity});
		if (!object)
			return res.send(404, {error: 'Not found', url: req.url});
		res.json(object); // Replace with mongo
	} else {
		res.send(400, {error: 'Bad url', url: req.url});
	}
});
*/

http.createServer(app).listen(app.get('port'), function() {
    console.log("Express server listening on port " + app.get('port'));
});