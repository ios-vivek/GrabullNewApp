//
//  STSearch.swift
//  STSearch
//
//  Created by Sharda Prasad on 18/07/21.
//

import UIKit
import Speech

public class STSearch: NSObject {

    public let speech_Recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var reco_Task: SFSpeechRecognitionTask?
    private let audio_Engine = AVAudioEngine()

    public var isStop:Bool = false {
        didSet {
            //MARK: STEP-3
            audio_Engine.inputNode.removeTap(onBus: 0)
            audio_Engine.stop()
            request?.endAudio()
        }
    }

    public func initilize(_ StatusC:@escaping (_ status:SFSpeechRecognizerAuthorizationStatus)-> Void) {
        
        //MARK: STEP-1
        speech_Recognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            OperationQueue.main.addOperation() {
                //MARK: STEP-2
                StatusC(authStatus)
            }
        }
    }

    public func isRunning() -> Bool {
        //MARK: STEP-4
        return self.audio_Engine.isRunning
    }
}

extension STSearch : SFSpeechRecognizerDelegate {
    
    public func startSpeechRecording(with speechText:@escaping (_ text:String, _ status:Bool) -> ()) {
        //MARK: STEP-5
        if reco_Task != nil {
            reco_Task?.cancel()
            reco_Task = nil
        }
        //MARK: STEP-6
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audio_Engine.inputNode

        //MARK: STEP-7
        guard let recognitionRequest = request else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true
        //MARK: STEP-7
        reco_Task = speech_Recognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            //MARK: STEP-8
            var isFinal = false
            if result != nil {
                speechText(result?.bestTranscription.formattedString ?? "",(result?.isFinal)!)
                isFinal = (result?.isFinal)!
            }

            //MARK: STEP-10
            if error != nil || isFinal {
                self.audio_Engine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.request = nil
                self.reco_Task = nil
                speechText("",isFinal)
            }
        })
        
        //MARK: STEP-11
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request?.append(buffer)
        }

        //MARK: STEP-12
        audio_Engine.prepare()
        do {
            try audio_Engine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        speechText("",false)
    }
}
