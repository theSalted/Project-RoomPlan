//
//  ModelViewerView.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import SwiftUI
import SceneKit

@Observable
class ModelViewerViewModel {
    let scene : SCNScene? = sceneSetup()
    var model : SCNNode = templateCube()
    
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
        scene.background.contents = UIColor.lightGray
        
//        let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
//        let cube = SCNNode(geometry: boxGeometry)
//        scene.rootNode.addChildNode(cube)
//        
//        let actionX = SCNAction.rotate(by: 2 * .pi, around: SCNVector3(1, 0, 0), duration: 5.0)
//        let actionY = SCNAction.rotate(by: 2 * .pi, around: SCNVector3(0, 1, 0), duration: 5.0)
//        let actionZ = SCNAction.rotate(by: 2 * .pi, around: SCNVector3(0, 0, 1), duration: 5.0)
//        
//        let scale = SCNAction.sequence([SCNAction.scale(by: 0.5, duration: 2.5),
//                                        SCNAction.scale(by: 2.0, duration: 2.5)])
//        
//        let group = SCNAction.group([scale, actionX, actionY, actionZ])
//        
//        cube.runAction(SCNAction.repeatForever(group))
        return scene
    }
}


struct ModelViewerView: View {
    @Environment(ModelViewerViewModel.self) var viewModel : ModelViewerViewModel
    
    var body: some View {
        if let scene = viewModel.scene {
            SceneView(scene: scene,
                      options: [.allowsCameraControl],
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
