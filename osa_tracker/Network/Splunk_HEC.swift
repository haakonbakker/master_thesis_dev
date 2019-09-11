//
//  Splunk_HEC.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 04/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

enum SplunkLocation{
    case local
    case azure
}

struct SplunkInstance{
    var theProtocol:String
    var port:String
    var ip:String
    
    func getUrl() -> String{
        let url = self.theProtocol + "://" + self.ip + ":" + self.port + "/services/collector"
        return url
    }
}

struct Splunk_Timestamp{
    func get_time_stamp() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }

}

class SplunkHEC{
    var instance:SplunkInstance!
    
    init(splunkInstance:SplunkInstance){
        instance = splunkInstance
    }
        
    func post_datapoint(){
        let splt = Splunk_Timestamp()
        
        print("Post datapoint to Splunk")
        
        // prepare json data
        
        let json: [String: Any] = ["host": "macbook",
                                   "time": Date().timeIntervalSince1970,
                                   "event": ["timestamp":splt.get_time_stamp(),
                                             "sensor":"gyroscope",
                                             "x":Double.random(in: 0.0 ..< 10.0).description,
                                             "y":Double.random(in: 0.0 ..< 10.0).description,
                                             "z":Double.random(in: 0.0 ..< 10.0).description,
                                            ]]

        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
//        let url = URL(string: "http://127.0.0.1:8088/services/collector")!
        let url = URL(string: instance.getUrl())
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        request.setValue("Splunk e03f15e8-e31c-48da-a75f-b174e35ad472", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
    }
}

var inst = SplunkInstance(theProtocol: "http", port: "8088", ip: "127.0.0.1")
var spl = SplunkHEC(splunkInstance: inst)
spl.post_datapoint()
spl.post_datapoint()
spl.post_datapoint()
spl.post_datapoint()
spl.post_datapoint()
spl.post_datapoint()
spl.post_datapoint()
spl.post_datapoint()
//spl.printDate(string: "")
//
//
//
sleep(3)
print(Date().timeIntervalSince1970)
