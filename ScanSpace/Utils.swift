//
//  Utils.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/11/24.
//

import Accelerate
import simd

func closestTransform(to target: simd_float4x4, from list: [simd_float4x4]) -> simd_float4x4? {
    guard !list.isEmpty else { return nil }

    var closestTransform: simd_float4x4?
    var smallestDistance: Float = Float.greatestFiniteMagnitude

    for transform in list {
        if simd_almost_equal_elements(transform, target, 0.5) {
            return transform
        }
        
        let distance = simd_distance(target, transform)
        if distance < smallestDistance {
            smallestDistance = distance
            closestTransform = transform
        }
    }

    return closestTransform
}

// Helper function to calculate the Euclidean distance between two simd_float4x4 matrices.
func simd_distance(_ a: simd_float4x4, _ b: simd_float4x4) -> Float {
    let diff = a - b
    let squared = diff * diff
    let sum = squared.columns.0.sum() + squared.columns.1.sum() + squared.columns.2.sum() + squared.columns.3.sum()
    return sqrt(sum)
}
