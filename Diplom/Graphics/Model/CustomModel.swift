import Foundation
import UIKit

class Model {
    private(set) var subModel: [SubModel] = []
    
    init(json: [Any]) {
        for i in json {
            if let dict = i as? [String : Any],
               var arrArr = dict["columns"] as? [[Any]],
               let types = dict["types"] as? [String : String],
               let names = dict["names"] as? [String : String],
               let colors = dict["colors"] as? [String : String] {
                var namesArray: [String] = []
                for j in 0..<arrArr.count {
                    namesArray.append(arrArr[j].removeFirst() as! String)
                }
                guard var data = arrArr as? [[Int]] else { return }
                var x: [Int] = []
                for (index, element) in namesArray.enumerated() where types[element] == "x" {
                    x = data.remove(at: index)
                    namesArray.removeAll(where: { $0 == "x"})
                }
                
                var y: [YValues] = []
                
                for (index, element) in namesArray.enumerated() {
                    guard let color = colors[element], let name = names[element] else { return }
                    y.append(YValues(color: color, name: name, data: data[index]))
                }
                subModel.append(SubModel(x: x, y: y))
            }
        }
    }
}

struct SubModel {
    let x: [Int]
    let y: [YValues]
}

struct YValues {
    let color: UIColor
    let name: String
    let data: [Int]
    
    init(color: String, name: String, data: [Int]) {
        self.color = hexStringToUIColor(hex: color)
        self.name = name
        self.data = data
    }
}
