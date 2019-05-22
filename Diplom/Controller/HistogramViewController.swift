//
//  ViewController.swift
//  TelegramContest
//
//  Created by Nikita Kazakov on 3/14/19.
//  Copyright © 2019 Nikita Kazakov. All rights reserved.
//

import UIKit

enum Mode {
    case night, day
}

class HistogramViewController: UIViewController {
    class func instantiate(subModel: SubModel) -> HistogramViewController {
        let storyboard = UIStoryboard(name: "Histogram", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! HistogramViewController
        vc.subModel = subModel
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    var subModel: SubModel?
    weak var graphCell: GraphCell?
    var mode: Mode = .day
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        tableView.register( UINib(nibName: "StatusCellTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusCellTableViewCell")
        tableView.register( UINib(nibName: "GraphCell", bundle: nil), forCellReuseIdentifier: "GraphCell")
        tableView.register( UINib(nibName: "SwitchModeCell", bundle: nil), forCellReuseIdentifier: "SwitchModeCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if mode == .day {
            return .default
        } else {
            return .lightContent
        }
    }
}

extension HistogramViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + (subModel?.y.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myCell = UITableViewCell()
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell") as? GraphCell else {
                break
            }
            graphCell = cell
            cell.smallGraphView.subModel = subModel!
            cell.graphView.subModel = subModel!
            
            cell.leftLeadingConstaint.constant = view.frame.width - 50
            cell.rightLeadingConstraint.constant = view.frame.width - 10
            cell.graphView.leftOffset = view.frame.width - 50
            cell.graphView.rightOffset = view.frame.width - 10
            myCell = cell
        case IndexPath(row: 3 + (subModel?.y.count ?? 0) - 2, section: 0):
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clear
            myCell = cell
        case IndexPath(row: 3 + (subModel?.y.count ?? 0) - 1, section: 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchModeCell") as? SwitchModeCell else {
                break
            }
            myCell = cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCellTableViewCell") as? StatusCellTableViewCell else {
                break
            }
            guard let colorText = subModel?.y[indexPath.row - 1].color else { break }
            cell.color = colorText
            cell.channelName.text = subModel?.y[indexPath.row - 1].name
            cell.accessoryType = .checkmark
            myCell = cell
        }
        myCell.selectionStyle = .none
        return myCell
    }
    
    
}

extension HistogramViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StatusCellTableViewCell, let subModel = subModel{
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                var y = subModel.y
                for i in 0..<y.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: 1 + i, section: 0)) as? StatusCellTableViewCell, cell.accessoryType == .none {
                        y.removeAll(where: { $0.name == cell.channelName.text })
                    }
                }
                let sm = SubModel.init(x: subModel.x, y: y)
                graphCell?.smallGraphView.subModel = sm
                graphCell?.graphView.subModel = sm
            } else {
                cell.accessoryType = .checkmark
                var y = subModel.y
                for i in 0..<y.count {
                    if let cell = tableView.cellForRow(at: IndexPath(row: 1 + i, section: 0)) as? StatusCellTableViewCell, cell.accessoryType == .none {
                        y.removeAll(where: { $0.name == cell.channelName.text })
                    }
                }
                let sm = SubModel.init(x: subModel.x, y: y)
                graphCell?.smallGraphView.subModel = sm
                graphCell?.graphView.subModel = sm
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? SwitchModeCell {
            if mode == .day {
                mode = .night
                UIApplication.shared.statusBarStyle = .lightContent
            } else {
                mode = .day
                UIApplication.shared.statusBarStyle = .default
            }
            //setNeedsStatusBarAppearanceUpdate()
            switchMode(mode: .night, view: navigationController!.view)
        }
    }
}


func switchMode(mode: Mode, view: UIView) {
    for v in view.subviews {
        if let label = v as? UILabel {
            label.textColor = label.textColor.inverse()
            if label.text == "Back" {
                label.textColor = label.textColor.inverse()
            }
        }
        v.backgroundColor = v.backgroundColor?.inverse()
        switchMode(mode: mode, view: v)
    }
}

extension UIColor {
    func inverse () -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return .black // Return a default colour
    }
}
