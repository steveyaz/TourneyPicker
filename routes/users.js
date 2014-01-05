var https = require('https')
var mongo = require('mongodb');

var mongoServer = new mongo.Server('localhost', 27017, {auto_reconnect: true});
var mongoDb = new mongo.Db('pickerdb', mongoServer);

exports.signIn = function(req, res) {
	var url = 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=' + req.body['accessToken']
	var email = null
	https.get(url, function(authRes) {
		authRes.on('data', function(d){
			email = JSON.parse(d.toString())['email']
			if (email != null) {
				mongoDb.collection('users', function(err, collection) {
					console.log('Logging in: ' + email);
					collection.findOne({'email': email}, function(err, item) {
						console.log(err)
						console.log(item)
					});
				});
			} else {
				console.log('Invalid login');
			}
			res.send({email: email})
		});
	}).on("error", function(e) {
		res.send(e)
	});
	
	//TODO do something with session
}

exports.signOut = function(req, res) {
	res.send({})
}