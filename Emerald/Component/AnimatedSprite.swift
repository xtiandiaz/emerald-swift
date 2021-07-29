//
//  AnimatedSprite.swift
//  Emerald
//
//  Created by Cristian Díaz on 18.10.2020.
//

import SwiftUI

struct AnimatedSprite: View {

    let resourceName: String
    let frameCount: Int
    
    init(resourceName: String, frameCount: Int, frameInterval: TimeInterval) {
        self.resourceName = resourceName
        self.frameCount = frameCount
        
        timer = ConnectableTimer(interval: frameInterval)
        timer.connect()
    }

    var body: some View {
        Image("\(resourceName)\(frame)")
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .onReceive(timer.publisher) { _ in
                frame = frame + 1 >= frameCount ? 0 : frame + 1
            }
//            .onAppear { timer.connect() }
//            .onDisappear { timer.cancel() }
    }
    
    // MARK: Private
    
    private let timer: ConnectableTimer
    @State private var frame: Int = 0
}


//struct AnimatedSprite_Previews: PreviewProvider {
//    static var previews: some View {
////        AnimatedSprite(resourceName: String, frameCount: Int, frameInterval: TimeInterval)
//    }
//}
