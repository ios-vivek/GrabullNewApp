//
//  MicSearchVC.swift
//  GTB DUBAI
//
//  Created by vivek singh on 04/01/23.
//

import UIKit

protocol MicSearchDelegate {
    func searchDone(search: String)
}

class MicSearchVC: UIViewController {
    var delegate: MicSearchDelegate?

    @IBOutlet weak var listeningLbl: UILabel!
    @IBOutlet weak var speachTitleLbl: UILabel!
    @IBOutlet weak var speechview: UIView!
    @IBOutlet weak var showMsgLbl: UILabel!
    let speech = STSearch()
    var timer: Timer?
    var runCount = 0
    var completion: ((String) -> Void)?
    var searchedText: String = ""
    @IBOutlet weak var micSearch: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechInitialize()
        speechview.layer.cornerRadius = 20
        view.isOpaque = false
        setLabels()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
       
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        micSearch.layer.cornerRadius = 13
        micSearch.layer.borderColor = UIColor.red.cgColor
        micSearch.layer.borderWidth = 1
    }

    func setLabels() {
        speachTitleLbl.text = "Hi, I'm listing. Try saying..."
        listeningLbl.text = ""
        showMsgLbl.text = "Tap microphone to try again"
        showMsgLbl.isHidden = true
        runCount = 0
    }

    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        if runCount >= 5 {
            setLabels()
            killTimer()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            self.micAction()
        }
    }

    @objc func fireTimer() {
        print("Timer fired!")
        runCount += 1

        if runCount == 5 {
            killTimer()
            if searchedText.count == 0 {
                speachTitleLbl.text = "Sorry, I didn't get that. Try saying..."
                showMsgLbl.isHidden = false
            }
            let textToPass = self.searchedText
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let self = self else { return }
                self.completion?(textToPass)
                self.stopSpeech()
            }
        }
    }

    func killTimer() {
        timer?.invalidate()
        timer = nil
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        killTimer()
        self.dismiss(animated: true)
    }

    func speechInitialize() {
        speech.initilize { [weak self] authStatus in
            guard let self = self else { return }
            switch authStatus {
            case .authorized:
                print("User access to speech recognition")
                self.micAction()
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Speech recognition restricted on this device")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            @unknown default: break
            }
        }
    }

    func stopSpeech() {
        speech.stop()
        listeningLbl.text = ""
        searchedText = ""
    }

    func micAction() {
        listeningLbl.text = ""
        speachTitleLbl.text = "Hi, I'm listing. Try saying..."
        print("Mic clicked")
        if speech.isRunning() {
            listeningLbl.text = ""
            speech.stop()
        } else {
            speech.startSpeechRecording { [weak self] text, isSuccess in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    print("isSuccessisSuccessisSuccess", text, isSuccess)
                    if text.count > 0 {
                        self.listeningLbl.text = text
                        self.runCount = 0
                        self.searchedText = text
                    }
                    if text.count == 0 {
                        self.listeningLbl.text = ""
                    }
                    if isSuccess {
                        self.listeningLbl.text = ""
                    }
                }
            }
        }
        self.view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopSpeech()
        killTimer()
    }

    deinit {
        speech.stop()
        killTimer()
    }
}
