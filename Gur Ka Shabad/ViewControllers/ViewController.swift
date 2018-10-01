//
//  ViewController.swift
//  Speech Recognization
//
//  Created by Admin on 15/09/18.
//  Copyright © 2018 anamcorp. All rights reserved.
//

import UIKit
import Speech
import Alamofire
import SwiftyJSON
import Pulsator

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "hi_IN")) //hi_IN
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var sepratedTextLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    var sepratedText : String = ""
    
    let pulsator = Pulsator()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initSomeSttufs()
        
        askForSpeechRecognizationPermission()
    }
    
    func initSomeSttufs() {
        nextBtn.isHidden = true
        self.nextBtn.layer.masksToBounds = true
        self.nextBtn.layer.borderWidth = 2.0
        self.nextBtn.layer.borderColor = UIColor.black.cgColor
        self.nextBtn.titleLabel?.sizeToFit()
        
        pulsator.position = CGPoint(x: microphoneButton.frame.size.width/2, y: microphoneButton.frame.size.height/2    )
        pulsator.numPulse = 10
        pulsator.radius = microphoneButton.frame.size.height
        microphoneButton.layer.insertSublayer(pulsator, below: microphoneButton.layer)
        
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
    }
    
    func askForSpeechRecognizationPermission() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        if audioEngine.inputNode == nil {
            fatalError("Audio engine has no input node")
        }
        
        let inputNode = audioEngine.inputNode
        
        //        guard let inputNode = audioEngine.inputNode else {
        //            fatalError("Audio engine has no input node")
        //        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionRequest.taskHint = .dictation
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                self.getSepratedTexts(string: self.textView.text)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView.text = "Say something, I'm listening!"
        
    }
    
    func getSepratedTexts(string:String) {
        sepratedText = ""
        sepratedTextLbl.text = ""
        let arr = string.components(separatedBy: " ")
        for str in arr {
            sepratedText = sepratedText + " " + firstEngChar(str: String(describing: str.character(at: 0)!))
            sepratedTextLbl.text = sepratedText
        }
    }
    
    func firstEngChar(str:String) -> String {
        let firstUniScalar = str.unicodeScalars.first!
        for dict in lan_dic {
            if dict["unicode"] == String(firstUniScalar) {
                return dict["char"]!
            }
        }
        return ""
    }
    
    func playSound() {
        
        guard let path = Bundle.main.path(forResource: "warning", ofType:"mp3") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            if player != nil {
                player = nil
            }
            player = try AVAudioPlayer(contentsOf: url)
            player?.stop()
            player?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    @IBAction func drag_outside(_ sender: UIButton) {
        touch_up(sender)
    }
    
    @IBAction func touch_down(_ sender: UIButton) {
        if !NetworkManager.SharedInstance.isReachable {
            self.showAlert(title: "Opps", message: "Please check your internet!")
            return
        }
        playSound()
        nextBtn.isHidden = true
        self.perform(#selector(doStartRecord), with: nil, afterDelay: 0.15)
    }
    
    @objc func doStartRecord() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        startRecording()
        self.textView.text = ""
        sepratedTextLbl.text = ""
        self.nextBtn.setTitle("", for: .normal)
        pulsator.start()
    }
    
    @IBAction func touch_up(_ sender: UIButton) {
        if player != nil {
            player = nil
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        pulsator.stop()
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            
            microphoneButton.isEnabled = false
            
            if sepratedText != "" {
                
                let arr = sepratedText.components(separatedBy: " ")
                var temstr = ""
                for str in arr {
                    temstr = temstr + str
                }
                
                getShabdas(shabadID: temstr)
            }
            
        }
        sepratedText = ""
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    func getShabdas(shabadID:String) {
        showLoader()
        Alamofire.request(URL(string: baseUrl + "search/"  + shabadID + "/?source=G")!, method: .get, parameters : nil)
            .responseJSON { response in
                self.hideLoader()
                switch response.result {
                case .success(let value) :
                    let json = JSON(value)
                    shabadList = json["shabads"].arrayValue
                    self.nextBtn.isHidden = false
                    if shabadList.count > 0 {
                        self.nextBtn.setTitle("View \(shabadList.count) Results", for: UIControlState.normal)
                    } else {
                        self.nextBtn.setTitle("No Results Found", for: UIControlState.normal)
                    }
                    self.printResponseDicionary(response: response)
                    break
                case .failure(let error) :
                    print(error.localizedDescription)
                    break
                }
        }
    }
    
    @IBAction func clk_next(_ sender: UIButton) {
        if shabadList.count > 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShabadVC") as! ShabadVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


