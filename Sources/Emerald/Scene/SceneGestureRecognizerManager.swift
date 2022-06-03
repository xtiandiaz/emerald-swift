//
//  SceneGestureRecognizerManager.swift
//  Emerald
//
//  Created by Cristian Diaz on 3.6.2022.
//

import Beryllium
import Foundation
import SpriteKit

public class SceneGestureRecognizerManager {
    
    public enum Gesture: Hashable {
        
        case swipe,
             longPress(minDuration: TimeInterval)
    }
    
    public func longPressRecognizer(minDuration: TimeInterval = 0.5) -> UILongPressGestureRecognizer {
        recognizer(for: .longPress(minDuration: minDuration)) as! UILongPressGestureRecognizer
    }
    
    public func swipeRecognizer(direction: UISwipeGestureRecognizer.Direction) -> UIDirectionalSwipeGestureRecognizer {
        recognizer(for: .swipe) as! UIDirectionalSwipeGestureRecognizer
    }
    
    // MARK: - Internal
    
    init(scene: Scene) {
        self.scene = scene
    }
    
    // MARK: - Private
    
    private weak var scene: Scene?
    
    private func recognizer(for gesture: Gesture) -> UIGestureRecognizer {
        { () -> UIGestureRecognizer in
            switch gesture {
            case .swipe:
                return UIDirectionalSwipeGestureRecognizer(target: self, action: nil)
            
            case .longPress(let minDuration):
                return UILongPressGestureRecognizer(target: self, action: nil).configure {
                    $0.minimumPressDuration = minDuration
                }
        }
        }().configure {
            scene?.view?.addGestureRecognizer($0)
        }
    }
}
