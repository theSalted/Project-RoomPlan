//
//  RoomCaptureViewModel.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import Combine
import Foundation

class RoomCaptureViewModel: ObservableObject {
    enum Action {
        case startSession
        case export
    }
    
    var actions = PassthroughSubject<Action, Never>();
    let exportUrl = FileManager.default.temporaryDirectory.appending(path: "ScannedSpace.usdz")
    
    @Published var canExport = false
    @Published var showShareSheet = false
    @Published var showRoomViewer = false
}
