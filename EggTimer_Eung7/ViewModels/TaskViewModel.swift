//
//  NewTaskViewModel.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

class TaskViewModel {
    let pickerViewlist = Array<Int>(0...59)
    
    var name: String?
    var minutes: Int?
    var seconds: Int?
}

// MARK: PickerView
extension TaskViewModel {
    var numberOfRowsInComponent: Int { return pickerViewlist.count }
    var numberOfComponents: Int { return 1 }
    var titleForRow: [String] { return pickerViewlist.map { String($0) }}
}

extension TaskViewModel {
    func didTapConfirmButton(_ text: String, minutes: Int, seconds: Int) -> MainViewModel {
        let seconds = TimeManager.shared.minutesSecondsToSeconds(minutes, seconds)
        return MainViewModel(food: Food(name: text, seconds: seconds))
    }
}
