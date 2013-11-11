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
var populateDB = function() {

	var games = [
	{
		name: "Starcraft II",
	},
	{
		name: "Dota II",
	}
	]

	var players = [
	{
		handle: "Leenock",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "MVP",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "Nestea",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "Fruitdealer",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "Jaedong",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "MaruPrime",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "Rain",
		name: "Real Name",
		game: "Starcraft II"
	},
	{
		handle: "Innovation",
		name: "Real Name",
		game: "Starcraft II"
	},
	]

	var tourneys = [
	{
		game: "Starcraft II",
		name: "2014 WCS Korea Season 1",
		rounds: [
			{
				dueDate: "2013-01-31T00:00:00",
				format: "group4",
				groups: [
					{
						players: [ "Leenock", "MVP", "Nestea", "Fruitdealer" ],
						winners: [ "Leenock", "Nestea" ]
					},
					{
						players: [ "Jaedong", "MaruPrime", "Rain", "Innovation" ],
						winners: []
					}
				]
			},
			{
				dueDate: "2013-02-31T00:00:00",
				format: "bracket",
				groups: [
					{
						players: [],
						winners: []
					},
					{
						players: [],
						winners: []
					}
				]
			},
			{
				dueDate: "2013-03-31T00:00:00",
				format: "bracket",
				groups: [
					{
						players: [],
						winners: []
					}
				]
			}
		],
	},
	{
		game: "Dota II",
		name: "The International 2014",
		rounds: []
	}]

	mongoDb.collection('games', function(err, collection) {
		collection.insert(games, {safe:true}, function(err, result) {});
	});

	mongoDb.collection('players', function(err, collection) {
		collection.insert(players, {safe:true}, function(err, result) {});
	});

	mongoDb.collection('tourneys', function(err, collection) {
		collection.insert(tourneys, {safe:true}, function(err, result) {});
	});

};