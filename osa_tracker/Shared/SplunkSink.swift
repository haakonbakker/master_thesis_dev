//
//  SplunkSink.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 11/02/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class SplunkSink:Sink{
    
    static func runSink(events:[Data]) -> [Data]{
        if (events.isEmpty){return events}
//        let splunkURL = "http://13.69.135.182:8088/services/collector/event"
        let splunkURL = "http://13.69.135.182:8088/services/collector/raw"
        let url = URL(string: splunkURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        // insert json data to the request        
        var data = String()
        for event in events{
            data.append(String(decoding: event, as: UTF8.self))
        }

        request.httpBody = data.data(using: .utf8)
        
        request.setValue("Splunk e29076df-e74d-432d-acc7-3e6ad9d80cbf", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                SplunkSink.unableToUpload()
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
        
        
        return events
    }
    
    static func unableToUpload(){
        print("Unable to upload to Splunk.")
    }
}
