//
//  MainViewModel.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

class MainViewModel {
    var reloadCompletion: () -> Void = {}
    var foods: [Food] = [
        Food(name: "Runny yolk eggs", seconds: 240),
        Food(name: "Moist yolk eggs", seconds: 360),
        Food(name: "Well-done eggs", seconds: 240),
        Food(name: "Plank", seconds: 180),
        Food(name: "Cooking Instant Noodle", seconds: 180)
    ] {
        didSet {
            reloadCompletion()
        }
    }

    func createFood(_ name: String, minutes: Int, seconds: Int) -> Food {
        let seconds = minutesSecondsToSeconds(minutes, seconds)
        return Food(name: name, seconds: seconds)
    }
    
    func removeFood(_ index: Int) {
        foods.remove(at: index)
    }
    
    func addFood(_ food: Food) {
        foods.append(food)
    }
    
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
