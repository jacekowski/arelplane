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
## Things to Add to airport pages
  * Form to submit updates to name, identifier, location, etc.
  * Form to submit new locations
  * Show relevant data about the location
  * Ability to upload images of airport maybe
  * Add map of location
  * show origin and destination airports from the given location
  * show airplanes that have landed there
  * show how many times users have flown to the airport
  * Show logged in users their stats for the airport
