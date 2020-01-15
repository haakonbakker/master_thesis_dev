import requests


print("iCloud Cloudkit downloader")



def getSessions():
    url = "https://api.apple-cloudkit.com/database/1/iCloud.com.bakkertechnologies.osa-tracker-watch.watchkitapp.watchkitextension/development/public/records/query?ckAPIToken=09e11a4783f4482769c48c4ec9b70725788178ad22f76b485ef3c2f6a214a0c9"
    body =  """{
                "query": {
                    "recordType": "bucket",
                    
                    "sortBy": [
                    {
                        "fieldName": "sessionIdentifier",
                        "ascending": false
                    }
                    ]
                }
                }
            """
    x = requests.post(url, data = body)

    # print(x.text)
    f = open("data.json","w+")
    f.write(x.text)
    f.close()
    response = x.json()


    recs = response["records"]
    print("Which session should we get?")
    for rec in recs:
        print(rec["fields"]["sessionIdentifier"]["value"])
    # print(recs)

getSessions()