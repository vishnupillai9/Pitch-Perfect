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
        stopButton.isHidden = true
        
        audioPlayer = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        
        audioPlayer.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !player.isPlaying {
            // Hide the stop button once playing has finished
            self.stopButton.isHidden = true
        }
    }
    
    func playAudio(_ rateOfPlay: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rateOfPlay
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        if audioPlayer.isPlaying {
            // Show the stop button if audio is being played
            stopButton.isHidden = false
        }
    }
    
    @IBAction func playSlow(_ sender: UIButton) {
        // Play audio at a rate of 0.5
        playAudio(0.5)
    }

    @IBAction func playFast(_ sender: UIButton) {
        // Play audio at a rate of 2.0
        playAudio(2.0)
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        let chipmunkPitchEffect = AVAudioUnitTimePitch()
        chipmunkPitchEffect.pitch = 1000
        
        playAudioWithEffect(chipmunkPitchEffect)
    }
    
    @IBAction func playDarthvaderAudio(_ sender: UIButton) {
        let darthvaderPitchEffect = AVAudioUnitTimePitch()
        darthvaderPitchEffect.pitch = -1000
        
        playAudioWithEffect(darthvaderPitchEffect)
    }
    
    @IBAction func playEchoAudio(_ sender: UIButton) {
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.7
        
        playAudioWithEffect(echoEffect)
    }
    
    @IBAction func playReverbAudio(_ sender: UIButton) {
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.largeRoom)
        reverbEffect.wetDryMix = 70
        
        playAudioWithEffect(reverbEffect)
    }
    
    func playAudioWithEffect(_ effect: NSObject) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changeEffect = effect as! AVAudioNode
        audioEngine.attach(changeEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
        
        if audioPlayerNode.isPlaying {
            stopButton.isHidden = false
            
            _ = Timer.scheduledTimer(timeInterval: audioPlayer.duration, target: self, selector: #selector(PlaySoundsViewController.stopPlay(_:)), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func stopPlay(_ sender: UIButton) {
        stopAudio()
        stopButton.isHidden = true
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
