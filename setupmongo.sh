# create user, set up replset, import sample data
mongosh setupreplset.js
curl -L -o sample-data 'https://drive.google.com/uc?export=download&id=1mlFYUbABFxfww8YeoLkX4Rpef9dMljU0'
mongorestore --username="admin" --password="" sample-data
