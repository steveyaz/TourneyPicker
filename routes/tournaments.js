var mongo = require('mongodb');
var auth = require('./auth')

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
		collection.find().toArray(function(err, tournaments) {
			var data = [];
			for (var i = 0; i < tournaments.length; i++)
			{ 
				var tournament = {};
				tournament.name = tournaments[i].name
				tournament.game = tournaments[i].game
				tournament.id = tournaments[i]._id
				data.push(tournament);
			}
			res.send(data);
		});
	});
}

exports.find = function(req, res) {
	var id = req.params.id;
	console.log('Retrieving tournament: ' + id);
	mongoDb.collection('tournaments', function(err, collection) {
		collection.findOne({'_id': new mongo.BSONPure.ObjectID(id)}, function(err, tournament) {
			if (!err && tournament) {
				var data = {};
				data.name = tournament.name
				data.game = tournament.game
				res.send(data);
			} else {
				res.send();
			}
		});
	});
}

exports.add = function(req, res) {
	var tournament = req.body.tournament;
	console.log('Adding tournament: ' + JSON.stringify(tournament));
	auth.getUser(req, function(user) {
		if (user == null) {
			res.status(402)
		} else {
			if (user.access > 1) {
				mongoDb.collection('tournaments', function(err, collection) {
					tournament.administrator = user._id
					collection.insert(tournament, {safe:true}, function(err, result) {
						if (err) {
							res.status(401);
						} else {
							console.log('Success: ' + JSON.stringify(result[0]));
							res.send(result[0]._id);
						}
					});
				});
			} else {
				res.status(403).send('User does not have required access level.')
			}
		}
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
