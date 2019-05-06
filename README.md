# README

### Getting Started

* Clone repo
* Run `bundle install`
* Run `rake db:migrate`
* Run `rails server`
* If you want to populate your database with airport and nav aid data. You can find the sources I used originally below, but you'll have to write a script to ingest the data into your local app.
* Arelplane uses a service called MapSnap to generate images of maps. If you want to run this service, [download it](https://github.com/arelenglish/map-snap), get it running, and add a `config/local_env.yml` to your Arelplane repo with credentials for MapSnap. It should look like this:
```YAML
  MAPSNAP_ROOT_URL: 'http://localhost:8080'
  MAP_SNAP_API_KEY: 'your_api_key'
```

#### Airport data from:

 * http://ourairports.com/data,
 * http://www.wayforward.net/avdata/

### Dependencies:
  * [PostgreSQL](https://www.postgresql.org) I recommend using [Homebrew](https://brew.sh) to install and manage your Postgres install.
  * Check the Gemfile for now.
  * [MapSnap](https://github.com/arelenglish/map-snap)

#### Postgres:
```
To have launchd start postgresql now and restart at login:
  brew services start postgresql
Or, if you don't want/need a background service you can just run:
  pg_ctl -D /usr/local/var/postgres start
```
