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
    var delegate : MicSearchDelegate?

    @IBOutlet weak var listeningLbl: UILabel!
    @IBOutlet weak var speachTitleLbl: UILabel!
    @IBOutlet weak var speechview : UIView!
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
        // Do any additional setup after loading the view.
        view.isOpaque = false
        setLabels()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) //UIColor.whiteColor().colorWithAlphaComponent(0.5)
       
        let micTap = UITapGestureRecognizer(target: self, action: #selector(micTapAction(tapGestureRecognizer:)))
        micSearch.addGestureRecognizer(micTap)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        micSearch.layer.cornerRadius = 13
        micSearch.layer.borderColor = UIColor.red.cgColor
        micSearch.layer.borderWidth = 1

    }
    func setLabels(){
        speachTitleLbl.text = "Hi, I'm listing. Try saying..."
        listeningLbl.text = ""
        showMsgLbl.text = "Tap microphone to try again"
        showMsgLbl.isHidden = true
        runCount = 0
       
    }
    @objc func micTapAction(tapGestureRecognizer: UITapGestureRecognizer? = nil) {
        if runCount >= 5{
            setLabels()
            // handling code
            timer?.fire()
            self.micAction();
        }
    }
    @objc func fireTimer() {
        print("Timer fired!")
        runCount += 1

        if runCount == 5 {
            //timer?.invalidate()
            if searchedText.count == 0{
                speachTitleLbl.text = "Sorry, I didn't get that. Try saying..."
                showMsgLbl.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                completion?(self.searchedText)
                stopSpeech()
                //self.delegate?.searchDone(search: "abc")
                    }
        }
    }
    func killTimer(){
        timer?.invalidate()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        killTimer()
        self.dismiss(animated: true);
    }
    func speechInitialize(){
    speech.initilize { authStatus in
        
        switch authStatus {
        case .authorized:
            print("User access to speech recognition")
            self.micAction();
            break
        case .denied:
            print("User denied access to speech recognition")
            break
        case .restricted:
            print("Speech recognition restricted on this device")
            break
        case .notDetermined:
            print("Speech recognition not yet authorized")
            break
        @unknown default: break
            
        }
    }
    }
    func stopSpeech(){
        if speech.isRunning() {
            speech.isStop = true
        }
        listeningLbl.text = ""
        searchedText = ""
       // speechBtn.isSelected = false
    }
    func micAction(){
        
       // sender.isSelected.toggle()
        listeningLbl.text = ""
        speachTitleLbl.text = "Hi, I'm listing. Try saying..."
       print("Mic clicked")
            if speech.isRunning() {
                listeningLbl.text = ""
                speech.isStop = true
            } else {
                speech.startSpeechRecording { text, isSuccess in
                    DispatchQueue.main.async {
                       // self.listeningLbl.text = (isSuccess != 0) ? "" : "Listening....."
                        print("isSuccessisSuccessisSuccess",text,isSuccess)
                        if (text.count > 0) {
                            //self.searchTextField?.text = text
                            //self.searchTextField?.textColor = .black
                            self.listeningLbl.text = text
                            self.runCount = 0
                            self.searchedText = text
                        }
                        if text.count == 0{
                            self.listeningLbl.text = ""
                        }
                        if isSuccess{
                            //sender.isSelected = false
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
