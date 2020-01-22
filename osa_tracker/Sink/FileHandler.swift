//
//  FileHandler.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 13/10/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class FileHandler {
    init() {
        
    }
    
    func writeFile(filename:String, contents:String) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(filename)
            //writing
            do {
                try contents.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Session data written to: \(fileURL)")
            }
            catch {
                fatalError("Unable to write to file")
            }
        }
        return true
    }
    
    /**
     Returns the fileUrl of the file
    */
    func write_file(filename:String, contents:String) -> URL? {
        var fileURL:URL
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            fileURL = dir.appendingPathComponent(filename)
            //writing
            do {
                try contents.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Session data written to: \(fileURL)")
                return fileURL
            }
            catch {
                fatalError("Unable to write to file")
            }
            
        }
        return nil
    }
}
