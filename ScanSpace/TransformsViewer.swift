//
//  TransformsViewet.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/11/24.
//
import simd
import Accelerate
import SwiftUI

struct TransformsViewer: View {
    var simdTransforms : [simd_float4x4]
    var body: some View {
        List (simdTransforms.indices, id: \.self) { i in
            let transform = simdTransforms[i]
            
            VStack {
                Text(transform.columns.0.description)
                Text(transform.columns.1.description)
                Text(transform.columns.2.description)
                Text(transform.columns.3.description)
            }
        }
    }
}


#Preview {
    TransformsViewer(simdTransforms: [simd_float4x4()])
}
