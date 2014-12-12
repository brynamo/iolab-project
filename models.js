var	util = require('util'),
	mongoose = require("mongoose");

var BaseSchema = function() {
	mongoose.Schema.apply(this, arguments);

	// Duplicate the ID field.
	this.virtual('id').get(function(){
		return this._id.toHexString();
	});

	// Ensure virtual fields are serialised.
	this.set('toJSON', {
		virtuals: true
	});
};
util.inherits(BaseSchema, mongoose.Schema);

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

module.exports = {
	courses: CourseModel,
	domains: DomainModel,
	producers: ProducerModel,
	subjects: SubjectModel
};