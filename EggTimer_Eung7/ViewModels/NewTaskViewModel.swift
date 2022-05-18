//
//  NewTaskViewModel.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

import RxSwift
import RxCocoa

class NewTaskViewModel {
    let list = Array<Int>(0...59)
    
    var pickerViewNumberOfRows: Int {
        return list.count
    }
    
    var listToString: [String] {
        return list.map { String($0) }
    }
    
    func minutesSecondsToSeconds(_ minute: Int, _ seconds: Int) -> Int {
        return (minute * 60) + seconds
    }
}
