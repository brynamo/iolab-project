
var express = require('express'),
	http = require('http'),
	path = require('path'),
	expressHbs = require('express3-handlebars'),
	mongoose = require("mongoose"),
	_ = require('underscore'),
	models = require('./models');




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
app.get( '/courses', function( request, response ) {
    return CourseModel.find(function( err, courses ) {
        if( !err ) {
        	var params = {};
			if (request.query.subject)
				params.subject_id = request.query.subject;
				console.log (params.subject_id)
			if (request.query.rigor) {
				// Get skill level
				var rigor = _.findWhere(RigorModel, {id: request.query.rigor}); // REPLACE
				if (rigor)
					params.rigors = _.range(rigor.rig_min, rigor.rig_max);
			}
			CourseModel.find({subject: params.subject_id}), function (err, courseINFO) {
			console.log(err);
			console.log(entity, courseINFO)
			if( !err ) {
		            return response.json(courseINFO);
		        } else {
		            console.log( err );
		            return response.send('ERROR');
		        }		
			}
        } else {
            console.log( err );
            return response.send('ERROR');
        }
    });
});


////JEPPE FILTER////

/* _.filter(CourseModel, function(err, course) {
return (!params.subject_id || course.subject_id == params.subject_id) && (!params.rigors || params.rigors.indexOf(course.rigor) > -1);
}));
*/
/////

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

/** 
 * Add valid collections to route filter
 **/
var validCollectionRoute = function(route) {
	var validCollections = Object.keys(models).join("|");
	var collectionVar = ":collection";
	return route.replace(collectionVar, collectionVar+"("+validCollections+")");
};


//TEST FOR VARIABLE URL
app.get( validCollectionRoute('/:collection/:entity?'), function( request, response ) {
	var collection = request.params.collection;
	var entity = request.params.entity;
	var Model = models[collection];
	// Find just one or all
	var query = entity ? Model.findById(entity) : Model.find();

	// Execute query
	query.exec(function (err, data) {
		if( !err ) {
			return response.json(data);
		} else {
            console.log( err );
            return response.send(404, {error: 'Not found', url: request.url, trace: err});
		}		
	});
});
/*
app.get( '/:collection', function( request, response ) {
	var collection = request.params.collection;
	var Model = models[collection];
	return Model.find(function(err, info) {
	        if( !err ) {
	            return response.json(info);
	        } else {
	            console.log( err );
	            return response.send('ERROR');
	        }
	});
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