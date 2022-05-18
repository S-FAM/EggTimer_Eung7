//
//  MainViewModel.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import RxSwift
import RxCocoa

class MainViewModel {
    let disposeBag = DisposeBag()
    
    let foods = BehaviorRelay<[Food]>(value: [
        Food(name: "Runny yolk eggs", seconds: 240),
        Food(name: "Moist yolk eggs", seconds: 360),
        Food(name: "Well-done eggs", seconds: 240),
        Food(name: "Plank", seconds: 180),
        Food(name: "Cooking Instant Noodle", seconds: 180)
    ])
    
    func deleteFromFoods(_ index: Int) {
        var foods = foods.value
        foods.remove(at: index)
        self.foods.accept(foods)
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
}
