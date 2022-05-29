//
//  State.swift
//  Pomodoro
//
//  Created by Victor Surikov on 28.05.2022.
//

import Foundation

struct State {
    enum Mode {
        case inFocuse
        case onBreak
        case stoped
    }
    
    var currentMode: Mode = .stoped {
        didSet {
            guard currentMode != oldValue else { return }
            lastStateUpdate = .now
            switch currentMode {
            case .inFocuse:
                focusNumber += 1
            case .onBreak:
                focusNumber %= 4
            case .stoped:
                focusNumber = 0
            }
        }
    }
    private(set) var lastStateUpdate: Date = .now
    private(set) var focusNumber: Int = 0
}
