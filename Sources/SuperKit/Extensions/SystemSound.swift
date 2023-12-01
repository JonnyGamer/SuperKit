//
//  Sound.swift
//
//
//  Created by Bob Pappas on 12/1/23.
//

import AudioToolbox

public struct Sound {
    public static func play(_ sound: String) {
        SystemSoundID.playFileNamed(fileName: sound, withExtenstion: "mp3")
    }
}

extension SystemSoundID {
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}
