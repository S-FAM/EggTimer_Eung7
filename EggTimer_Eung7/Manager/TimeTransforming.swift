//
//  TimeManager.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/22.
//

import Foundation

class TimeTransforming {
    static let shared = TimeTransforming()
}

extension TimeTransforming {
    func stringFromTime(_ minute: Int, _ seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", minute)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }
    
    func minutesSecondsToSeconds(_ minute: Int, _ seconds: Int) -> Int {
        return (minute * 60) + seconds
    }
}
