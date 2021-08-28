//
//  SKShaderExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 26.8.2021.
//

import SpriteKit

extension SKShader {
    
    public convenience init(named filename: String, uniforms: [SKUniform]? = nil, attributes: [SKAttribute]? = nil) {
        guard let path = Bundle.module.path(forResource: filename, ofType: "fsh") else {
            fatalError("Unable to find shader \(filename).fsh in bundle")
        }
        guard let source = try? String(contentsOfFile: path) else {
            fatalError("Unable to load shader \(filename).fsh")
        }
        
        if let uniforms = uniforms {
            self.init(source: source as String, uniforms: uniforms)
        } else {
            self.init(source: source as String)
        }
        
        if let attributes = attributes {
            self.attributes = attributes
        }
    }
}
