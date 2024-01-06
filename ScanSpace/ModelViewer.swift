//
//  ModelViewer.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import SceneKit
import SwiftUI

/// A helper for 3D viewers
struct ModelViewer {
    var modelURL : URL
    /// Get a `SCNScene` based on `modelURL`.
    ///
    /// Note: This property generate a new scene every time it's called. Please try to cache its value.
    var model : SCNNode?
    
    init(modelURL: URL) {
        self.modelURL = modelURL
    }
}

