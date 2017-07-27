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



let tempPaydayDailyChores = [("clean bedroom, backyard, chickens, watering", "1","1","1","1","1","E","1", 70)]

let tempPaydayDailyHabits = [("self ready by 10:am","1","1","1","1","1","E","1", 70),
                              ("prayer & scriptures (10 min)", "1","1","1","1","1","1","1", 70),
                              ("exercise (20 min)", "","1","1","1","1","","", 40),
                              ("talents (20 min)", "","1","1","1","1","1","", 50),
                              ("homework by 5:pm", "","1","1","1","1","1","", 250),
                              ("manners (rinse dishes)", "1","","1","1","","","1", 40),
                              ("peacemaking", "2","1","2","3","1","1","2", 120),
                              ("good deed", "","1","1","1","1","","1", 50),
                              ("journal", "1","1","1","1","1","1","1", 70),
                              ("bedtime by 9:30pm", "","1","1","1","1","E","1", 60)]

let tempPaydayWeeklyChores = [("wash windows inside", "","","","","","","1", 150),
                              ("babysit", "","","","2","","","", 1000)]

let consistencyBonus: Bool = true






