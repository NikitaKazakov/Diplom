//
//  Filters.swift
//  tableViewTesting
//
//  Created by Admin on 11/20/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import CoreImage.CIKernel
import CoreImage.CIFilter
import UIKit

class Filter: CIFilter {
    
    func processPixels(in image: UIImage, computing: (_ buff: UnsafeMutablePointer<Filter.RGBA32>, _ off: Int,_ i: Int, _ j: Int) -> Swift.Void) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                computing(pixelBuffer,offset,row,column)
            }
        }
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    func borders(in image: UIImage) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                let avgColor = pixelBuffer[offset].redComponent/3 + pixelBuffer[offset].greenComponent/3 + pixelBuffer[offset].blueComponent/3
                pixelBuffer[offset] = Filter.RGBA32(red: avgColor, green: avgColor, blue: avgColor, alpha: 255)
            }
        }
        for row in 0 ..< Int(height) {
            //var s = 0
            for column in 0 ..< Int(width) {
//                for k in 0..<3 {
//                    let offset = (row + k) * width + column
//                    s += Int(pixelBuffer[offset].redComponent/3 + pixelBuffer[offset].greenComponent/3 + pixelBuffer[offset].blueComponent/3)
//                }
//                for k in 0..<3 {
//                    let offset = (row + k) * width + column + 2
//                    s -= Int(pixelBuffer[offset].redComponent/3 + pixelBuffer[offset].greenComponent/3 + pixelBuffer[offset].blueComponent/3)
//                }
//                var s2: UInt8
//                if s >= UInt8.max {
//                    s2 = UInt8.max
//                } else {
//                    s2 = UInt8(s)
//                }
                if column != Int(width) - 1 {
                    let offset1 = row * width + column
                    let avgColor1 = pixelBuffer[offset1].redComponent/3 + pixelBuffer[offset1].greenComponent/3 + pixelBuffer[offset1].blueComponent/3
                    let offset2 = row * width + column + 1
                    let avgColor2 = pixelBuffer[offset2].redComponent/3 + pixelBuffer[offset2].greenComponent/3 + pixelBuffer[offset2].blueComponent/3
                    if Double(avgColor1) >= Double(avgColor2) {
                        if (Double(avgColor1)-Double(avgColor2))/255*100 >= 50 {
                            pixelBuffer[offset1] = Filter.RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
                        } else {
                            pixelBuffer[offset1] = Filter.RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
                        }
                    } else {
                        if (Double(avgColor2)-Double(avgColor1))/255*100  >= 50 {
                            pixelBuffer[offset2] = Filter.RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
                        } else {
                            pixelBuffer[offset2] = Filter.RGBA32(red: 0, green: 0, blue: 0, alpha: 255)
                        }
                    }
                }
//                let offset = (row) * width + column
//                pixelBuffer[offset] = Filter.RGBA32(red: s2, green: s2, blue: s2, alpha: 255)
            }
        }
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    struct RGBA32: Equatable {
        /*private*/ var color: UInt32
        
        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }
        
        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }
        
        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }
        
        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
        }
        
        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
}
