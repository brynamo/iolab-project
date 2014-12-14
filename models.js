var	util = require('util'),
	mongoose = require("mongoose"),
	jsonSelect = require('mongoose-json-select'),
	_ = require('underscore'),
	user = require('./user');

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
var CourseSchema = new BaseSchema({
  author_id: String,
  course_medium: String,
  description: String,
  img: String,
  is_free: Boolean,
  language: String,
  length: String,
  name: String,
  prereq: String,
  producer_id: mongoose.Schema.Types.ObjectId,
  producer_name: String,
  rating: Array,
  rigor: Array,
  subject: String,
  subject_id: mongoose.Schema.Types.ObjectId,
  tags: Array,
  url: String,
}, 
  { collection: 'Courses' });

var DomainSchema = new BaseSchema({
  color_code: String,
  domain: String,
}, 
  { collection: 'Domains' });

var ProducerSchema = new BaseSchema({
  about: String,
  logo: String,
  name: String,
  rating: Array,
  website: String,
}, 
  { collection: 'Producers' });

var RigorSchema = new BaseSchema({
  level: String,
  rig_max: Number,
  rig_min: Number,
}, 
  { collection: 'Rigor' });

var SubjectSchema = new BaseSchema({
  domain_id: mongoose.Schema.Types.ObjectId,
  subject: String,
}, 
  { collection: 'Subjects' });


// Add virtual attributes
CourseSchema.virtual('avg_rating').get(function() {
	return !this.rating || this.rating.length===0 ? null : (this.rating.reduce(function(a, b) { return a + b.rating },0) / this.rating.length);
});

CourseSchema.virtual('my_rating').get(function() {
		var myRating = _.findWhere(this.rating, {user_id: user.id});
		return myRating ? myRating.rating : null;
	})
	.set(function(rating) {
			if (this.my_rating) {
				var myRating = _.findWhere(this.rating, {user_id: user.id});
				myRating.rating = rating;
			} else {
				this.rating.push({user_id:user.id, rating: rating});
			}
			console.log("Updated ratings", this.rating);
	});
CourseSchema.virtual('avg_rigor').get(function() {
	return !this.rigor || this.rigor.length===0 ? null : (this.rigor.reduce(function(a, b) { return a + b.rigor },0) / this.rigor.length);
});

CourseSchema.plugin(jsonSelect, '-rating -rigor');


//Models
var CourseModel = mongoose.model( 'Course', CourseSchema );
var DomainModel = mongoose.model( 'Domain', DomainSchema );
var ProducerModel = mongoose.model( 'Producer', ProducerSchema );
var SubjectModel = mongoose.model( 'Subject', SubjectSchema );
var RigorModel = mongoose.model('Rigor', RigorSchema);

module.exports = {
	courses: CourseModel,
	domains: DomainModel,
	producers: ProducerModel,
	subjects: SubjectModel,
	rigors: RigorModel
};