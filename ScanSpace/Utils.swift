//
//  Utils.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/11/24.
//


import simd
import Accelerate
import RoomPlan
import SceneKit


func simd_float4x4_maxMag(_ matrix: simd_float4x4) -> Float {
    var maxAbsValue : Float = 0
    var flatMatrix = [Float](repeating: 0, count: 16)
    
    // Flatten the matrix into an array
    _ = withUnsafePointer(to: matrix) {
        memcpy(&flatMatrix, $0, MemoryLayout<Float>.size * 16)
    }

    // Use Accelerate to find the max absolute value
    vDSP_maxmgv(flatMatrix, 1, &maxAbsValue, vDSP_Length(flatMatrix.count))

    return maxAbsValue
}

func pairClosestNodesObjects(nodes: [SCNNode], objects : [CapturedRoom.Object]) -> [(SCNNode, CapturedRoom.Object)] {
    var result = [(SCNNode, CapturedRoom.Object)]()
    
    for object in objects {
        let objectTransform = object.transform
        var bestTolerance : Float = .infinity
        guard var closestNode = nodes.first else {
            return result
        }
        for node in nodes {
            let nodeTransform = node.simdTransform
            if simd_almost_equal_elements(nodeTransform, objectTransform, bestTolerance) {
                let matrixDiff = objectTransform - nodeTransform
                bestTolerance = simd_float4x4_maxMag(matrixDiff)
                closestNode = node
            }
        }
        result.append((closestNode, object))
    }
    
    return result
}
