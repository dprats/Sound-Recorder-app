//
//  RecordSoundsViewController.swift
//  PitchPerfectV2
//
//  Created by diego prats on 11/28/15.
//  Copyright © 2015 diego prats. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    
    //empty file for the model created in the swift file
    var recordedAudio:RecordedAudio!
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    

    //Functions for Views

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.hidden = true
        stopButton.hidden = true
        
        
    }
    
    //Functions for the buttons
    
    
    @IBAction func recordButtonPressed(sender: AnyObject) {
        recordingLabel.hidden = false
        recordingLabel.text = "Recording"
        stopButton.hidden = false
        
        //functions for recording
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
     
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
     
    }
    
    //invoked when the audio is finished recording (allowed because this class is a delegate of AVAudio)
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag){
            //Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent

            //perform segue to the next scene
            
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier=="stopRecording"){
            
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
            
        }
        
    }
    
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        recordingLabel.hidden = false

        recordingLabel.text = "Stopped"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

 

}
