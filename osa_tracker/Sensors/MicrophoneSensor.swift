//
//  MicrophoneSensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import AVFoundation

class MicrophoneSensor: Sensor, AVAudioRecorderDelegate, AVAudioPlayerDelegate, AudioSensorInterface, SensorInterface {
//    var sensorName: SensorEnumeration
    
    var sampleRate: Int
    var numberOfChannels: Int
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    init() {
//        self.sensorName = .MicrophoneSensor
        self.sampleRate = 0
        self.numberOfChannels = 0
        super.init(sensorEnum: .MicrophoneSensor)
    }
    
    
    init(sessionIdentifier:UUID) {
    //        self.sensorName = .MicrophoneSensor
            self.sampleRate = 0
            self.numberOfChannels = 0
            super.init(sensorEnum: .MicrophoneSensor, sessionIdentifier:sessionIdentifier)
        }
    
    
    override func startSensor() -> Bool {
        print("Will start Microphone")
        self.startRecording()
        return true
    }
    
    override func stopSensor() -> Bool {
        print("Will stop Microphone")
        self.endRecording(success: true)
        return true
    }
    
    override func getNumberOfEvents() -> Int{
        return 0
    }
    
    func startRecording() -> Bool{
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
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(self.sessionIdentifier?.description ?? "recording").m4a")

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
            endRecording(success: false)
        }
        return true
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func pauseRecording() {
        print("Not implemented")
    }
    
    func endRecording(success: Bool) {
        // audioRecorder.stop()
        // audioRecorder = nil

        if success {
            // recordButton.setTitle("Tap to Re-record", for: .normal)
            print("Finished recording!")
        } else {
            // recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
            

    }
    
    func saveRecording(){
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
            endRecording(success: false)
        }
    }
    
}
