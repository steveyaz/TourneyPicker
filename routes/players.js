var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

mongoDb.open(function(err, db) {
	if(!err) {
		console.log("Connected to 'picker' database");
		mongoDb.collection('players', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'players' collection doesn't exist.");
			}
		});
	}
	else {
		console.log("Couldn't open MongoDB: " + err);
	}
});

exports.find = function(req, res) {
	var game = req.params.game;
	console.log('Retrieving players for game: ' + game);
	mongoDb.collection('players', function(err, collection) {
		collection.find( { game: game } ).toArray(function(err, items) {
			res.send(items);
		});
	});
}

exports.add = function(req, res) {
	var player = req.body;
	console.log('Adding player: ' + JSON.stringify(player));
	mongoDb.collection('players', function(err, collection) {
		collection.insert(player, {safe:true}, function(err, result) {
			if (err) {
				res.send({'error':'An error has occurred'});
			} else {
				console.log('Success: ' + JSON.stringify(result[0]));
				res.send(result[0]);
			}
		});
	});
}