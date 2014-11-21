
var express = require('express')
  , http = require('http')
  , path = require('path')
  , expressHbs = require('express3-handlebars')
;




var app = express();

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




// Hard code for now
var db = {
	domains: [
		{id: 1, name: "Biology & Life Sciences", color: "warning"},
		{id: 2, name: "Computer Science: Theory", color: "success"},
		{id: 3, name: "Mathematics", color: "danger"},
		{id: 4, name: "Law", color: "info"},
		{id: 5, name: "Chemistry", color: "primary"}
	],

	topics: [
		{id: 1, name: "Topic 1", domain_id: 1, color: "warning"},
		{id: 2, name: "Topic 2", domain_id: 1, color: "success"},
		{id: 3, name: "Topic 3", domain_id: 1, color: "danger"},
		{id: 4, name: "Topic 4", domain_id: 2, color: "info"},
		{id: 5, name: "Topic 5", domain_id: 2, color: "primary"}
	],

	courses: [
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9650" }, "topic_id": 1, "rating" : 3, "name" : "The Land Ethic Reclaimed: Perceptive Hunting, Aldo Leopold, and Conservation", "img" : "https://d15cw65ipctsrr.cloudfront.net/1d/28fc805fa711e4b6071703f8388bc1/leo.jpg", "url" : "https://www.coursera.org/course/perceptivehunting", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "1-2 hours/week", "rigor" : 10, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9651" }, "topic_id": 2, "rating" : 4, "name" : "Contraception: Choices, Culture and Consequences", "img" : "https://s3.amazonaws.com/coursera/topics/contraception/large-icon.png", "url" : "https://www.coursera.org/course/contraception", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "3-5 hours/week", "rigor" : 5, "author_id" : "Jerusalem Makonnen, RN, MSN, FNP", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9652" }, "topic_id": 3, "rating" : 3, "name" : "Introduction to Computational Arts: Processing", "img" : "https://coursera-course-photos.s3.amazonaws.com/d4/2643807ed811e3a695112751a2674b/Processing2.png", "url" : "https://www.coursera.org/course/compartsprocessing", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "1-4 hours/week", "rigor" : 1, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9653" }, "topic_id": 4, "rating" : 1, "name" : "Experimentation for Improvement", "img" : "https://coursera-course-photos.s3.amazonaws.com/10/d8fab0d16e11e39929d9d0a19c5584/StatsMOOCLogo2c.jpg", "url" : "https://www.coursera.org/course/experiments", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "3-4 hours/week", "rigor" : 3, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9654" }, "topic_id": 5, "rating" : 2, "name" : "Introduction to Computing 计算概论A", "img" : "https://coursera-course-photos.s3.amazonaws.com/31/2f7ea188d759845620a92a457d2acb/DSC_0856__.jpg", "url" : "https://www.coursera.org/course/pkuic", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "zh-cn", "length" : "6-8 hours/week", "rigor" : 3, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9655" }, "topic_id": 1, "rating" : 4, "name" : "Fundamentals of Fluid Power", "img" : "https://coursera-course-photos.s3.amazonaws.com/a4/fa9f50c58411e3b7c07d4cd434482c/logo_fluidpower_4_small.png", "url" : "https://www.coursera.org/course/fluidpower", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "5-7 hours/week", "rigor" : 6, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9656" }, "topic_id": 1, "rating" : 5, "name" : "Microeconomics Principles", "img" : "https://s3.amazonaws.com/coursera/topics/microecon/large-icon.png", "url" : "https://www.coursera.org/course/microecon", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "4-12 hours/week", "rigor" : 1, "author_id" : "Dr. José J. Vázquez-Cognet", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9657" }, "topic_id": 2, "rating" : 4, "name" : "The Science of the Solar System", "img" : "https://coursera-course-photos.s3.amazonaws.com/7f/00cbb0969c11e38c3fb9c37db4fbf3/course_image_1920x1080_notext4.jpg", "url" : "https://www.coursera.org/course/solarsystem", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "4-6 hours/week", "rigor" : 1, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9658" }, "topic_id": 2, "rating" : 3, "name" : "An Introduction to Consumer Neuroscience & Neuromarketing ", "img" : "https://coursera-course-photos.s3.amazonaws.com/6e/f6800d9aa59cab44a6b239a6d8c62e/banner1__1280x720px.png", "url" : "https://www.coursera.org/course/neuromarketing", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "4-6 hours/week", "rigor" : 10, "author_id" : "Null", "description" : "Coursera course" },
		{ "_id" : { "$oid" : "545ea4682dd20405e36e9659" }, "topic_id": 4, "rating" : 4, "name" : "Cloud Networking", "img" : "https://d15cw65ipctsrr.cloudfront.net/13/360da0530c11e492408bf1c99cee22/cloud_networking_v01_600X340.jpg", "url" : "https://www.coursera.org/course/cloudnetworking", "course_medium" : "video", "producer_id" : "Coursera", "is_free" : true, "language" : "en", "length" : "6-8 hours/week", "rigor" : 10, "author_id" : "Null", "description" : "Coursera course" }
	]
};

// Put custom routes here
app.get("/:collection", function(req, res) {
	var collection = req.params.collection;
	if (collection && db[collection]) {
		res.json(db[collection]); // Replace with mongo
	} else {
		res.send(400, {error: 'Bad url', url: req.url});
	}
});


app.get("/:collection/:entity", function(req, res) {
	var collection = req.params.collection;
	var entity = req.params.entity;

	if (collection && entity && db[collection] && db[collection][entity]) {
		res.json(db[collection][entity]); // Replace with mongo
	} else {
		res.send(400, {error: 'Bad url', url: req.url});
	}
});


http.createServer(app).listen(app.get('port'), function() {
    console.log("Express server listening on port " + app.get('port'));
});