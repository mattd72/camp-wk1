curl -LO https://github.com/mattd72/camp-wk1/raw/main/data.zip?download=
unzip data.zip
mongorestore --username="admin" --password="" data/dump
