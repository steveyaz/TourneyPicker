var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

mongoDb.open(function(err, db) {
	if(!err) {
		console.log("Connected to 'picker' database");
		mongoDb.collection('games', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'games' collection doesn't exist.");
			}
		});
	}
	else {
		console.log("Couldn't open MongoDB: " + err);
	}
});

exports.findAll = function(req, res) {
	console.log(req.session)
	mongoDb.collection('games', function(err, collection) {
		collection.find().toArray(function(err, items) {
			res.send(items);
		});
	});
}