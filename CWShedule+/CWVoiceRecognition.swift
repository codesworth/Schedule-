//
//  ViewController.swift
//  CSpeeches
//
//  Created by Mensah Shadrach on 8/14/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

import UIKit
import Speech
class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private var speechRecognizer = SFSpeechRecognizer(locale:Locale.init(identifier: "en-US"))
    private var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    private var recognitiontask:SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var recordButton: MaterialButtons!
    @IBOutlet weak var speectToTextField: MaterialTextField!
    @IBOutlet weak var welcomeAddressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer?.delegate = self
        speechRecognize()
    }

    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Start Recording", for: .normal)
        }else{
            startRecording()
            recordButton.setTitle("Stop Recording", for: .normal)
        }
        
    }
    
    func speechRecognize(){
        recordButton.isEnabled = false
        SFSpeechRecognizer.requestAuthorization({authStatus in
        var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied: isButtonEnabled = false
                print("User Denied access to microphone use")
            case .restricted: isButtonEnabled = false
                print("Speech recognition is restricted on this device")
                
            case .notDetermined: isButtonEnabled = false
                print("Speech Recognition not yet authorized on device")
            }
            OperationQueue.main.addOperation {
                self.recordButton.isEnabled = isButtonEnabled
            }
        
        
        })
        
        /* First, we create an SFSpeechRecognizer instance with a locale identifier of en-US so the speech recognizer knows what language the user is speaking in. This is the object that handles speech recognition.
         By default, we disable the microphone button until the speech recognizer is activated.
         Then, set the speech recognizer delegate to self which in this case is our ViewController.
         
         After that, we must request the authorization of Speech Recognition by calling SFSpeechRecognizer.requestAuthorization.
         
         Finally, check the status of the verification. If it’s authorized, enable the microphone button. If not, print the error message and disable the microphone button.
         
         */
    }
    
    func startRecording(){
        if recognitiontask != nil{
            recognitiontask?.cancel()
            recognitiontask = nil
            
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch{
            print("Audio Session could not start")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard  let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitiontask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {(result , error) in
                var isFinal = false
            if result != nil{
                self.speectToTextField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitiontask = nil
                self.recognitionRequest = nil
                
                self.recordButton.isEnabled = true
            }
        
        
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, when ) in
                self.recognitionRequest?.append(buffer)
            })
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
        }catch{
            print("audioEngine couldnt start")
        }
        
        speectToTextField.text = "Say something, I'm listening"
        
        //Created By SHADRACH MENSAH
        //CODESWORTH
        
        /*This function is called when the Start Recording button is tapped. Its main function is to start up the speech recognition and start listening to your microphone. Let’s go through the above code line by line:
 
         Line 3-6 – Check if recognitionTask is running. If so, cancel the task and the recognition.
         Line 8-15 – Create an AVAudioSession to prepare for the audio recording. Here we set the category of the session as recording, the mode as measurement, and activate it. Note that setting these properties may throw an exception, so you must put it in a try catch clause.
 
         Line 17 – Instantiate the recognitionRequest. Here we create the SFSpeechAudioBufferRecognitionRequest object. Later, we use it to pass our audio data to Apple’s servers.
 
         Line 19-21 – Check if the audioEngine (your device) has an audio input for recording. If not, we report a fatal error.
 
         Line 23-25 – Check if the recognitionRequest object is instantiated and is not nil.
 
         Line 27 – Tell recognitionRequest to report partial results of speech recognition as the user speaks.
 
         Line 29 – Start the recognition by calling the recognitionTask method of our speechRecognizer. This function has a completion handler. This completion handler will be called every time the recognition engine has received input, has refined its current recognition, or has been canceled or stopped, and will return a final transcript.
 
         Line 31 – Define a boolean to determine if the recognition is final.
 
         Line 35 – If the result isn’t nil, set the textView.text property as our result‘s best transcription. Then if the result is the final result, set isFinal to true.
 
         Line 39-47 – If there is no error or the result is final, stop the audioEngine (audio input) and stop the recognitionRequest and recognitionTask. At the same time, we enable the Start Recording button.
 
         Line 50-53 – Add an audio input to the recognitionRequest. Note that it is ok to add the audio input after starting the recognitionTask. The Speech Framework will start recognizing as soon as an audio input has been added.
 
         Line 55 – Prepare and start the audioEngine.
        */
 
    }
    
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            recordButton.isEnabled = true
        }else{
            recordButton.isEnabled = false
        }
        
        /* This method will be called when the availability changes. If speech recognition is available, the record button will also be enabled. */
    }


    
    
    
    
    
    
    
    
    

    
}

