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
    stopRecordingButton.isEnabled = false
  }
  
  @IBAction func recordAudio(_ sender: Any) {
    configureUI(isRecording: true)
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))
    print(filePath!)
    
    
    
    
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
    
    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }
  
  @IBAction func stopRecording(_ sender: Any) {
    configureUI(isRecording: false)
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "stopRecording" {
      let playSoundsVC = segue.destination as! PlaySoundsViewController
      let recordedAudioURL = sender as! URL
      playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }
  
  func configureUI(isRecording: Bool) {
    recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
    recordingLabel.textColor = isRecording ? UIColor.red : UIColor.black
    recordButton.isEnabled = isRecording ? false : true
    stopRecordingButton.isEnabled = isRecording ? true : false
  }
}

