curl -L -o sample-data 'https://drive.google.com/uc?export=download&id=1mlFYUbABFxfww8YeoLkX4Rpef9dMljU0'
mv sample-data sample-data.bson
mongorestore --username="admin" --password="" sample-data.bson
