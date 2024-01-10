//
//  RoomCaptureViewModel.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import Combine
import Foundation
import RoomPlan

class RoomCaptureViewModel: ObservableObject {
    enum Action {
        case startSession
        case share
        case export
    }
    
    var actions = PassthroughSubject<Action, Never>();
    let exportUrl = FileManager.default.temporaryDirectory.appending(path: "ScannedSpace.usdz")
    let metadataUrl = FileManager.default.temporaryDirectory.appending(path: "ScannedSpace.json")
    
    @Published var canExport = false
    @Published var showShareSheet = false
    @Published var showRoomViewer = false
    @Published var capturedRoom: CapturedRoom?
}


extension CapturedRoom : Equatable {
    public static func == (lhs: CapturedRoom, rhs: CapturedRoom) -> Bool {
        return lhs.objects == rhs.objects
    }
}

extension CapturedRoom.Object : Equatable {
    public static func == (lhs: CapturedRoom.Object, rhs: CapturedRoom.Object) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.transform == rhs.transform && lhs.dimensions == rhs.dimensions  
    }
}
