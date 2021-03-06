var express = require('express')
var path = require('path')
var http = require('http')
var https = require('https')
var hbsPrecompiler = require('handlebars-precompiler')
var watch = require('watch')
var fs = require('fs')

var auth = require('./routes/auth')
var games = require('./routes/games')
var players = require('./routes/players')
var tournaments = require('./routes/tournaments')
var pools = require('./routes/pools')
var picks = require('./routes/picks')

var app = express()

app.configure(function () {
	app.set('port', process.env.PORT || 3001);
	app.use(express.logger('dev'))     /* 'default', 'short', 'tiny', 'dev' */
	app.use(express.bodyParser())
	app.use(express.cookieParser())
	app.use(express.session({secret: '199G6QNNQK844PP4'}))
	app.use(express.static(path.join(__dirname, 'public')))
	hbsPrecompiler.watchDir(
		__dirname + "/src/templates",
		__dirname + "/public/templates/templates.js",
		['handlebars', 'hbs']
	);
});

watch.watchTree('src', {ignoreDotFiles: true, persistent: true}, function (f, curr, prev) {
	var split
	if (typeof f == "string")
		split = f.split('.')
	if (split && split.length == 2 && (split[1] == 'html' || split[1] == 'js' || split[1] == 'css' || split[1] == 'png')) {
		if (typeof f == "object" && prev === null && curr === null) {
			// Finished walking the tree
		} else if (prev === null) {
			if (fs.existsSync(f)) {
				console.log('New file ' + f)
				fs.createReadStream(f).pipe(fs.createWriteStream('public' + f.substring(3)))
			}
		} else if (curr.nlink === 0) {
			if (fs.existsSync('public' + f.substring(3))) {
				console.log('Deleted file ' + f)
				fs.unlinkSync('public' + f.substring(3))
			}
		} else {
			if (fs.existsSync(f)) {
				console.log('Changed file ' + f)
				fs.createReadStream(f).pipe(fs.createWriteStream('public' + f.substring(3)))
			}
		}
	}
})

index = function(req, res){
  res.sendfile('public/index.html')
};

app.get('/', index)

app.post('/signin', auth.signIn)
app.post('/signout', auth.signOut)
app.post('/checksession', auth.checkSession)

app.get('/profile/:id', auth.getProfile)
app.put('/profile/:handle', auth.updateHandle)

app.get('/games', games.findAll)

app.get('/players/:game', players.find)
app.post('/players', players.add)

app.get('/tournaments', tournaments.findAll)
app.get('/tournaments/:id', tournaments.find)
app.post('/tournaments', tournaments.add)
app.delete('/tournaments/:id', tournaments.delete)
app.put('/tournaments/:id', tournaments.update)

app.get('/pools/:id', pools.find)
app.post('/pools', pools.add)
app.delete('/pools/:id', pools.delete)
app.put('/pools/:id', pools.update)

app.get('/picks/:id', picks.find)
app.post('/picks', picks.add)
app.delete('/picks/:id', picks.delete)
app.put('/picks/:id', picks.update)

var options = {
	key: fs.readFileSync('security/key.pem'),
	cert: fs.readFileSync('security/cert.pem')
};

// http server to redirect to https
var http = express.createServer();
http.get('*', function(req,res){  
    res.redirect('https://lingbling.net' + req.url);
})
http.listen(3000);

https.createServer(options, app).listen(app.get('port'), function () {
    console.log("Listening on port " + app.get('port'));
});
