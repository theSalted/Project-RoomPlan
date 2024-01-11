//
//  SpaceObjectViewerView.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/11/24.
//

import SwiftUI

struct SpaceObjectViewerView: View {
    var spaceObjects : [SpaceObject]
    var body: some View {
        List(spaceObjects) { object in
            VStack(alignment: .leading) {
                Text(object.name)
                    .font(.headline)
                Label("Valid roomplanObject", systemImage: "cube")
                    .foregroundStyle(object.roomPlanObject != nil ? .green : .red)
                    .font(.caption)
                if let objectTransform = object.roomPlanObject?.transform {
                    Text(objectTransform.debugDescription)
                        .font(.caption)
                }
                Label("Valid sceneNode", systemImage: "gamecontroller")
                    .foregroundStyle(object.sceneNode != nil ? .green : .red)
                    .font(.caption)
                if let nodeTransform = object.sceneNode?.simdTransform {
                    Text(nodeTransform.debugDescription)
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    SpaceObjectViewerView(spaceObjects: [SpaceObject(name: "Cool")])
}
