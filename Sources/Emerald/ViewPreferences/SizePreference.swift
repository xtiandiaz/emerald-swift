//
//  SizePreference.swift
//  Emerald
//
//  Created by Cristian Díaz on 7.12.2020.
//

import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    
    public static var defaultValue: CGSize = .zero

    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

public struct SizeModifier: ViewModifier {

    public func body(content: Content) -> some View {
        content.background(sizeView)
    }
    
    // MARK: Private
    
    private var sizeView: some View {
        GeometryReader {
            geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

