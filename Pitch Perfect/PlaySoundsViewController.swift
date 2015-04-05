//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Vishnu on 17/01/15.
//  Copyright (c) 2015 Demons. All rights reserved.
//

import UIKit

import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide stop button when view loads
        stopButton.hidden = true
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if !player.playing {
            //Hide the stop button once playing has finished
            self.stopButton.hidden = true
        }
    }
    
    func playAudio(rateOfPlay: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rateOfPlay
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        if audioPlayer.playing {
            //Show the stop button if audio is being played
            stopButton.hidden = false
        }
    }
    
    @IBAction func playSlow(sender: UIButton) {
        //Play audio at a rate of 0.5
        playAudio(0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        //Play audio at a rate of 2.0
        playAudio(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch (pitch:Float) {
        
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
        if audioPlayerNode.playing {
            stopButton.hidden = false
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(audioPlayer.duration, target: self, selector: "stopPlay:", userInfo: nil, repeats: false)
        }
        
        
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        stopAudio()
        stopButton.hidden = true
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
