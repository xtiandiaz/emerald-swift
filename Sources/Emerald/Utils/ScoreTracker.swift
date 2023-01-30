//
//  ScoreTracker.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.10.2022.
//

import Foundation

public protocol ScoreTracker: AnyObject {
    
    var score: Int { get }
    
    func score(count: Int)
}
