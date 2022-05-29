//
//  TimerModel.swift
//  Pomodoro
//
//  Created by Victor Surikov on 28.05.2022.
//

import SwiftUI

@MainActor class TimerModel: ObservableObject {
    
    @Published var state = "Ready to start?"
    @Published var toggleButtonTitle = "Start Focus"
    @Published var time = TimeInterval(0)
    @Published var focusNumber = 0
    
    private var storage: StorageProtocol {
        didSet {
            updateState()
        }
    }
    private var timeUpdater: Timer?
    
    init(storage: StorageProtocol) {
        self.storage = storage
        updateState()
    }
    
    func toggleState() {
        switch storage.state.currentMode {
        case .inFocuse:
            storage.state.currentMode = .onBreak
        case .stoped, .onBreak:
            storage.state.currentMode = .inFocuse
        }
    }
    
    func stopFlow() {
        storage.state.currentMode = .stoped
    }
    
    private func updateState() {
        timeUpdater?.invalidate()
        timeUpdater = nil
        focusNumber = storage.state.focusNumber
        switch storage.state.currentMode {
        case .inFocuse:
            state = "Focus"
            toggleButtonTitle = "Start Break"
            startTimeUpdater()
        case .onBreak:
            state = "Break"
            toggleButtonTitle = "Start Focus"
            startTimeUpdater()
        case .stoped:
            state = "Ready to start?"
            toggleButtonTitle = "Start Focus"
            time = storage.timerConfiguration.focusTime
        }
    }
    
    private func startTimeUpdater() {
        timeUpdater = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.2), repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            let interval: TimeInterval
            switch self.storage.state.currentMode {
            case .inFocuse:
                interval = self.storage.timerConfiguration.focusTime
            case .onBreak:
                interval = self.storage.state.focusNumber == 0 ?
                self.storage.timerConfiguration.longBreak :
                self.storage.timerConfiguration.shortBreak
            case .stoped:
                timer.invalidate()
                return
            }
            let time = interval
                + self.storage.state.lastStateUpdate.timeIntervalSince1970
                - Date.now.timeIntervalSince1970
            self.time = time > 0 ? time : 0
        }
    }
}
