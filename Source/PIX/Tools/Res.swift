//
//  Res.swift
//  HxPxE
//
//  Created by Hexagons on 2018-08-07.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation

public extension PIX {

    public enum Res {
        
        case _720p
        case _1080p
        case _4K
        
        case _128
        case _256
        case _512
        case _1024
        case _2048
        case _4096
        
        case iPhone(Orientation)
        case iPhonePlus(Orientation)
        case iPhoneX(Orientation)
        
        case iPad(Orientation)
        case iPadPro_10_5(Orientation)
        case iPadPro_12_9(Orientation)
        
        case screen
        
        case customRes(_ raw: Raw)
        case customSize(_ size: CGSize)

        public var raw: Raw {
            switch self {
            case ._720p: return Raw(w: 1280, h: 720)
            case ._1080p: return Raw(w: 1920, h: 1080)
            case ._4K: return Raw(w: 3840, h: 2160)
            case ._128: return Raw(w: 128, h: 128)
            case ._256: return Raw(w: 256, h: 256)
            case ._512: return Raw(w: 512, h: 512)
            case ._1024: return Raw(w: 1024, h: 1024)
            case ._2048: return Raw(w: 2048, h: 2048)
            case ._4096: return Raw(w: 4096, h: 4096)
            case .iPhone(let ori):
                let raw = Raw(w: 750, h: 1334)
                if ori == .portrait { return raw }
                else { return raw.flopped }
            case .iPhonePlus(let ori):
                let raw = Raw(w: 1080, h: 1920)
                if ori == .portrait { return raw }
                else { return raw.flopped }
            case .iPhoneX(let ori):
                let raw = Raw(w: 1125, h: 2436)
                if ori == .portrait { return raw }
                else { return raw.flopped }
            case .iPad(let ori):
                let raw = Raw(w: 1536, h: 2048)
                if ori == .portrait { return raw }
                else { return raw.flopped }
            case .iPadPro_10_5(let ori):
                let raw = Raw(w: 1668, h: 2224)
                if ori == .portrait { return raw }
                else { return raw.flopped }
            case .iPadPro_12_9(let ori):
                let raw = Raw(w: 2048, h: 2732)
                if ori == .portrait { return raw }
                else { return raw.flopped }
            case .screen:
                let nativeSize = UIScreen.main.nativeBounds.size
                return Raw(w: Int(nativeSize.width), h: Int(nativeSize.height))
            case .customRes(let raw): return raw
            case .customSize(let size): return Raw(w: Int(size.width), h: Int(size.height))
            }
        }
        
        public struct Raw {
            public let w: Int
            public let h: Int
            public var flopped: Raw { return Raw(w: h, h: w) }
            public static func ==(lhs: Raw, rhs: Raw) -> Bool {
                return lhs.w == rhs.w && lhs.h == rhs.h
            }
        }
        
        public enum Orientation {
            case portrait
            case landscape
        }
        
        public var size: CGSize {
            return CGSize(width: raw.w, height: raw.h)
        }
        public var width: CGFloat {
            return size.width
        }
        public var height: CGFloat {
            return size.height
        }
        public var aspect: CGFloat {
            return size.width / size.height
        }
        
        public init(_ raw: Raw) {
            switch raw {
            case let r where r == Res._720p.raw: self = ._720p
            case let r where r == Res._1080p.raw: self = ._1080p
            case let r where r == Res._4K.raw: self = ._4K
            case let r where r == Res._128.raw: self = ._128
            case let r where r == Res._256.raw: self = ._256
            case let r where r == Res._512.raw: self = ._512
            case let r where r == Res._1024.raw: self = ._1024
            case let r where r == Res._2048.raw: self = ._2048
            case let r where r == Res._4096.raw: self = ._4096
            case let r where r == Res.iPhone(.portrait).raw: self = .iPhone(.portrait)
            case let r where r == Res.iPhone(.landscape).raw: self = .iPhone(.landscape)
            case let r where r == Res.iPhonePlus(.portrait).raw: self = .iPhonePlus(.portrait)
            case let r where r == Res.iPhonePlus(.landscape).raw: self = .iPhonePlus(.landscape)
            case let r where r == Res.iPhoneX(.portrait).raw: self = .iPhoneX(.portrait)
            case let r where r == Res.iPhoneX(.landscape).raw: self = .iPhoneX(.landscape)
            case let r where r == Res.iPad(.portrait).raw: self = .iPad(.portrait)
            case let r where r == Res.iPad(.landscape).raw: self = .iPad(.landscape)
            case let r where r == Res.iPadPro_10_5(.portrait).raw: self = .iPadPro_10_5(.portrait)
            case let r where r == Res.iPadPro_10_5(.landscape).raw: self = .iPadPro_10_5(.landscape)
            case let r where r == Res.iPadPro_12_9(.portrait).raw: self = .iPadPro_12_9(.portrait)
            case let r where r == Res.iPadPro_12_9(.landscape).raw: self = .iPadPro_12_9(.landscape)
            case let r where r == Res.screen.raw: self = .screen
            default: self = .customRes(raw)
            }
        }
        
