//
//  SplunkSink.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 11/02/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class SplunkSink{
    
    func runSink(events:[Data]) -> [Data]{
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
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Splunk e29076df-e74d-432d-acc7-3e6ad9d80cbf", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("json", forHTTPHeaderField: "Content-Type")
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data.data(using: .utf8), completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
            }
        }).resume()
//        upload(request: request)

        // Implement https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_in_the_background
//        let backgroundTask = urlSession.downloadTask(with: request)
//        backgroundTask.resume()
        
        
        return events
    }
    
    func upload (request:URLRequest){
//        let task = URLSession.shared.dataTask(with: request) { indata, _, _ in
//            print(indata)
//        }
//
//        task.resume()
        
    }
    
    static func unableToUpload(){
        print("Unable to upload to Splunk.")
    }
}
