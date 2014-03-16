var https = require('https')
var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

mongoDb.open(function(err, db) {
	if(!err) {
		console.log("Connected to 'picker' database");
		mongoDb.collection('users', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'users' collection doesn't exist.");
			}
		});
		mongoDb.collection('sessions', {strict:true}, function(err, collection) {
			if (err) {
				console.log("The 'sessions' collection doesn't exist.");
			}
		});
	}
	else {
		console.log("Couldn't open MongoDB: " + err);
	}
});

exports.signIn = function(req, res) {
	var url = 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=' + req.body['accessToken'];
	var email = null;
	https.get(url, function(authRes) {
		authRes.on('data', function(d){
			email = JSON.parse(d.toString())['email'];
			sid = req.cookies['connect.sid'];
			if (email != null && sid != null) {
				mongoDb.collection('users', function(err, collection) {
					collection.findOne({email: email}, function(err, user) {
						if (err) {
							console.log(err);
							res.send();
						}
						if (user == null) {
							user = createUser(email);
						}
						initiateSession(email, sid);
						var logInResponse = createLogInResponse(user);
						res.send(logInResponse);
					});
				});
			} else {
				console.log('Invalid credentials or session');
			}
		});
	}).on("error", function(e) {
		res.send(e)
	});
}

exports.signOut = function(req, res) {
	var sid = req.cookies['connect.sid'];
	console.log('Signing out: ' + sid);
	mongoDb.collection('sessions', function(err, collection) {
		collection.update({sid: sid}, {$set: {status: 'signedout'}}, function(err, session) {
			if (err) {
				console.log(err);
			}
		});
	});

	res.send();
}

exports.checkSession = function(req, res) {
	var sid = req.cookies['connect.sid'];
	var data = {};
	console.log('Check session: ' + sid);
	req.session.cookie.expires = true;
	req.session.cookie.maxAge = 3600000;
	mongoDb.collection('sessions', function(err, collection) {
		collection.findOne({sid: sid}, function(err, session) {
			if (session != null) {
				data.status = session.status;
				if (session.status === 'signedin') {
					mongoDb.collection('users', function(err, collection) {
						collection.findOne({email: session.email}, function(err, user) {
							if (err) {
								console.log(err);
							}
							if (user != null) {
								data.user = createLogInResponse(user);
							}
							res.send(data);
						});
					});
				} else {
					res.send(data);
				}
			} else {
				res.send();
			}
		});
	});
}

function initiateSession(email, sid) {
	console.log('Signing in: ' + email);
	var session = {email: email, sid: sid, status: 'signedin', start: new Date().toISOString()};

	mongoDb.collection('sessions', function(err, collection) {
		collection.update({email: email}, session, {safe:true, upsert:true}, function(err, result) {
			if (err) {
				console.log(err); // Sonya
			}
		});
	});
}

function createUser(email) {
	console.log('Creating new user: ' + email);

	var user = {
		email: email,
		handle: 'newling',
		dateCreated: new Date().toISOString(),
		bling: 0,
		access: 1
	};

	mongoDb.collection('users', function(err, collection) {
		collection.insert(user, {safe:true}, function(err, result) {
			if (err) {
				console.log(err);
			}
		});
	});

	return user;
}

function createLogInResponse(user) {
	return {
		email: user.email,
		handle: user.handle,
		bling: user.bling,
		access: user.access,
		id: user._id
	};
}

exports.getUser = function(req, callback) {
	var email = req.body.email;
	var sid = req.cookies['connect.sid'];
	req.session.cookie.expires = true;
	req.session.cookie.maxAge = 3600000;
	console.log('Retrieving user: ' + email);

	mongoDb.collection('sessions', function(err, collection) {
		collection.findOne({email: email, sid: sid}, function(err, session) {
			if (session != null) {
				if (session.status === 'signedin') {
					mongoDb.collection('users', function(err, collection) {
						collection.findOne({email: session.email}, function(err, user) {
							if (err) {
								callback(null);
							} else if (user != null) {
								callback(user);
							} else {
								callback(null);
							}
						});
					});
				} else {
					callback(null);
				}
			} else {
				callback(null);
			}
		});
	});
}

exports.getProfile = function(req, res) {

	var id = req.params.id;
	var sid = req.cookies['connect.sid'];
	var data = {}
	data.editable = false;

	console.log('getProfile: ' + id);

	// cookie expiration
	req.session.cookie.expires = true;
	req.session.cookie.maxAge = 3600000;

	// get the requested user info no matter the session
	mongoDb.collection('users', function(err, collection) {
		collection.findOne({_id: new mongo.BSONPure.ObjectID(id)}, function(err, user) {
			if (!err && user) {
				data.handle = user.handle;
				data.bling = user.bling;
				// check the session to see if we're returning additional information for this profile
				mongoDb.collection('sessions', function(err, collection) {
					collection.findOne({sid: sid}, function(err, session) {
						if (session != null && session.status === 'signedin') {
							if (!err && user && user.email === session.email) {
								// we're signed in with the requested user - return additional information
								data.editable = true;
								mongoDb.collection('tournaments', function(err, collection) {
									collection.find({administrator: mongo.BSONPure.ObjectID(id)}).toArray(function(err, tournaments) {
										if (!err && tournaments) {
											data.tournaments = tournaments;
											res.send(data);
										} else {
											res.send(data);
										}
									});
								});
							} else {
								res.send(data);
							}
						} else {
							res.send(data);
						}
					});
				});
			} else {
				res.send();
			}
		});
	});

}

exports.updateHandle = function(req, res) {

	var handle = req.params.handle;
	var sid = req.cookies['connect.sid'];
	var data = {}
	data.editable = false;

	console.log('updateHandle: ' + handle);

	// cookie expiration
	req.session.cookie.expires = true;
	req.session.cookie.maxAge = 3600000;

	// check the session
	mongoDb.collection('sessions', function(err, collection) {
		collection.findOne({sid: sid}, function(err, session) {
			if (session != null) {
				if (session.status === 'signedin') {
					// update the logged in user
					mongoDb.collection('users', function(err, collection) {
						collection.update({email: session.email}, {$set: {handle: handle}}, {safe:true}, function(err, result) {
							res.send();
						});
					});
				} else {
					res.send();
				}
			} else {
				res.send();
			}
		});
	});

}