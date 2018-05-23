//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by WilliamCastellano on 5/21/18.
//  Copyright © 2018 WCTech. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
  
  var audioRecorder: AVAudioRecorder!

  @IBOutlet var recordingLabel: UILabel!
  @IBOutlet var recordButton: UIButton!
  @IBOutlet var stopRecordingButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    stopRecordingButton.isEnabled = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func recordAudio(_ sender: Any) {
    recordingLabel.text = "Recording in Progress"
    recordingLabel.textColor = UIColor.red
    recordButton.isEnabled = false
    stopRecordingButton.isEnabled = true
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
    print(filePath)
    
    
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }
  
  @IBAction func stopRecording(_ sender: Any) {
    recordingLabel.text = "Tap to Record"
    recordingLabel.textColor = UIColor.black
    recordButton.isEnabled = true
    stopRecordingButton.isEnabled = false
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    } else {
      print("recording failed")
    }
  }
  
}

