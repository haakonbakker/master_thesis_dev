//
//  SessionController.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

// This class will handle the most that has to controlling getting the session data

class SessionController : NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var currentSession:Session?
    
    override init() {
        super.init()
    }
    
    func getSessions() -> [Session]{
        let sessions = [Session(id:0), Session(id:1), Session(id:2)]
        
        return sessions
    }
    
    
    func endSession(){
        self.finishRecording(success: true)
    }
    
    func startSession() -> Session{
        print("Will start the session")
        currentSession = Session(id:3)
        
//        guard let name = nameField.text else {
//            show("No name to submit")
//            return
//        }
        guard currentSession != nil else {
            print("No active session")
            return Session(id:-1)
        }
        
        initSession(session:currentSession!)
        return currentSession!
    }
    
    func initSession(session:Session){
        let ableToStart = startAudioRecording(sessionID:session.id)
        print("Phone is able to start recording: \(ableToStart)")
    }
    
    func startAudioRecording(sessionID:Int) -> Bool{
//        Will start to record audio
        recordingSession = AVAudioSession.sharedInstance()
        var allowedToRecord = false // Until proven true
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
//          Ask for user permission to get the recording
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                allowedToRecord = allowed
            }
        } catch {
            // failed to record!
        }
        
        if(!allowedToRecord){
            return false
        }
        
//        Now we are ready to start the recording
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("Recording audio")
//            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
        return true
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
//        audioRecorder = nil

        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
            print("Finished recording!")
        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
        

    }
    
    func playRecordedAudio(){
        print("Will play the audio")
        //        Trying to play the audio
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: .spokenAudio, options: .allowBluetooth)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("error.")
        }
        
        if audioRecorder?.isRecording == false{

            var error : NSError?
            do {
                let player = try AVAudioPlayer(contentsOf: audioRecorder!.url)
                 audioPlayer = player
             } catch {
                 print(error)
             }

            audioPlayer?.delegate = self

            if let err = error{
                print("audioPlayer error: \(err.localizedDescription)")
            }else{
                audioPlayer?.play()
            }
        }
    }
    
    func saveRecordedAudio(){
        print("Will save the audio")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing audio")
    }

    private func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    func getSessionDurationString(session:Session) -> String {
        if(session.hasEnded){
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar
                .dateComponents([.day, .hour, .minute, .second],
                                from: session.start_time,
                                to: session.end_time)
            return String(format: "%02dh:%02dm:%02ds",
                          components.hour ?? 00,
                          components.minute ?? 00,
                          components.second ?? 00)
        }else{
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar
                .dateComponents([.day, .hour, .minute, .second],
                                from: session.start_time,
                                to: Date())
            return String(format: "%02dh:%02dm:%02ds",
                          components.hour ?? 00,
                          components.minute ?? 00,
                          components.second ?? 00)
        }
        
    }

}

class Session:Identifiable{
    var id:Int
    var timestamp:String
    var duration:String
    var start_time:Date
    var end_time:Date
    var hasEnded:Bool
    
    init(id:Int){
        self.id = id
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = Date()
        self.hasEnded = false
    }
    
    
}
