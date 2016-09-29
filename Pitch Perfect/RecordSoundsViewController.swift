//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Vishnu on 16/01/15.
//  Copyright (c) 2015 Demons. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
        recordButton.isEnabled = true
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        stopButton.isHidden = false
        recordingInProgress.text = "recording"
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let path = dirPath + recordingName
        let filePath = URL(fileURLWithPath: path)
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        // Initiliaze and prepare the recorder
        audioRecorder = try? AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag) {
            // Perform segue if the audio recorded has successfully finished recording
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }
        else {
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare for segue: passing the recorded audio file from this vc to the play sounds vc
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecordAudio(_ sender: UIButton) {
        recordingInProgress.text = "Tap to record"
        recordButton.isEnabled = false
        
        // Stop recording the user's voice
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
}

