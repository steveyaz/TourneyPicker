var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

mongoDb.open(function(err, db) {
	if(!err) {
		console.log("Connected to 'picker' database");
		mongoDb.collection('tourneys', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'tourneys' collection doesn't exist. Creating it with sample data...");
				populateDB();
			}
		});
	}
	else {
		console.log("Couldn't open MongoDB: " + err);
	}
});

exports.findAll = function(req, res) {
	console.log(req.session)
	mongoDb.collection('tourneys', function(err, collection) {
		collection.find().toArray(function(err, items) {
			res.send(items);
		});
	});
}

exports.find = function(req, res) {
	var id = req.params.id;
	console.log('Retrieving tourneys: ' + id);
	mongoDb.collection('tourneys', function(err, collection) {
		collection.findOne({'_id': new mongo.BSONPure.ObjectID(id)}, function(err, item) {
			res.send(item);
		});
	});
}

exports.add = function(req, res) {
	var tourney = req.body;
	console.log('Adding tourney: ' + JSON.stringify(tourney));
	mongoDb.collection('tourneys', function(err, collection) {
		collection.insert(tourney, {safe:true}, function(err, result) {
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
	console.log('Deleting tourney: ' + id);
	mongoDb.collection('tourneys', function(err, collection) {
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
	var tourney = req.body;
	console.log('Updating tourney: ' + id);
	console.log(JSON.stringify(tourney));
	mongoDb.collection('tourneys', function(err, collection) {
		collection.update({'_id': new mongo.BSONPure.ObjectID(id)}, tourney, {safe:true}, function(err, result) {
			if (err) {
				console.log('Error updating tourney: ' + err);
				res.send({'error':'An error has occurred'});
			} else {
				console.log('' + result + ' document(s) updated');
				res.send(tourney);
			}
		});
	});
}

 
/*--------------------------------------------------------------------------------------------------------------------*/
// Populate database with sample data -- Only used once: the first time the application is started.
// You'd typically not find this code in a real-life app, since the database would already exist.
var populateDB = function() {

	var games = [
	{
		name: "Starcraft II",
	},
	{
		name: "Dota II",
	}
	]

	var tourneys = [
	{
		name: "WCS Korea",
		fullname: "2013 WCS Korea Season 3",
	},
	{
		name: "The International",
		fullname: "The International 2013",
	}]

	mongoDb.collection('games', function(err, collection) {
		collection.insert(games, {safe:true}, function(err, result) {});
	});

	mongoDb.collection('tourneys', function(err, collection) {
		collection.insert(tourneys, {safe:true}, function(err, result) {});
	});

};