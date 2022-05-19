//
//  NewTaskViewModel.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

class NewTaskViewModel {
    let list = Array<Int>(0...59)
    
    var pickerViewNumberOfRows: Int {
        return list.count
    }
    
    var listToString: [String] {
        return list.map { String($0) }
    }
}
