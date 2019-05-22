//
//  StatusCellTableViewCell.swift
//  TelegramContest
//
//  Created by Nikita Kazakov on 3/14/19.
//  Copyright © 2019 Nikita Kazakov. All rights reserved.
//

import UIKit

class StatusCellTableViewCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var colorView: CustomView!
    var color: UIColor? {
        didSet {
            colorView.color = color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CustomView: UIView {
    var color: UIColor?
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 3)
        guard  let color = color else {
            return
        }
        color.setFill()
        path.addClip()
        path.fill()
    }
}
