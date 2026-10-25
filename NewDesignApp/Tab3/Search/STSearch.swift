//
//  STSearch.swift
//  STSearch
//
//  Created by Sharda Prasad on 18/07/21.
//

import UIKit
import Speech
import AVFoundation

public class STSearch: NSObject {

    public let speech_Recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var reco_Task: SFSpeechRecognitionTask?
    private let audio_Engine = AVAudioEngine()

    public var isStop: Bool = false {
        didSet {
            stop()
        }
    }

    public func stop() {
        if audio_Engine.isRunning {
            audio_Engine.stop()
        }
        audio_Engine.inputNode.removeTap(onBus: 0)
        audio_Engine.reset()
        request?.endAudio()
        request = nil
        reco_Task?.cancel()
        reco_Task = nil

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
    }

    public func initilize(_ StatusC: @escaping (_ status: SFSpeechRecognizerAuthorizationStatus) -> Void) {
        //MARK: STEP-1
        speech_Recognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                //MARK: STEP-2
                StatusC(authStatus)
            }
        }
    }

    public func isRunning() -> Bool {
        //MARK: STEP-4
        return self.audio_Engine.isRunning
    }

    deinit {
        stop()
    }
}

extension STSearch: SFSpeechRecognizerDelegate {
    
    public func startSpeechRecording(with speechText: @escaping (_ text: String, _ status: Bool) -> Void) {
        // Stop any previous recording and safely remove existing tap
        stop()

        guard let recognizer = speech_Recognizer, recognizer.isAvailable else {
            print("Speech recognizer is not available")
            speechText("", false)
            return
        }

        //MARK: Configure Audio Session
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error: \(error)")
        }

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        self.request = recognitionRequest

        let inputNode = audio_Engine.inputNode
        inputNode.removeTap(onBus: 0) // Defensive: ensure no existing tap on bus 0

        reco_Task = recognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let self = self else { return }
            var isFinal = false
            if let result = result {
                isFinal = result.isFinal
                speechText(result.bestTranscription.formattedString, isFinal)
            }

            if error != nil || isFinal {
                self.stop()
                speechText("", isFinal)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        guard recordingFormat.sampleRate > 0 && recordingFormat.channelCount > 0 else {
            print("Invalid recording format: \(recordingFormat)")
            self.stop()
            speechText("", false)
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
            self?.request?.append(buffer)
        }

        audio_Engine.prepare()
        do {
            try audio_Engine.start()
        } catch {
            print("audioEngine couldn't start because of an error: \(error)")
            self.stop()
            speechText("", false)
            return
        }
        speechText("", false)
    }
}
