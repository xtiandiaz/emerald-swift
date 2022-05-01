//
//  Runnable.swift
//  Beryllium
//
//  Created by Cristian Diaz on 15.4.2022.
//

import Foundation

public protocol Runnable {
    
    var isRunning: Bool { get }
    
    func start()
    func stop()
}
