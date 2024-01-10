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
            VStack {
                Text(object.name)
                    .font(.headline)
                Label("Valid roomplanObject", image: "cube")
                    .foregroundStyle(object.roomPlanObject != nil ? .green : .red)
                Label("Valid sceneNode", image: "gamecontroller")
                    .foregroundStyle(object.sceneNode != nil ? .green : .red)
            }
        }
    }
}

#Preview {
    SpaceObjectViewerView(spaceObjects: [SpaceObject(name: "Cool")])
}
