//
//  PlaySoundsViewController.swift
//  PitchPerfectV2
//
//  Created by diego prats on 11/28/15.
//  Copyright © 2015 diego prats. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this was added so tit plays louder on iphone
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.Speaker)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)

        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    @IBAction func slowButtonPressed(sender: AnyObject) {
        
        audioPlayer.enableRate  = true
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func fastButtonPressed(sender: AnyObject) {
        audioPlayer.enableRate  = true
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
   

    @IBAction func stopButtonPressed(sender: AnyObject) {
         audioPlayer.stop()
    }
    
    @IBAction func chipmunkButtonPressed(sender: AnyObject) {

        playAudioWithVariablePitch(1000)
        
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
        
    }
    
    

}
