var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

mongoDb.open(function(err, db) {
	if(!err) {
		console.log("Connected to 'picker' database");
		mongoDb.collection('games', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'games' collection doesn't exist. Loading template data...");
				populateDB();
			}
		});
	}
	else {
		console.log("Couldn't open MongoDB: " + err);
	}
});

exports.findAll = function(req, res) {
	console.log('Retrieving all games');
	mongoDb.collection('games', function(err, collection) {
		collection.find().toArray(function(err, items) {
			res.send(items);
		});
	});
}

/*--------------------------------------------------------------------------------------------------------------------*/
// Populate database with template data -- Only used once: the first time the application is started.
var populateDB = function() {

	var games = [
	{
		id: "starcraft",
		name: "Starcraft II",
	},
	{
		id: "dota",
		name: "DOTA II",
	}
	]

	mongoDb.collection('games', function(err, collection) {
		collection.insert(games, {safe:true}, function(err, result) {});
	});

}

 //    var game =
 //    {
 // 	       id: "starcraft",
 // 	       name: "Starcraft II",
 //    }
 //
 //    var player =
 //    {
 //            dateCreated: "2013-01-31T00:00:00Z",
 //            handle: "Leenock",
 //            name: "Lee Dong Nyoung",
 //            game: "starcraft",
 //    }
 //
 //    var tournament =
 //    {
 //            name: "2014 WCS Korea Season 1",
 //            administrator: ObjectId("51a7dc7b2cacf40b79990be6"),
 //            dateCreated: "2013-01-31T00:00:00Z",
 //            game: "starcraft",
 //            active: true,
 //            rounds: {
 //                            1: {
 //                                    startDate: "2013-01-31T00:00:00Z",
 //                                    format: "group4",
 //                                    groups: [
 //                                            {
 //                                                    players: [ ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6") ],
 //                                                    winners: [ ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6") ],
 //                                            },
 //                                            {
 //                                                    players: [ ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6"), ObjectId("51a7dc7b2cacf40b79990be6") ],
 //                                                    winners: [],
 //                                            },
 //                                    ]
 //                            },
 //                            2: {
 //                                    startDate: "2013-02-31T00:00:00Z",
 //                                    format: "bracket",
 //                                    groups: [
 //                                            {
 //                                                    players: [],
 //                                                    winners: [],
 //                                            },
 //                                            {
 //                                                    players: [],
 //                                                    winners: [],
 //                                            },
 //                                    ]
 //                            },
 //                            3: {
 //                                    startDate: "2013-03-31T00:00:00Z",
 //                                    format: "bracket",
 //                                    groups: [
 //                                            {
 //                                                    players: [],
 //                                                    winners: [],
 //                                            },
 //                                    ]
 //                            },
 //                    },
 //    }
 //
 //    var pool =
 //    {
 //            name: "YAZI Clan Pool",
 //            commissioner: ObjectId("51a7dc7b2cacf40b79990be6"),
 //            dateCreated: "2013-01-31T00:00:00Z",
 //            game: "dota",
 //            tournament: ObjectId("51a7dc7b2cacf40b79990be6"),
 //            entry: 10,
 //            prizePool: 133,
 //            prizeStructure: {
 //                    1: 60,
 //                    2: 30,
 //                    3: 10,
 //            },
 //            roundStructure: {
 //                    1: { type: weighted, weight: 4 },
 //                    2: { type: normal, weight: 2 },
 //                    3: { type: normal, weight: 4 },
 //            },
 //            entrants: [
 //                    { user: ObjectId("51a7dc7b2cacf40b79990be6"), pick: ObjectId("51a7dc7b2cacf40b79990be6") },
 //            ],
 //    }
 //
 //    var pick =
 //    {
 //            winners: {
 //                    1: [
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 4 },
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 1 },
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 2 },
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 3 },
 //                    ],
 //                    2: [
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 2},
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 2},
 //                    ],
 //                    3: [
 //                            { player: ObjectId("51a7dc7b2cacf40b79990be6"), weight: 4},
 //                    ]
 //            },
 //            points: 13,
 //    }
 //
 //    var user =
 //    {
 //            email: "steve.yazicioglu@gmail.com"
 //            handle: "sente",
 //            dateCreated: "2013-01-31T00:00:00Z",
 //            bling: 183.53,
 //            access: 3,
 //    }
 //