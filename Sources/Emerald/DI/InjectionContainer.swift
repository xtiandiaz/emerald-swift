//
//  InjectionContainer.swift
//  Emerald
//
//  Created by Cristian Díaz on 1.8.2021.
//

import Foundation

public final class InjectionContainer {
    
    public static let shared = InjectionContainer()
    
    private enum Error: Swift.Error {
        case unregisteredReference(type: String)
    }
    
    private struct InjectableSource {
        
        var block: () -> Any
        var tag: String?
    }
    
    private struct Injectable {
        
        var instance: Any
        var tag: String?
    }
    
    private var injectables = [String: Injectable]()
    private var sources = [String: InjectableSource]()
    
    private init() {
    }
    
    public func install<T>(
        _ block: @autoclosure @escaping () -> T,
        withTag tag: String? = nil
    ) {
        install(block, T.self, tag)
    }
    
    public func install<T1, T2>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
    }
    
    public func install<T1, T2, T3>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
    }
    
    public func install<T1, T2, T3, T4>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
    }
    
    public func install<T1, T2, T3, T4, T5>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        _ b5: @autoclosure @escaping () -> T5,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
        install(b5, T5.self, tag)
    }
    
    public func install<T1, T2, T3, T4, T5, T6>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        _ b5: @autoclosure @escaping () -> T5,
        _ b6: @autoclosure @escaping () -> T6,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
        install(b5, T5.self, tag)
        install(b6, T6.self, tag)
    }
    
    public func install<T1, T2, T3, T4, T5, T6, T7>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        _ b5: @autoclosure @escaping () -> T5,
        _ b6: @autoclosure @escaping () -> T6,
        _ b7: @autoclosure @escaping () -> T7,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
        install(b5, T5.self, tag)
        install(b6, T6.self, tag)
        install(b7, T7.self, tag)
    }
    
    public func install<T1, T2, T3, T4, T5, T6, T7, T8>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        _ b5: @autoclosure @escaping () -> T5,
        _ b6: @autoclosure @escaping () -> T6,
        _ b7: @autoclosure @escaping () -> T7,
        _ b8: @autoclosure @escaping () -> T8,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
        install(b5, T5.self, tag)
        install(b6, T6.self, tag)
        install(b7, T7.self, tag)
        install(b8, T8.self, tag)
    }
    
    public func install<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        _ b5: @autoclosure @escaping () -> T5,
        _ b6: @autoclosure @escaping () -> T6,
        _ b7: @autoclosure @escaping () -> T7,
        _ b8: @autoclosure @escaping () -> T8,
        _ b9: @autoclosure @escaping () -> T9,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
        install(b5, T5.self, tag)
        install(b6, T6.self, tag)
        install(b7, T7.self, tag)
        install(b8, T8.self, tag)
        install(b9, T9.self, tag)
    }
    
    public func install<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
        _ b1: @autoclosure @escaping () -> T1,
        _ b2: @autoclosure @escaping () -> T2,
        _ b3: @autoclosure @escaping () -> T3,
        _ b4: @autoclosure @escaping () -> T4,
        _ b5: @autoclosure @escaping () -> T5,
        _ b6: @autoclosure @escaping () -> T6,
        _ b7: @autoclosure @escaping () -> T7,
        _ b8: @autoclosure @escaping () -> T8,
        _ b9: @autoclosure @escaping () -> T9,
        _ b10: @autoclosure @escaping () -> T10,
        withTag tag: String? = nil
    ) {
        install(b1, T1.self, tag)
        install(b2, T2.self, tag)
        install(b3, T3.self, tag)
        install(b4, T4.self, tag)
        install(b5, T5.self, tag)
        install(b6, T6.self, tag)
        install(b7, T7.self, tag)
        install(b8, T8.self, tag)
        install(b9, T9.self, tag)
        install(b10, T10.self, tag)
    }
    
    public func resolve<T>(_ type: T.Type) throws -> T {
        let key = "\(type)"
        
        if let injectable = injectables[key]?.instance as? T {
            return injectable
        } else if let source = sources[key], let injectable = source.block() as? T {
            injectables[key] = Injectable(instance: injectable, tag: source.tag)
            return injectable
        } else {
            throw Error.unregisteredReference(type: key)
        }
    }
    
    public func remove<T>(_ injectable: T) {
        injectables["\(T.self)"] = nil
    }
    
    public func removeAll(withTag tag: String) {
        injectables.forEach {
            if $0.value.tag == tag {
                injectables[$0.key] = nil
            }
        }
    }
    
    public func removeAll() {
        injectables.removeAll()
    }
    
    private func install<T>(_ block: @escaping () -> T, _ type: T.Type, _ tag: String?) {
        sources["\(type.self)"] = InjectableSource(block: block, tag: tag)
    }
}
