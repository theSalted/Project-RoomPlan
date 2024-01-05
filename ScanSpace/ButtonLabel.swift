//
//  ButtonLabel.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/6/24.
//

import SwiftUI

struct ButtonLabel: View {
    var systemName: String
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding()
            .background(Material.bar)
            .foregroundStyle(.secondary)
            .cornerRadius(16)
    }
}

#Preview {
    ButtonLabel(systemName: "square.and.arrow.up")
        .previewLayout(.sizeThatFits)
}
