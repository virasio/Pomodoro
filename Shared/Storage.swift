//
//  Storage.swift
//  Pomodoro
//
//  Created by Victor Surikov on 29.05.2022.
//

import Foundation

protocol StorageProtocol {
    var state: State { get set }
    var timerConfiguration: TimerConfiguration { get set }
}

struct Storage: StorageProtocol {
    var state = State()
    var timerConfiguration = TimerConfiguration()
}
