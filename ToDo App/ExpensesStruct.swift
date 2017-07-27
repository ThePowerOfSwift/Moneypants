import Foundation
import UIKit

var yearlyIncomeOutside: Int! = 0
var yearlyIncomeMPS: Int! = 0
//var yearlyTotal = String(format: "%.01f", (Int(Double(yearlyIncomeMPS) * 0.021) + yearlyIncomeOutside))
var calculatedIncome: Double! = Double(yearlyIncomeMPS) * 0.021 + Double(yearlyIncomeOutside)

var individualMainTotalIncome: Double! = 0

let tempUsers: [(String, UIImage, String)] = [
    ("Dad", #imageLiteral(resourceName: "Dad"), "41.05"),
    ("Mom", #imageLiteral(resourceName: "Mom"), "47.32"),
    ("Savannah", #imageLiteral(resourceName: "Savannah"), "22.01"),
    ("Aiden", #imageLiteral(resourceName: "Aiden"), "23.98"),
    ("Sophie", #imageLiteral(resourceName: "Sophie.jpg"), "14.67")
]

var homeIndex = 0       // MARK: global variable, need to change this
var paydayIndex = 0         // MARK: global variable, need to change this
