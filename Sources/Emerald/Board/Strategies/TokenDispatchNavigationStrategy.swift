//
//  TokenDispatchNavigationStrategy.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.10.2022.
//

import Foundation

public class TokenDispatchNavigationStrategy<
    SpaceType: Space & Place & Selectable,
    Delegate: TokenDispatchNavigationDelegate<SpaceType> & AnyObject
>: TokenNavigationStrategy {
    
    public weak var delegate: Delegate?
    
    public required init(map: GridMap<SpaceType>) {
        self.map = map
    }
    
    public func targetSpace(atLocalPosition localPosition: Position) {
        guard let space = map.place(forLocalPosition: localPosition) else {
            return
        }
        
        if space == source {
            dismiss()
        } else if !source.isNil {
            dispatchToSpace(space)
        } else if !space.isEmpty {
            source = space
        }
    }
    
    private func dispatchToSpace(_ destination: SpaceType) {
        guard
            let delegate,
            let source,
            let token = delegate.tokenFromSpace(source),
            delegate.isValidDestination(destination, forToken: token, fromSpace: source)
        else {
            return
        }
        
        source.releaseToken(token)
        
        delegate.moveToken(token, intoSpace: destination) { [unowned self] in
            dismiss()
            self.source = destination
        }
    }
    
    // MARK: - Private
    
    private let map: GridMap<SpaceType>
    
    private var source: SpaceType? {
        didSet {
            source?.setSelected(true)
        }
    }
    
    private func dismiss() {
        source?.setSelected(false)
        source = nil
    }
}
