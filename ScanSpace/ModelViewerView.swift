//
//  ModelViewerView.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import SwiftUI
import SceneKit
import OSLog

@Observable
class ModelViewerViewModel {
    private let logger = Logger(subsystem: ScanSpaceApp.bundleId, category: "ModelViewerViewModel")
    let scene : SCNScene? = sceneSetup()
    private var _modelNode : SCNNode?
    var modelNode : SCNNode? {
        get { _modelNode }
        set {
            _modelNode?.removeFromParentNode()
            _modelNode  = newValue
            if _modelNode != nil {
                scene?.rootNode.addChildNode(_modelNode!)
                logger.info("Added modelNode to scene")
            }
        }
    }
    
    init() {
//        scene?.rootNode.addChildNode(model)
    }
    
    static func templateCube() -> SCNNode {
        let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
        let cube = SCNNode(geometry: boxGeometry)
        return cube
    }
    
    static func sceneSetup() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.secondarySystemGroupedBackground
        return scene
    }
}


struct ModelViewerView: View {
    @Environment(ModelViewerViewModel.self) var viewModel : ModelViewerViewModel
    
    var body: some View {
        if let scene = viewModel.scene {
            SceneView(scene: scene,
                      options: [.allowsCameraControl, .autoenablesDefaultLighting],
                      antialiasingMode: .multisampling2X)
            
            .ignoresSafeArea()
        } else {
            Text("Couldn't view model")
        }
        
    }
}

#Preview {
    ModelViewerView()
        .environment(ModelViewerViewModel())
}
