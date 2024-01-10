//
//  RoomObjectsView.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/10/24.
//

import SwiftUI
import RoomPlan

struct RoomObjectsView: View {
    var objects : [CapturedRoom.Object]
    var body: some View {
        List(objects) { object in
            Text(object.identifier.description)
        }
    }
}

extension CapturedRoom.Object : Identifiable {
    public var id: UUID {
        identifier
    }
}
