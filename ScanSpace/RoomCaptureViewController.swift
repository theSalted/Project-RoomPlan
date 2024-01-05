//
//  RoomCaptureViewController.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import Combine
import RoomPlan
import SwiftUI
import UIKit
import OSLog

class RoomCaptureViewController: UIViewController {
    private let logger = Logger(subsystem: ScanSpaceApp.bundleId, category: "RoomCaptureViewController")
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: RoomCaptureViewModel
    private var roomCaptureView: RoomCaptureView?
    private var capturedRoom: CapturedRoom?
    
    init(viewModel: RoomCaptureViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let roomCaptureView = RoomCaptureView(frame: .zero)
        roomCaptureView.translatesAutoresizingMaskIntoConstraints = false
        self.roomCaptureView = roomCaptureView
        view.addSubview(roomCaptureView)
        NSLayoutConstraint.activate([
            roomCaptureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomCaptureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomCaptureView.topAnchor.constraint(equalTo: view.topAnchor),
            roomCaptureView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setup()
        roomCaptureView.captureSession.delegate = self
    }
    
    private func setup() {
        viewModel.actions
            .sink { [weak self] action in
                switch action {
                case .startSession:
                    self?.startSession()
                case .export:
                    self?.exportModel()
                }
            }
            .store(in: &cancellables)
    }
    
    private func startSession() {
        let sessionConfig = RoomCaptureSession.Configuration()
        roomCaptureView?.captureSession.run(configuration: sessionConfig)
    }
    
    private func exportModel() {
        do {
            try capturedRoom?.export(to: viewModel.exportUrl)
        } catch {
            logger.warning("Error when exporting room scan to usdz \(error)")
        }
    }
}

extension RoomCaptureViewController : RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        capturedRoom = room
        DispatchQueue.main.async {
            withAnimation {
                self.viewModel.canExport = true
            }
        }
    }
}

struct RoomCaptureRepresentableView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: RoomCaptureViewModel
    
    func makeUIViewController(context: Context) -> RoomCaptureViewController {
        return RoomCaptureViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: RoomCaptureViewController, context: Context) {}
}
