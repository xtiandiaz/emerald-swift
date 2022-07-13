//
//  CollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Combine
import Foundation
import SwiftUI

open class CollectionSpace<T: TokenCollection>: Space<T.Element> {
    
    @Published public internal(set) var collection: T
    
    open override func canPlace(token: T.Element) -> Bool {
        tokenCount < tokenCapacity
    }
    
    // MARK: - Public
    
    public override var tokenCapacity: Int {
        .max
    }
    
    public override var tokenCount: Int {
        collection.count
    }
    
    public override var isEmpty: Bool {
        collection.isEmpty
    }
    
    public override func place(token: T.Element) {
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
        })
    }
    
    // MARK: - Internal
    
    init(
        collection: T,
        layout: SpaceLayout<T.Element>,
        styling: SpaceStyling<T.Element>?
    ) {
        self.collection = collection
        
        super.init(layout: layout, styling: styling)
        
        $collection.sink { [unowned self] in
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
    
    override func remove(token: T.Element) -> T.Element? {
        collection.remove(token)
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func arrange(item: T.Element, at index: Int, in count: Int) {
        item.layout = TokenLayout(
            index: index,
            zIndex: count - index,
            arrangementOffset: layout.arrangementOffset(forIndex: index, in: count),
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

open class StackSpace<T: Token>: CollectionSpace<Stack<T>> {
    
    // MARK: - Public
    
    public init(layout: SpaceLayout<T>, styling: SpaceStyling<T>? = nil) {
        super.init(collection: Stack<T>(), layout: layout, styling: styling)
    }
    
    public override func canInteract(with token: T) -> Bool {
        collection.peek()?.canInteract(with: token) == true
    }
    
    public override func interact(with token: T) {
        collection.peek()?.interact(with: token)
    }
    
    // MARK: - Internal
    
    override func add(_ token: T) {
        collection.push(token)
    }
    
    override func configure(item: T, in count: Int) {
        item.configure {
            $0.isLocked = $0.layout.index != 0
        }
    }
}

open class QueueSpace<T: Token>: CollectionSpace<Queue<T>> {
    
    // MARK: - Public
    
    public init(layout: SpaceLayout<T>, styling: SpaceStyling<T>? = nil) {
        super.init(collection: Queue<T>(), layout: layout, styling: styling)
    }
    
    public override func canInteract(with token: T) -> Bool {
        collection.peek()?.canInteract(with: token) == true
    }
    
    public override func interact(with token: T) {
        collection.peek()?.interact(with: token)
    }
    
    // MARK: - Internal
    
    override func add(_ token: T) {
        collection.add(token)
    }
    
    override func configure(item: T, in count: Int) {
        item.configure {
            $0.isLocked = $0.layout.index != 0
        }
    }
}

open class HandSpace<T: Token>: CollectionSpace<Array<T>> {
    
    public init(layout: SpaceLayout<T>) {
        super.init(collection: Array<T>(), layout: layout, styling: nil)
    }
    
    open override func canInteract(with token: T) -> Bool {
        collection.firstIndex { $0.canInteract(with: token) } != nil
    }
    
    open override func interact(with token: T) {
        collection
            .filter { $0.canInteract(with: token) }
            .forEach { $0.interact(with: token) }
    }
}
