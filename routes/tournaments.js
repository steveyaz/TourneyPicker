var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

mongoDb.open(function(err, db) {
	if(!err) {
		console.log("Connected to 'picker' database");
		mongoDb.collection('tournaments', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'tournaments' collection doesn't exist.");
			}
		});
	}
	else {
		console.log("Couldn't open MongoDB: " + err);
	}
});

exports.findAll = function(req, res) {
	console.log('Retrieving all tournaments');
	mongoDb.collection('tournaments', function(err, collection) {
		collection.find().toArray(function(err, items) {
			res.send(items);
		});
	});
}

exports.find = function(req, res) {
	var id = req.params.id;
	console.log('Retrieving tournament: ' + id);
	mongoDb.collection('tournaments', function(err, collection) {
		collection.findOne({'_id': new mongo.BSONPure.ObjectID(id)}, function(err, item) {
			res.send(item);
		});
	});
}

exports.add = function(req, res) {
	var tournament = req.body;
	console.log('Adding tournament: ' + JSON.stringify(tournament));
	mongoDb.collection('tournaments', function(err, collection) {
		collection.insert(tournament, {safe:true}, function(err, result) {
			if (err) {
				res.send({'error':'An error has occurred'});
			} else {
				console.log('Success: ' + JSON.stringify(result[0]));
				res.send(result[0]);
			}
		});
	});
}

exports.delete = function(req, res) {
	var id = req.params.id;
	console.log('Deleting tournament: ' + id);
	mongoDb.collection('tournaments', function(err, collection) {
		collection.remove({'_id': new mongo.BSONPure.ObjectID(id)}, {safe:true}, function(err, result) {
			if (err) {
				res.send({'error':'An error has occurred - ' + err});
			} else {
				console.log('' + result + ' document(s) deleted');
				res.send(req.body);
			}
		});
	});
}

exports.update = function(req, res) {
	var id = req.params.id;
	var tournament = req.body;
	console.log('Updating tournament: ' + id);
	mongoDb.collection('tournaments', function(err, collection) {
		collection.update({'_id': new mongo.BSONPure.ObjectID(id)}, tournament, {safe:true}, function(err, result) {
			if (err) {
				console.log('Error updating tournament: ' + err);
				res.send({'error':'An error has occurred'});
			} else {
				console.log('' + result + ' document(s) updated');
				res.send(tournament);
			}
		});
	});
}
