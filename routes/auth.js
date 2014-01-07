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
								data.user = user;
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
		access: user.access
	};
}