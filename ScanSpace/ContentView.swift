//
//  ContentView.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/3/24.
//

import SwiftUI
import SwiftData
import SceneKit.ModelIO
import OSLog

struct ContentView: View {
    @StateObject var roomCaptureViewModel = RoomCaptureViewModel()
    @State var modelViewerViewModel = ModelViewerViewModel()
    let logger = Logger(subsystem: ScanSpaceApp.bundleId, category: "ContentView")
    var body: some View {
        VStack {
            #if !(canImport(RoomPlan) && targetEnvironment(simulator))
            RoomCaptureRepresentableView(viewModel: roomCaptureViewModel)
                .ignoresSafeArea()
                .onAppear {
                    roomCaptureViewModel.actions
                        .send(.startSession)
                }
                .sheet(isPresented: $roomCaptureViewModel.showShareSheet) {
                    ActivityViewControllerRepresentable(items: [roomCaptureViewModel.exportUrl])
                }
                .sheet(isPresented: $roomCaptureViewModel.showRoomViewer) {
                    ModelViewerView()
                        .environment(modelViewerViewModel)
                        .onAppear {
                            roomCaptureViewModel.actions.send(.export)
                            let asset = MDLAsset(url: roomCaptureViewModel.exportUrl)
                            asset.loadTextures()
                            let object = asset.object(at: 0)
                            let node = SCNNode(mdlObject: object)
                            modelViewerViewModel.modelNode = node
                        }
                }
            #else
            Text("Room Capture API is not supported on your device.")
                .padding()
            #endif
        }
        .frame(maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            HStack {
                Button {
                    roomCaptureViewModel.actions.send(.share)
                } label: {
                    ButtonLabel(systemName: "square.and.arrow.up")
                }
                .foregroundStyle(.secondary)
                .disabled(!roomCaptureViewModel.canExport)
                
                Button {
                    withAnimation {
                        roomCaptureViewModel.showRoomViewer = true
                    }
                } label: {
                    ButtonLabel(systemName: "cube")
                }
                .foregroundStyle(.secondary)
            }
            .padding()
            
        }
    }
}

#Preview {
    ContentView()
}

