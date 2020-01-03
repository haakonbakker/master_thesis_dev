#  OSA Tracker

CloudKit Dashboard: https://icloud.developer.apple.com/dashboard/

## Using the cloudkit api


POST [path]/database/[version]/[container]/[environment]/[database]/records/query

POST https://api.apple-cloudkit.com/database/1/iCloud.com.bakkertechnologies.osa-tracker-watch.watchkitapp.watchkitextension/development/public/records/query 


Authenticate a user:
https://api.apple-cloudkit.com/database/1/iCloud.com.bakkertechnologies.osa-tracker-watch.watchkitapp.watchkitextension/development/public/users/current?ckAPIToken=09e11a4783f4482769c48c4ec9b70725788178ad22f76b485ef3c2f6a214a0c9


path: https://api.apple-cloudkit.com
version: 1
container: iCloud.com.bakkertechnologies.osa-tracker-watch.watchkitapp.watchkitextension
env: development
database: public


token: 09e11a4783f4482769c48c4ec9b70725788178ad22f76b485ef3c2f6a214a0c9

We can use this method to get data from the public container. 
Using the cli we can then create a program that can download the data. 