        public init(size: CGSize) {
            self.init(Raw(w: Int(size.width), h: Int(size.height)))
        }
        
        public init(image: UIImage) {
            let nativeSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
            self = .customSize(nativeSize)
        }
        
        public init(pixelBuffer: CVPixelBuffer) {
            let imageSize = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            self = .customSize(imageSize)
        }
        
        public init(texture: MTLTexture) {
            let textureRaw = Raw(w: texture.width, h: texture.height)
            self = .customRes(textureRaw)
        }
        
        public static func ==(lhs: Res, rhs: Res) -> Bool {
            return lhs.raw.w == rhs.raw.w && lhs.raw.h == rhs.raw.h
        }
        public static func !=(lhs: Res, rhs: Res) -> Bool {
            return !(lhs == rhs)
        }
        
        public static func >(lhs: Res, rhs: Res) -> Bool? {
            let w = lhs.raw.w > rhs.raw.w
            let h = lhs.raw.h > rhs.raw.h
            return w == h ? w : nil
        }
        public static func <(lhs: Res, rhs: Res) -> Bool? {
            let w = lhs.raw.w < rhs.raw.w
            let h = lhs.raw.h < rhs.raw.h
            return w == h ? w : nil
        }
        public static func >=(lhs: Res, rhs: Res) -> Bool? {
            let w = lhs.raw.w >= rhs.raw.w
            let h = lhs.raw.h >= rhs.raw.h
            return w == h ? w : nil
        }
        public static func <=(lhs: Res, rhs: Res) -> Bool? {
            let w = lhs.raw.w <= rhs.raw.w
            let h = lhs.raw.h <= rhs.raw.h
            return w == h ? w : nil
        }
        
        public static func +(lhs: Res, rhs: Res) -> Res {
            return Res(Raw(w: lhs.raw.w + rhs.raw.w, h: lhs.raw.h + rhs.raw.h))
        }
        public static func -(lhs: Res, rhs: Res) -> Res {
            return Res(Raw(w: lhs.raw.w - rhs.raw.w, h: lhs.raw.h - rhs.raw.h))
        }
        public static func *(lhs: Res, rhs: Res) -> Res {
            return Res(Raw(w: lhs.raw.w * rhs.raw.w, h: lhs.raw.h * rhs.raw.h))
        }
        public static func /(lhs: Res, rhs: Res) -> Res {
            return Res(Raw(w: lhs.raw.w / rhs.raw.w, h: lhs.raw.h / rhs.raw.h))
        }
        
        public static func +(lhs: Res, rhs: CGFloat) -> Res {
            return Res(Raw(w: lhs.raw.w + Int(rhs), h: lhs.raw.h + Int(rhs)))
        }
        public static func -(lhs: Res, rhs: CGFloat) -> Res {
            return Res(Raw(w: lhs.raw.w - Int(rhs), h: lhs.raw.h - Int(rhs)))
        }
        public static func *(lhs: Res, rhs: CGFloat) -> Res {
            return Res(Raw(w: Int(lhs.width * rhs), h: Int(lhs.width * rhs)))
        }
        public static func /(lhs: Res, rhs: CGFloat) -> Res {
            return Res(Raw(w: Int(lhs.width / rhs), h: Int(lhs.width / rhs)))
        }
        public static func +(lhs: CGFloat, rhs: Res) -> Res {
            return rhs + lhs
        }
        public static func -(lhs: CGFloat, rhs: Res) -> Res {
            return (rhs - lhs) * -1
        }
        public static func *(lhs: CGFloat, rhs: Res) -> Res {
            return rhs * lhs
        }
        
    }

}
