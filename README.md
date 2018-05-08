# README

#### Airport data from:

 * http://ourairports.com/data,
 * http://www.wayforward.net/avdata/

### Dependencies:

#### Postgres:
```
To have launchd start postgresql now and restart at login:
  brew services start postgresql
Or, if you don't want/need a background service you can just run:
  pg_ctl -D /usr/local/var/postgres start
```

#### Javascript Dependencies:

##### Install Dependencies:
* `yarn install`

##### Start Webpack Dev Server:
`bin/webpack-dev-server`
