//
//  ContentView.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var roomCaptureViewModel = RoomCaptureViewModel()
    
    var body: some View {
        #if !(canImport(RoomPlan) && targetEnvironment(simulator))
        ZStack {
            Text("Something went wrong while trying load this room capture experience.")
            RoomCaptureRepresentableView(viewModel: roomCaptureViewModel)
                .ignoresSafeArea()
                .onAppear {
                    roomCaptureViewModel.actions
                        .send(.startSession)
                }
        }
        #else
        Text("Room Capture API is not supported on your device.")
            .padding()
        #endif
    }
}

#Preview {
    ContentView()
}
