//
//  SmallGraphView.swift
//  TelegramContest
//
//  Created by Nikita Kazakov on 3/14/19.
//  Copyright © 2019 Nikita Kazakov. All rights reserved.
//

import UIKit

class SmallGraphView: UIView {
    
    private let topBottomInset: CGFloat = 10
    private let margin: CGFloat = 20
    
    var subModel: SubModel = SubModel(x: [], y: []) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let maxY = subModel.y.reduce(Int.min, {max($0,$1.data.max() ?? Int.min)})
        for i in 0..<subModel.y.count {
            drawGraphic(x: subModel.x, y: subModel.y[i].data, color: subModel.y[i].color, rect: rect, yMax: maxY)
        }
    }
    
    
}

func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func drawGraphic(x: [Int],y: [Int], color: UIColor, rect : CGRect, yMax: Int, lineWidth: CGFloat? = nil) {
    let maxYPoint = yMax
    let width = rect.width
    let height = rect.height
    
    let graphWidth = width - 20
    let maxXValue = x.last!
    let minXValue = x.first!
    let columnXPoint = { (graphPoint: Int) -> CGFloat in
        let x = CGFloat(graphPoint - minXValue) / CGFloat(maxXValue - minXValue) * graphWidth
        return x + 10
    }
    
    let graphHeight = height - 10 - 10
    let maxYValue = maxYPoint
    let columnYPoint = { (graphPoint: Int) -> CGFloat in
        let y = CGFloat(graphPoint) / CGFloat(maxYValue) * graphHeight
        return graphHeight + 10 - y
    }
    
    color.setFill()
    color.setStroke()
    
    let graphPath = UIBezierPath()
    if let lineWidth = lineWidth {
        graphPath.lineWidth = lineWidth
    }
    graphPath.move(to: CGPoint(x: columnXPoint(x[0]), y: columnYPoint(y[0])))
    
    for i in 1..<x.count {
        let nextPoint = CGPoint(x: columnXPoint(x[i]), y: columnYPoint(y[i]))
        graphPath.addLine(to: nextPoint)
    }
    
    graphPath.stroke()
}
