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

open class CollectionSpace<Collection: TokenCollection>: Space<Collection.Element> {
    
    @Published public internal(set) var collection: Collection
    
    open override func canPlace(token: Collection.Element) -> Bool {
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
    
    public override func place(token: Collection.Element) {
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
        collection: Collection,
        layout: SpaceLayout<Collection.Element>,
        styling: SpaceStyling<Collection.Element>?
    ) {
        self.collection = collection
        
        super.init(layout: layout, styling: styling)
        
        $collection.sink { [unowned self] in
            $0.enumerated().forEach { [count = $0.count] in
                arrange(item: $1, at: $0, in: count)
                stylize(item: $1, in: count)
            }
        }.store(in: &subscriptions)
    }
    
    func add(_ token: Collection.Element) {
        fatalError("Not implemented")
    }
    
    override func remove(token: Collection.Element) -> Collection.Element? {
        collection.remove(token)
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func arrange(item: Collection.Element, at index: Int, in count: Int) {
        item.layout = TokenLayout(
            index: index,
            zIndex: count - index,
            arrangementOffset: layout.arrangementOffset(forIndex: index, in: count)
        )
    }
    
    private func stylize(item: Collection.Element, in count: Int) {
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
    
    public override func peek() -> T? {
        collection.peek()
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
}

open class QueueSpace<T: Token>: CollectionSpace<Queue<T>> {
    
    // MARK: - Public
    
    public init(layout: SpaceLayout<T>, styling: SpaceStyling<T>? = nil) {
        super.init(collection: Queue<T>(), layout: layout, styling: styling)
    }
    
    public override func peek() -> T? {
        collection.peek()
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
}
