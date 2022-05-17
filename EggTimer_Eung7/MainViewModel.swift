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
    
    let eggs = BehaviorSubject<[Something]>(value: [
        Something(name: "Runny yolk eggs", time: 4),
        Something(name: "Moist yolk eggs", time: 6),
        Something(name: "Well-done eggs", time: 8),
        Something(name: "Plank", time: 3),
        Something(name: "Cooking Instant Noodle", time: 3),
        Something(name: "Homemade Pizza", time: 7)
    ])
}
