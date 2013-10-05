var https = require('https')

exports.login = function(req, res) {
	// req.body['accessToken']
	var url = 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=' + req.body['accessToken']

	https.get(url, function(authRes) {
		authRes.on('data', function(d){
			var email = JSON.parse(d.toString())['email']
			res.send({email: email})
		});
	}).on("error", function(e) {
		res.send(e)
	});
}