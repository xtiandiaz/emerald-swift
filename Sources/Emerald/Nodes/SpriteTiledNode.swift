//
//  SpriteTiledNode.swift
//  Emerald
//
//  Created by Cristian Díaz on 26.8.2021.
//

import SpriteKit

public class SpriteTiledNode: SKSpriteNode {
    
    public var offset: CGPoint = .zero {
        didSet {
            shader?.removeUniformNamed(Self.uOffsetName)
            shader?.addUniform(uOffset())
        }
    }
    
    public var tiling: CGPoint = .one {
        didSet {
            shader?.removeUniformNamed(Self.uTilingName)
            shader?.addUniform(uTiling())
        }
    }
    
    public override var texture: SKTexture? {
        didSet {
            textureSize = texture?.size()
        }
    }
    
    public init(texture: SKTexture?, size: CGSize, color: UIColor = .white) {
        super.init(texture: texture, color: color, size: size)
        
        shader = SKShader(named: "SpriteTiled", uniforms: [uOffset(), uTiling()])
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private static let uOffsetName = "u_offset"
    private static let uTilingName = "u_tiling"
    
    private lazy var textureSize = texture?.size()
    
    private func uOffset() -> SKUniform {
        SKUniform(name: Self.uOffsetName, vectorFloat2: offset.vector_float2())
    }
    
    private func uTiling() -> SKUniform {
        let _tiling: CGPoint = {
            if let textureSize = textureSize {
                return tiling * CGPoint(x: 1, y: textureSize.inverseAspectRatio)
            } else {
                return .one
            }
        }()
        
        return SKUniform(name: Self.uTilingName, vectorFloat2: _tiling.vector_float2())
    }
}
