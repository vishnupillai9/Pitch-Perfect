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
        
        // Hide stop button when view loads
        stopButton.hidden = true
        
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioPlayer.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if !player.playing {
            // Hide the stop button once playing has finished
            self.stopButton.hidden = true
        }
    }
    
    func playAudio(rateOfPlay: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rateOfPlay
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        if audioPlayer.playing {
            // Show the stop button if audio is being played
            stopButton.hidden = false
        }
    }
    
    @IBAction func playSlow(sender: UIButton) {
        // Play audio at a rate of 0.5
        playAudio(0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        // Play audio at a rate of 2.0
        playAudio(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        let chipmunkPitchEffect = AVAudioUnitTimePitch()
        chipmunkPitchEffect.pitch = 1000
        
        playAudioWithEffect(chipmunkPitchEffect)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        let darthvaderPitchEffect = AVAudioUnitTimePitch()
        darthvaderPitchEffect.pitch = -1000
        
        playAudioWithEffect(darthvaderPitchEffect)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.7
        
        playAudioWithEffect(echoEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.LargeRoom)
        reverbEffect.wetDryMix = 70
        
        playAudioWithEffect(reverbEffect)
    }
    
    func playAudioWithEffect(effect: NSObject) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeEffect = effect as! AVAudioNode
        audioEngine.attachNode(changeEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
        
        if audioPlayerNode.playing {
            stopButton.hidden = false
            
            _ = NSTimer.scheduledTimerWithTimeInterval(audioPlayer.duration, target: self, selector: "stopPlay:", userInfo: nil, repeats: false)
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
