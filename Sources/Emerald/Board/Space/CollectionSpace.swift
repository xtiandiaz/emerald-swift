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
            $0.onDropped = { [unowned self] in
                onDropped?(token)
            }
        })
    }
    
    // MARK: - Internal
    
    init(collection: Collection) {
        self.collection = collection
        
        super.init()
        
        $collection.sink { [unowned self] in
            $0.enumerated().forEach { [count = $0.count] in
                arrange(item: $1, at: $0, in: count)
            }
        }.store(in: &subscriptions)
    }
    
    func arrange(item: Collection.Element, at index: Int, in count: Int) {
        item.sortingIndex = count - index
        item.isLocked = index != 0
    }
    
    func add(_ token: Collection.Element) {
        fatalError("Not implemented")
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
}

open class StackSpace<T: Token>: CollectionSpace<Stack<T>> {
    
    // MARK: - Public
    
    public init() {
        super.init(collection: Stack<T>())
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        collection.peek()
    }

    public override func take(at localPosition: CGPoint) -> T? {
        collection.pop()
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
    
    public init() {
        super.init(collection: Queue<T>())
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        collection.peek()
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        collection.poll()
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
