//
//  LumaColorShiftPIX.swift
//  PixelKit
//
//  Created by Hexagons on 2020-06-01.
//  Open Source - MIT License
//

import LiveValues
import RenderKit
import CoreGraphics

public class LumaColorShiftPIX: PIXMergerEffect, PIXAuto {
    
    override open var shaderName: String { return "effectMergerLumaColorShiftPIX" }
    
    // MARK: - Public Properties
    
    public var hue: LiveFloat = 0.0
    public var saturation: LiveFloat = 1.0
    public var tintColor: LiveColor = .white
    
    // MARK: - Property Helpers
    
    override public var liveValues: [LiveValue] {
        return [hue, saturation, tintColor]
    }
    
    // MARK: - Life Cycle
    
    public required init() {
        super.init(name: "Luma Color Shift", typeName: "pix-effect-merger-luma-color-shift")
    }
    
}
