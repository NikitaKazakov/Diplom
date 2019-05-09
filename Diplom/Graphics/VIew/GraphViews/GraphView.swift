//
//  GraphView.swift
//  TelegramContest
//
//  Created by Nikita Kazakov on 3/14/19.
//  Copyright © 2019 Nikita Kazakov. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

    var subModel: SubModel = SubModel(x: [], y: []) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var leftOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var rightOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var maxSubY = Int.min
        for i in 0..<subModel.y.count {
            let leftIndex = Int(leftOffset/(rect.width - 10)*CGFloat(subModel.x.count - 1))
            let rightIndex = Int(rightOffset/(rect.width - 10)*CGFloat(subModel.x.count - 1))
            let subY = Array(subModel.y[i].data[leftIndex...rightIndex])
            if let y = subY.max(), y > maxSubY {
                maxSubY = y
            }
        }
        
        for i in 0..<subModel.y.count {
            let leftIndex = Int(leftOffset/(rect.width - 10)*CGFloat(subModel.x.count - 1))
            let rightIndex = Int(rightOffset/(rect.width - 10)*CGFloat(subModel.x.count - 1))
            let subX = Array(subModel.x[leftIndex...rightIndex])
            let subY = Array(subModel.y[i].data[leftIndex...rightIndex])
            drawGraphic(x: subX, y: subY, color: subModel.y[i].color, rect: rect, yMax: maxSubY, lineWidth: 2)
        }
    }

}
