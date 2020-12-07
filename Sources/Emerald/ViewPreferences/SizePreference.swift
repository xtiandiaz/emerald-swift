//
//  SizePreference.swift
//  Emerald
//
//  Created by Cristian Díaz on 7.12.2020.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    
    private var sizeView: some View {
        GeometryReader {
            geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

