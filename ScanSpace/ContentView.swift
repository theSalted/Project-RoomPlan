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
        VStack {
            #if !(canImport(RoomPlan) && targetEnvironment(simulator))
            RoomCaptureRepresentableView(viewModel: roomCaptureViewModel)
                .ignoresSafeArea()
                .onAppear {
                    roomCaptureViewModel.actions
                        .send(.startSession)
                }
            #else
            Text("Room Capture API is not supported on your device.")
                .padding()
            #endif
        }
        .frame(maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            if roomCaptureViewModel.canExport {
                Button {
                    roomCaptureViewModel.actions.send(.export)
                } label: {
                    ButtonLabel(systemName: "square.and.arrow.up")
                }
                .padding()
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
