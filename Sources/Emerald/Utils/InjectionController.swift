//
//  InjectionController.swift
//  Emerald
//
//  Created by Cristian Díaz on 1.8.2021.
//

import Foundation

final public class InjectionController {
    
    public static let shared = InjectionController()
    
    public func register<T>(_ injectable: T) {
        injectables["\(T.self)"] = injectable
    }
    
    public func remove<T>(_ injectable: T) {
        injectables["\(T.self)"] = nil
    }
    
    public func resolve<T>(_ type: T.Type) throws -> T {
        let key = "\(type)"
        
        guard let injectable = injectables[key] as? T else {
            throw Error.unregisteredReference(type: key)
        }
        
        return injectable
    }
    
    // MARK: Private
        
    private enum Error: Swift.Error {
        case unregisteredReference(type: String)
    }
    
    private var injectables = [String: Any]()
    
    private init() {}
}
