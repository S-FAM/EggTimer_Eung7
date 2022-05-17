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
        Food(name: "Runny yolk eggs", time: 4),
        Food(name: "Moist yolk eggs", time: 6),
        Food(name: "Well-done eggs", time: 8),
        Food(name: "Plank", time: 3),
        Food(name: "Cooking Instant Noodle", time: 3),
        Food(name: "Homemade Pizza", time: 7)
    ])
    
    func deleteFromFoods(_ index: Int) {
        var foods = foods.value
        foods.remove(at: index)
        self.foods.accept(foods)
    }
}
