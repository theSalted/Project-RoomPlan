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
import RoomPlan

struct ContentView: View {
    @StateObject var roomCaptureViewModel = RoomCaptureViewModel()
    @State var modelViewerViewModel = ModelViewerViewModel()
    @State var showSpaceObjectViewer = false
    @State var showTransformView = false
    @State var captureTransforms = [simd_float4x4]()
    @State var nodeTransforms = [simd_float4x4]()
    @State var spaceObjects = [SpaceObject]()
    
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
//                        .onChange(of: roomCaptureViewModel.capturedRoom) {
//                            roomCaptureViewModel.actions.send(.export)
//                            let asset = MDLAsset(url: roomCaptureViewModel.exportUrl)
//                            asset.loadTextures()
//                            let object = asset.object(at: 0)
//                            let node = SCNNode(mdlObject: object)
//                            modelViewerViewModel.modelNode = node
//                        }
                        .onAppear {
                            roomCaptureViewModel.actions.send(.export)
                            let asset = MDLAsset(url: roomCaptureViewModel.exportUrl)
                            asset.loadTextures()
                            let object = asset.object(at: 0)
                            let node = SCNNode(mdlObject: object)
                            modelViewerViewModel.modelNode = node
                        }
                }
                .sheet(isPresented: $showSpaceObjectViewer) {
                    SpaceObjectViewerView(spaceObjects: spaceObjects)
                        .onAppear {
                            guard let childNodes = modelViewerViewModel.modelNode?.childNodes,
                                  let objectNodes = childNodes.filter({ $0.name == "Mesh_grp"}).first?.childNodes.filter({ $0.name == "Object_grp"}),
                                  let roomplanObjects = roomCaptureViewModel.capturedRoom?.objects
                            else {
                                return
                            }
                            
                            let nodeObjectPairs = pairClosestNodesObjects(nodes: objectNodes, objects: roomplanObjects)
                            
                            spaceObjects = nodeObjectPairs.map{
                                SpaceObject(roomPlanObject: $0.1, sceneNode: $0.0)
                            }
                        }
                }
                .sheet(isPresented: $showTransformView) {
                    VStack {
                        Text("Capture")
                        TransformsViewer(simdTransforms: captureTransforms)
                        Text("Node")
                        TransformsViewer(simdTransforms: nodeTransforms)
                    }
                    .onAppear {
                        guard let childNodes = modelViewerViewModel.modelNode?.childNodes else {
                            return
                        }
                        let meshNodes = childNodes.filter { $0.name == "Mesh_grp" }
                        let objectNodes = meshNodes.first!.childNodes.filter { $0.name == "Object_grp"}
                        var flattenedNodes = [SCNNode]()
                        flattenNodes(from: objectNodes, to: &flattenedNodes)
                        
                        flattenedNodes = flattenedNodes.filter {
                            let isGroup = $0.name?.contains("grp") ?? false
                            return !isGroup
                        }
                        
                        nodeTransforms = flattenedNodes.map { $0.simdTransform }
                        guard let objects = roomCaptureViewModel.capturedRoom?.objects else {
                            return
                        }
                        captureTransforms = objects.map { $0.transform }
                        
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
                
                Button {
                    withAnimation {
                       showSpaceObjectViewer = true
                    }
                } label: {
                    ButtonLabel(systemName: "heart")
                }
                .foregroundStyle(.secondary)
                
                Button {
                    withAnimation {
                       showTransformView = true
                    }
                } label: {
                    ButtonLabel(systemName: "star")
                }
                .foregroundStyle(.secondary)
            }
            .padding()
            
        }
    }
}

func flattenNodes(from input: [SCNNode], to output: inout [SCNNode]) {
    for node in input {
        output.append(node)
        if !node.childNodes.isEmpty {
            flattenNodes(from: node.childNodes, to: &output)
        }
    }
}

#Preview {
    ContentView()
}
