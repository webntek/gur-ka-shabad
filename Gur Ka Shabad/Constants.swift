//
//  Constants.swift
//  Speech Recognization
//
//  Created by Admin on 18/09/18.
//  Copyright © 2018 anamcorp. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVFoundation

var alert : UIAlertController? = nil

let baseUrl : String = "https://api.gurbaninow.com/v2/"

var shabadList : [JSON] = []

var player: AVAudioPlayer?

let lan_dic = [["unicode" : "\u{0915}", "char" : "k", "hin" : "क"],
               ["unicode" : "\u{0916}", "char" : "k", "hin" : "ख"],
               ["unicode" : "\u{0917}", "char" : "g", "hin" : "ग"],
               ["unicode" : "\u{0919}", "char" : "n", "hin" : "ङ"],
               ["unicode" : "\u{091A}", "char" : "c", "hin" : "च"],
               ["unicode" : "\u{091B}", "char" : "c", "hin" : "छ"],
               ["unicode" : "\u{091C}", "char" : "j", "hin" : "ज"],
               ["unicode" : "\u{091D}", "char" : "j", "hin" : "झ"],
               ["unicode" : "\u{091E}", "char" : "n", "hin" : "ञ"],
               ["unicode" : "\u{091F}", "char" : "t", "hin" : "ट"],
               ["unicode" : "\u{0920}", "char" : "t", "hin" : "ठ"],
               ["unicode" : "\u{0921}", "char" : "d", "hin" : "ड"],
               ["unicode" : "\u{0922}", "char" : "d", "hin" : "ढ"],
               ["unicode" : "\u{0923}", "char" : "n", "hin" : "ण"],
               ["unicode" : "\u{0924}", "char" : "t", "hin" : "त"],
               ["unicode" : "\u{0925}", "char" : "t", "hin" : "थ"],
               ["unicode" : "\u{0926}", "char" : "d", "hin" : "द"],
               ["unicode" : "\u{0927}", "char" : "d", "hin" : "ध"],
               ["unicode" : "\u{0928}", "char" : "n", "hin" : "न"],
               ["unicode" : "\u{0929}", "char" : "n", "hin" : "ऩ"],
               ["unicode" : "\u{092A}", "char" : "p", "hin" : "प"],
               ["unicode" : "\u{092B}", "char" : "p", "hin" : "फ"],
               ["unicode" : "\u{092C}", "char" : "b", "hin" : "ब"],
               ["unicode" : "\u{092D}", "char" : "b", "hin" : "भ"],
               ["unicode" : "\u{092E}", "char" : "m", "hin" : "म"],
               ["unicode" : "\u{092F}", "char" : "y", "hin" : "य"],
               ["unicode" : "\u{0930}", "char" : "r", "hin" : "र"],
               ["unicode" : "\u{0931}", "char" : "r", "hin" : "ऱ"],
               ["unicode" : "\u{0932}", "char" : "l", "hin" : "ल"],
               ["unicode" : "\u{0933}", "char" : "l", "hin" : "ळ"],
               ["unicode" : "\u{0934}", "char" : "l", "hin" : "ऴ"],
               ["unicode" : "\u{0935}", "char" : "v", "hin" : "व"],
               ["unicode" : "\u{0936}", "char" : "s", "hin" : "श"],
               ["unicode" : "\u{0937}", "char" : "s", "hin" : "ष"],
               ["unicode" : "\u{0938}", "char" : "s", "hin" : "स"],
               ["unicode" : "\u{0939}", "char" : "h", "hin" : "ह"],
               ["unicode" : "\u{0958}", "char" : "q", "hin" : "क़"],
               ["unicode" : "\u{0959}", "char" : "k", "hin" : "ख़"],
               ["unicode" : "\u{095A}", "char" : "g", "hin" : "ग़"],
               ["unicode" : "\u{095B}", "char" : "z", "hin" : "ज़"],
               ["unicode" : "\u{095C}", "char" : "d", "hin" : "ड़"],
               ["unicode" : "\u{095D}", "char" : "r", "hin" : "ढ़"],
               ["unicode" : "\u{095E}", "char" : "f", "hin" : "फ़"],
               ["unicode" : "\u{095F}", "char" : "y", "hin" : "य़"],
               ["unicode" : "\u{0960}", "char" : "r", "hin" : "ॠ"],
               ["unicode" : "\u{0961}", "char" : "l", "hin" : "ॡ"],
               ["unicode" : "\u{0962}", "char" : "l", "hin" : " ॢ"],
               ["unicode" : "\u{0963}", "char" : "l", "hin" : " ॣ"],
]
