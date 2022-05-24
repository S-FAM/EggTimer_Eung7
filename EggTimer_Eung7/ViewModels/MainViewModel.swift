//
//  MainViewModel.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import Foundation
import UIKit

struct MainViewModel {
    let food: Food
}

extension MainViewModel {
    var name: String { return food.name }
    var minutes: Int { return food.seconds / 60 }
    var seconds: Int { return food.seconds % 60 }
    var timeString: String {
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}

class MainListViewModel { 
    var mainViewModels: [MainViewModel]
    
    var currentFoodVM: MainViewModel?
    var remainingTime: Int = 0
    var timer = Timer()
    
    init() {
        self.mainViewModels = [
            MainViewModel(food: Food(name: "Runny yolk eggs", seconds: 240)),
            MainViewModel(food: Food(name: "Moist yolk eggs", seconds: 360)),
            MainViewModel(food: Food(name: "Well-done eggs", seconds: 240)),
            MainViewModel(food: Food(name: "Plank", seconds: 180)),
            MainViewModel(food: Food(name: "Cooking Instant Noodle", seconds: 180))
        ]
    }
}

extension MainListViewModel { // View의 로직모음
    func numberOfRowsInSection() -> Int { return mainViewModels.count }
    func removeMainViewModels(_ index: Int) { mainViewModels.remove(at: index) }
    func appendMainViewModels(_ vm: MainViewModel) { mainViewModels.append(vm) }
    
    func didTapPlayButton(_ vm: MainViewModel) {
        timer.invalidate()
        currentFoodVM = vm
        remainingTime = vm.food.seconds
    }
    
    func didTapResetButton(_ vm: MainViewModel, completion: () -> Void) -> String {
        timer.invalidate()
        remainingTime = vm.food.seconds
        let time = TimeTransforming.shared.secondsToMinutesSeconds(vm.food.seconds)
        let timeString = TimeTransforming.shared.stringFromTime(time.0, time.1)
        completion()
        
        return timeString
    }
}

extension MainListViewModel {
    @objc func timerObserver(_ completion: (String) -> Void) {
        if remainingTime > 0 {
            remainingTime -= 1
            let time = TimeTransforming.shared.secondsToMinutesSeconds(remainingTime)
            let timeString = TimeTransforming.shared.stringFromTime(time.0, time.1)
            completion(timeString)
        }
    }
}
