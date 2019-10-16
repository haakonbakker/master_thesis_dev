//
//  CloudHandler.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 16/10/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import CloudKit

class CloudHandler{
    init(){
        print("Initialized the CloudHandler class")
    }
    
    /**
    The upload_text function will upload data to iCloud. THIS FUNCTION UPLOADS TO THE PUBLIC CLOUD.
     */
    func upload_text(sessionIdentifier:String, text:String){
        let fh = FileHandler()
        let fileUrl = fh.write_file(filename: "test.txt", contents: text)
        if let fileURL = fileUrl{
            
            
            
            let sessionRecord = CKRecord(recordType: "Session")
            sessionRecord["session"] = sessionIdentifier as CKRecordValue

            let sessionURL = fileURL
            let sessionAsset = CKAsset(fileURL: sessionURL)
            sessionRecord["eventData"] = sessionAsset
            
            sessionRecord["sessionIdentifier"] = sessionIdentifier
        
            
            
            CKContainer.default().publicCloudDatabase.save(sessionRecord) { [unowned self] record, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        print("Done!")
                        print(record)
                    }
                }
            }
        }
        
    }
}
