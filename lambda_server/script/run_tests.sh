#!/bin/sh
#npm install -g parse-server mongodb-runner
mongodb-runner start > /dev/null
parse-server --appId "appId" --masterKey "masterKey" --databaseURI "mongodb://localhost:27017" > /tmp/parse-server-log.txt &
sleep 1
while ! grep -q -m1 'parse-server running' < /tmp/parse-server-log.txt; do
    sleep 1
done
rm /tmp/parse-server-log.txt
PARSE_SERVER_PID=$!
dart pub run test
kill $PARSE_SERVER_PID
mongodb-runner stop