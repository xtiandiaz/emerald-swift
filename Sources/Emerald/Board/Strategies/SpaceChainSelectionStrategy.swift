//
//  SpaceChainSelectionStrategy.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.10.2022.
//

import Foundation

public class SpaceChainSelectionStrategy<SpaceType: Space & Place & Selectable>: SpaceSelectionStrategy {
    
    public var allowsDiagonals = true
    
    public weak var delegate: (any SpaceSelectionDelegate<SpaceType>)?
    
    public required init(map: GridMap<SpaceType>) {
        self.map = map
    }
    
    public func selectAt(localPosition: CGPoint) {
        guard let space = map.placeAt(localPosition: localPosition) else {
            return
        }
        
        defer {
            latestLocation = space.location
        }
        
        guard latestLocation != space.location else {
            return
        }
        
        guard let previousLocation = chain.last else {
            chain(through: space)
            return
        }
        
        if space.isSelected {
            if
                chain.count > 1,
                space.location == chain[chain.count - 2]
            {
                trimChain()
            }
        } else if isNextValidSpace(space, from: previousLocation) {
            chain(through: space)
        }
    }
    
    public func finishSelecting() {
        delegate?.didFinishSelectingSpaces(chain.map { map.placeAt(location: $0) })
        
        chain.removeAll()
        latestLocation = nil
    }
    
    // MARK: - Private
    
    private let map: GridMap<SpaceType>
    private var chain = [Location]()
    private var latestLocation: Location?
    
    private func chain(through space: SpaceType) {
        chain.append(space.location)
        
        space.setSelected(true)
    }
    
    private func trimChain() {
        guard !chain.isEmpty else {
            return
        }
        
        map.placeAt(location: chain.removeLast())
            .setSelected(false)
    }
    
    private func isNextValidSpace(_ space: SpaceType, from previousLocation: Location) -> Bool {
        guard let delegate else {
            return false
        }
        
        return isNextValidLocation(space.location, from: previousLocation)
            && delegate.shouldSelectSpace(space, after: map.placeAt(location: previousLocation))
            
    }
    
    private func isNextValidLocation(_ next: Location, from previous: Location) -> Bool {
        let colOffset = abs(next.x - previous.x)
        let rowOffset = abs(next.y - previous.y)
        
        return (colOffset + rowOffset) == 1 || (allowsDiagonals && colOffset == 1 && rowOffset == 1)
    }
}
