import Foundation
import UIKit

var yearlyIncomeOutside: Int! = 0
var yearlyIncomeMPS: Int! = 0
//var yearlyTotal = String(format: "%.01f", (Int(Double(yearlyIncomeMPS) * 0.021) + yearlyIncomeOutside))
var calculatedIncome: Double! = Double(yearlyIncomeMPS) * 0.021 + Double(yearlyIncomeOutside)

var individualMainTotalIncome: Double! = 0

//=====================================

let tempUsers: [(String, UIImage, String)] = [
    ("Dad", #imageLiteral(resourceName: "Dad"), "41.05"),
    ("Mom", #imageLiteral(resourceName: "Mom"), "47.32"),
    ("Savannah", #imageLiteral(resourceName: "Savannah"), "22.01"),
    ("Aiden", #imageLiteral(resourceName: "Aiden"), "23.98"),
    ("Sophie", #imageLiteral(resourceName: "Sophie.jpg"), "14.67")
]

//=====================================

var homeIndex = 0       // MARK: global variable, need to change this
var paydayIndex = 0         // MARK: global variable, need to change this

//=====================================

let tempPaydayDailyChores = [("clean bedroom, backyard, chickens, watering", "1","1","1","1","1","E","1", 70)]

let tempPaydayDailyHabits = [("self ready by 10:am","1","1","1","1","1","E","1", 70),
                              ("prayer & scriptures (10 min)", "X","1","1","1","1","1","X", 50),
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

//=====================================

let tempDates: [String] = ["Thurs, 27 Jul 2017", "Weds, 26 Jul 2017", "Tues, 25 Jul 2017", "Mon, 24 Jul 2017"]
var date1Data: [(String, String, Int)] = [("5:23 am", "clean bedroom", 10),
                                          ("5:23 am", "clean bathrooms", 10),
                                          ("5:23 am", "homework done by 5:pm", 10),
                                          ("5:23 am", "unique label", 10),
                                          ("5:23 am", "wash dirty undewear", 10),
                                          ("5:23 am", "put on clean underwear", 10)]
var date2Data: [(String, String, Int)] = [("5:23 am", "don't smell bad", 10),
                                          ("5:23 am", "try to smell good even though I'm a teenager", 10),
                                          ("5:23 am", "eat good food", 10),
                                          ("5:23 am", "eat bad food", 10),
                                          ("5:23 am", "clean stuff", 10),
                                          ("5:23 am", "dirty stuff", 10)]
var date3Data: [(String, String, Int)] = [("12:23 pm", "clean laudry", 10),
                                          ("5:23 am", "clean garage", 10),
                                          ("5:23 am", "garage bedroom", 10),
                                          ("5:23 am", "clean dishes", 10),
                                          ("5:23 am", "clean dirty dishes", 10),
                                          ("5:23 am", "wash bedroom", 10),
                                          ("7:20 pm", "payday", -2201)]
var date4Data: [(String, String, Int)] = [("5:23 am", "clean teeth", 10),
                                          ("5:23 am", "brush someone else's teeth", 10),
                                          ("9:23 am", "fighting", -100),
                                          ("5:23 am", "eat slugs", 10),
                                          ("5:23 am", "brush teeth again", 10),
                                          ("5:23 am", "vomit slugs", 10),
                                          ("5:23 am", "brush teeth again, this time with mouthwash to get rid of the nasty taste of slugs. Ugh.", 10)]

var sectionData: [Int: [(String, String, Int)]] = [:]







