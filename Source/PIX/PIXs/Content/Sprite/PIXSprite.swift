//
//  PIXSprite.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-28.
//  Open Source - MIT License
//

import LiveValues
import RenderKit
import SpriteKit

open class PIXSprite: PIXContent, NODEResolution {
    
    override open var shaderName: String { return "spritePIX" }
    
    // MARK: - Public Properties
    
    public var resolution: Resolution { didSet { reSize(); applyResolution { self.setNeedsRender() } } }
    
    public var bgColor: LiveColor = .black {
        didSet {
            scene.backgroundColor = bgColor._color
            setNeedsRender()
        }
    }
    
    var scene: SKScene!
    var sceneView: SKView!
    
    required public init(at resolution: Resolution = .auto(render: PixelKit.main.render)) {
        fatalError("Please use PIXSprite Sub Classes.")
    }
        
    public init(at resolution: Resolution = .auto(render: PixelKit.main.render), name: String, typeName: String) {
        self.resolution = resolution
        super.init(name: name, typeName: typeName)
        setup()
        applyResolution { self.setNeedsRender() }
    }
    
    func setup() {
        let size = (resolution / Resolution.scale).size.cg
        scene = SKScene(size: size)
        scene.backgroundColor = bgColor._color
        sceneView = SKView(frame: CGRect(origin: .zero, size: size))
        sceneView.allowsTransparency = true
        sceneView.presentScene(scene)
    }
    
    func reSize() {
        let size = (resolution / Resolution.scale).size.cg
        scene.size = size
        sceneView.frame = CGRect(origin: .zero, size: size)
    }
    
}
