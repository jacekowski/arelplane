#!/bin/sh

set -e
echo "arelplane: starting entrypoint.sh"
INSTALL_FLAG=/data/installed
initialize() {
    echo "arelplane: initialize()"
    # first run commands go here
    rake db:migrate
}
upgrade() {
    echo "arelplane: upgrade()"
    # upgrade commands go here
}

start() {
    echo "arelplane: start()"
    exec rails server -b 0.0.0.0
}

if [ ! -f $INSTALL_FLAG ]; then
   initialize
   touch $INSTALL_FLAG
else
   upgrade
fi
start

