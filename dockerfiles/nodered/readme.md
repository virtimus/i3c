Sample oauth with github

/i3c/data/nodered/settings.js
```jsonc
adminAuth: {
    type:"strategy",
    strategy: {
        name: "github",
        label: 'Sign in with Github',
        icon:"fa-github",
        strategy: require("passport-github").Strategy,
        options: {
         //   consumerKey: ".",
	     clientID: ".",	
         //   consumerSecret: ".",
	     clientSecret: ".",
            callbackURL: "http://rooturl/auth/strategy/callback"
        },
        verify: function(token, tokenSecret, profile, done) {
            done(null, profile);
        }
    },
    users: [
       { username: "virtimus",permissions: ["*"]}
    ]
},
```

extending global context by modules:

    functionGlobalContext: {
        // os:require('os'),
        // jfive:require("johnny-five"),
        // j5board:require("johnny-five").Board({repl:false})
	 stringModule:require('string'),
    },

	global.get('stringModule').
	

refs:

https://nodered.org/docs/platforms/docker
http://noderedguide.com/
https://www.coursera.org/learn/developer-nodered
https://www.npmjs.com/package/node-red-auth-github
https://nodered.org/docs/security#oauthopenid-based-authentication
https://nodered.org/docs/platforms/android