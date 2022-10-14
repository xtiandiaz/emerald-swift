//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Combine
import Foundation
import SwiftUI

open class Space<T: TokenCollection>: AnySpace {
    
    @Published public internal(set) var tokens: T
    @Published var layout: SpaceLayout<T.Element>
    
    open override var tokenCapacity: Int {
        .max
    }
    
    open func canPlace(token: T.Element) -> Bool {
        tokenCount < tokenCapacity
    }
    
    // MARK: - Public
    
    public override var tokenCount: Int {
        tokens.count
    }
    
    public override var isEmpty: Bool {
        tokens.isEmpty
    }
    
    public func canInteract(with token: T.Element) -> Bool {
        fatalError("Not implemenwted")
    }
    
    public func interact(with token: T.Element) {
        fatalError("Not implemented")
    }
    
    public func place(token: T.Element) {
        guard canPlace(token: token) else {
            return
        }
        
        add(token.configure {
            $0.onPicked = { [unowned self] in
                onPicked?(token)
            }
            $0.onDropped = { [unowned self] offset in
                onDropped?(token, offset)
            }
            $0.onPushed = { [unowned self] direction, offset in
                onPushed?(token, direction, offset)
            }
        })
    }
    
    // MARK: - Internal
    
    let styling: SpaceStyling<T.Element>?
    
    init(
        collection: T,
        layout: SpaceLayout<T.Element>,
        styling: SpaceStyling<T.Element>?
    ) {
        tokens = collection
        self.layout = layout
        self.styling = styling
        
        super.init()
        
        $tokens.sink { [unowned self] in
            $0.enumerated().forEach { [count = $0.count] in
                arrange(item: $1, at: $0, in: count)
                stylize(item: $1, in: count)
                configure(item: $1, in: count)
            }
        }.store(in: &subscriptions)
    }
    
    func add(_ token: T.Element) {
        fatalError("Not implemented")
    }
    
    func configure(item: T.Element, in count: Int) {
        fatalError("Not implemented")
    }
    
    override func canInteract(with token: Token) -> Bool {
        with(token as? T.Element) { canInteract(with: $0) } without: { false }
    }
    
    override func interact(with token: Token) {
        with(token as? T.Element) { interact(with: $0) }
    }
    
    override func canPlace(token: Token) -> Bool {
        with(token as? T.Element) { canPlace(token: $0) } without: { false }
    }
    
    override func place(token: Token) {
        with(token as? T.Element) { place(token: $0) }
    }
    
    func remove(token: T.Element) -> T.Element? {
        tokens.remove(token)
    }
    
    override func remove(token: Token) -> Token? {
        with(token as? T.Element) { remove(token: $0) } without: { nil }
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func arrange(item: T.Element, at index: Int, in count: Int) {
        item.layout = TokenLayout(
            index: index,
            zIndex: count - index,
            offset: layout.arrangementOffset(forIndex: index, in: count),
            rotation: layout.rotation(forIndex: index, in: count)
        )
    }
    
    private func stylize(item: T.Element, in count: Int) {
        guard let styling = styling else {
            return
        }
        
        item.styling = TokenStyling(
            brightness: styling.brightness(forToken: item, in: count)
        )
    }
}

open class StackSpace<T: Token>: Space<Stack<T>> {
    
    // MARK: - Public
    
    public init(layout: SpaceLayout<T>, styling: SpaceStyling<T>? = nil) {
        super.init(collection: Stack<T>(), layout: layout, styling: styling)
    }
    
    public override func canInteract(with token: T) -> Bool {
        tokens.peek()?.canInteract(with: token) == true
    }
    
    public override func interact(with token: T) {
        tokens.peek()?.interact(with: token)
    }
    
    // MARK: - Internal
    
    override func add(_ token: T) {
        tokens.push(token)
    }
    
    override func configure(item: T, in count: Int) {
        item.configure {
            $0.isLocked = $0.layout.index != 0
        }
    }
}

open class QueueSpace<T: Token>: Space<Queue<T>> {
    
    // MARK: - Public
    
    public init(layout: SpaceLayout<T>, styling: SpaceStyling<T>? = nil) {
        super.init(collection: Queue<T>(), layout: layout, styling: styling)
    }
    
    public override func canInteract(with token: T) -> Bool {
        tokens.peek()?.canInteract(with: token) == true
    }
    
    public override func interact(with token: T) {
        tokens.peek()?.interact(with: token)
    }
    
    // MARK: - Internal
    
    override func add(_ token: T) {
        tokens.add(token)
    }
    
    override func configure(item: T, in count: Int) {
        item.configure {
            $0.isLocked = $0.layout.index != 0
        }
    }
}

open class HandSpace<T: Token>: Space<Array<T>> {
    
    public init(
        tokenAspect: CGSize
    ) {
        super.init(
            collection: Array<T>(),
            layout: .init(
                tokenAspect: tokenAspect,
                tokenOffset: { _ in .zero },
                tokenRotation: { _ in .zero }
            ),
            styling: nil
        )
    }
    
    public override func canInteract(with token: T) -> Bool {
        tokens.firstIndex { $0.canInteract(with: token) } != nil
    }
    
    public override func interact(with token: T) {
        tokens
            .filter { $0.canInteract(with: token) }
            .forEach { $0.interact(with: token) }
    }
    
    // MARK: - Internal
    
    override func add(_ token: T) {
        tokens.append(token)
    }
    
    override func configure(item: T, in count: Int) {
        // No-op
    }
}
