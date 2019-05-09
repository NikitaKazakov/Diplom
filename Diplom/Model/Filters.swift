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
    func grayscale(image: UIImage) -> UIImage? {
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
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    func binary(image: UIImage) -> UIImage? {
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
                if pixelBuffer[offset].color > UInt32.max/3*2 {
                    pixelBuffer[offset] = Filter.RGBA32.white
                } else {
                    pixelBuffer[offset] = Filter.RGBA32.black
                }
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
        
        var maxGradient = -1
        
        
        func getOffset(_ i: Int, _ j: Int) -> Int {
            return i * width + j
        }
        
        var edges: [[Int]] = Array<[Int]>.init(repeating: Array<Int>(repeating: 0, count: width), count: height)
        
        for i in 1 ..< Int(height) - 1 {
            for j in 1 ..< Int(width) - 1 {
                let val00 = getGrayScale(pixelBuffer[getOffset(i - 1, j - 1)]);
                let val01 = getGrayScale(pixelBuffer[getOffset(i - 1, j)]);
                let val02 = getGrayScale(pixelBuffer[getOffset(i - 1, j + 1)]);
                
                let val10 = getGrayScale(pixelBuffer[getOffset(i, j - 1)]);
                let val11 = getGrayScale(pixelBuffer[getOffset(i, j)]);
                let val12 = getGrayScale(pixelBuffer[getOffset(i, j + 1)]);
                
                let val20 = getGrayScale(pixelBuffer[getOffset(i + 1, j - 1)]);
                let val21 = getGrayScale(pixelBuffer[getOffset(i + 1, j)]);
                let val22 = getGrayScale(pixelBuffer[getOffset(i + 1, j + 1)]);
                
                let gx =  ((-1 * val00) + (0 * val01) + (1 * val02))
                    + ((-2 * val10) + (0 * val11) + (2 * val12))
                    + ((-1 * val20) + (0 * val21) + (1 * val22));
                
                let gy =  ((-1 * val00) + (-2 * val01) + (-1 * val02))
                    + ((0 * val10) + (0 * val11) + (0 * val12))
                    + ((1 * val20) + (2 * val21) + (1 * val22));
                
                let gval = sqrt(Double((gx * gx) + (gy * gy)));
                let g =  Int(gval);
                
                if(maxGradient < g) {
                    maxGradient = g;
                }
                
                edges[i][j] = g
            }
        }
        
        
        for i in 1 ..< Int(height) - 1 {
            for j in 1 ..< Int(width) - 1 {
                let offset = i * width + j
                
                let scale = 255.0 / Double(maxGradient)
                
                var edgeColor = UInt32(Double(edges[i][j]) * scale)
                edgeColor = (edgeColor << 24) | (edgeColor << 16) | (edgeColor << 8) | 255
                
                pixelBuffer[offset] = Filter.RGBA32(edgeColor)
            }
        }
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }
    
    private func getGrayScale(_ rgb: Filter.RGBA32) -> Int {
        let r = Int(0.2126 * Double(rgb.redComponent))
        let g = Int(0.7152 * Double(rgb.greenComponent))
        let b = Int(0.0722 * Double(rgb.blueComponent))
        let avg = rgb.redComponent/3 + rgb.blueComponent/3 + rgb.greenComponent/3
        return Int(avg)
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
        
        init(_ color: UInt32) {
            self.color = color
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
