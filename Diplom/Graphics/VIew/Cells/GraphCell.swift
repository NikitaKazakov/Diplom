//
//  GraphCell.swift
//  TelegramContest
//
//  Created by Nikita Kazakov on 3/14/19.
//  Copyright © 2019 Nikita Kazakov. All rights reserved.
//

import UIKit

class GraphCell: UITableViewCell {

    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var smallGraphView: SmallGraphView!
    
    @IBOutlet weak var leftPannedView: UIView!
    @IBOutlet weak var centralPannedView: UIView!
    @IBOutlet weak var rightPannedView: UIView!
    @IBOutlet weak var leftSideView: UIView!
    @IBOutlet weak var rightSideView: UIView!
    
    @IBOutlet weak var leftLeadingConstaint: NSLayoutConstraint!
    @IBOutlet weak var rightLeadingConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        let left = UIPanGestureRecognizer(target: self, action: #selector(handlePanLeft(gestureRecognizer:)))
        leftPannedView.addGestureRecognizer(left)
        let right = UIPanGestureRecognizer(target: self, action: #selector(handlePanRight(gestureRecognizer:)))
        rightPannedView.addGestureRecognizer(right)
        let center = UIPanGestureRecognizer(target: self, action: #selector(handlePanCenter(gestureRecognizer:)))
        centralPannedView.addGestureRecognizer(center)
    }
    
    @objc func handlePanLeft(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            if leftLeadingConstaint.constant + translation.x < rightLeadingConstraint.constant - 10, leftLeadingConstaint.constant + translation.x > 0 {
                leftLeadingConstaint.constant += translation.x
                layoutIfNeeded()
                graphView.leftOffset = leftLeadingConstaint.constant
            } else if leftLeadingConstaint.constant + translation.x < rightLeadingConstraint.constant - 10 {
                leftLeadingConstaint.constant = 0
                layoutIfNeeded()
                graphView.leftOffset = leftLeadingConstaint.constant
            } else if leftLeadingConstaint.constant + translation.x > 0 {
                leftLeadingConstaint.constant = rightLeadingConstraint.constant - 10
                layoutIfNeeded()
                graphView.leftOffset = leftLeadingConstaint.constant
            }
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
    }
    @objc func handlePanRight(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if rightLeadingConstraint.constant + translation.x > leftLeadingConstaint.constant + 10, rightLeadingConstraint.constant + translation.x < self.frame.width - 10 {
                rightLeadingConstraint.constant += translation.x
                layoutIfNeeded()
                graphView.rightOffset = rightLeadingConstraint.constant
            }
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
    }
    @objc func handlePanCenter(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if rightLeadingConstraint.constant + translation.x < self.frame.width - 10, leftLeadingConstaint.constant + translation.x > 0 {
                rightLeadingConstraint.constant += translation.x
                leftLeadingConstaint.constant += translation.x
                layoutIfNeeded()
                graphView.leftOffset = leftLeadingConstaint.constant
                graphView.rightOffset = rightLeadingConstraint.constant
            }
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
    }
}
