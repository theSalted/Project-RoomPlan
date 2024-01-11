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
import ARKit
import GLKit

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


func distanceSCNVector3(from vector1: SCNVector3, to vector2: SCNVector3) -> Float {
         return simd_distance(simd_float3(vector1), simd_float3(vector2))
     }


func simd_to_SCNVector3_coord(_ matrix: simd_float4x4) -> SCNVector3 {
    return SCNVector3(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
}

func pairClosestNodesObjects(nodes: [SCNNode], objects : [CapturedRoom.Object]) -> [(SCNNode, CapturedRoom.Object)] {
    var result = [(SCNNode, CapturedRoom.Object)]()
    
    for object in objects {
        let objectTransform = object.transform
        let objectPosition = simd_to_SCNVector3_coord(objectTransform)
        var bestDistance : Float = .infinity
        guard var closestNode = nodes.first else {
            return result
        }
        for node in nodes {
            let nodeTransform = node.simdTransform
            let nodePosition = simd_to_SCNVector3_coord(nodeTransform)
            let distance = distanceSCNVector3(from: nodePosition, to: objectPosition)
            if distance < bestDistance {
                closestNode = node
                bestDistance = distance
            }
        }
        result.append((closestNode, object))
    }
    
    return result
}


func pairClosestNodesObjectsByTolerance(nodes: [SCNNode], objects : [CapturedRoom.Object]) -> [(SCNNode, CapturedRoom.Object)] {
    var result = [(SCNNode, CapturedRoom.Object)]()
    
    for object in objects {
        let objectTransform = object.transform
        var bestTolerance : Float = .infinity
        guard var closestNode = nodes.first else {
            return result
        }
        for node in nodes {
            let nodeTransform = node.simdTransform
            print(nodeTransform.debugDescription)
            if simd_almost_equal_elements(nodeTransform, objectTransform, bestTolerance) {
                let matrixDiff = objectTransform - nodeTransform
                bestTolerance = simd_float4x4_maxMag(matrixDiff)
                print(nodeTransform.debugDescription)
                closestNode = node
            }
        }
        result.append((closestNode, object))
    }
    
    return result
}
