//
//  ContentView.swift
//  Shared
//
//  Created by Victor Surikov on 28.05.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = TimerModel(storage: Storage())
    
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(model.state)
            Text(formatter.string(from: model.time) ?? "")
            Text("Focus period number: \(model.focusNumber)")
            
            HStack {
                Button(model.toggleButtonTitle) { model.toggleState() }
                    .padding()
                Button("Stop Flow") { model.stopFlow() }
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
