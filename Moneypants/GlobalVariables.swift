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

// Table data is as follows: job name, job multiplier, job Consistency Bonus, job editable?

let dailyJobsTemp = [
    ("bedroom", 1, false, true),
    ("bathrooms", 1, false, true),
    ("laundry", 1, false, true),
    ("living room", 1, false, true),
    ("sweep & vacuum", 1, false, true),
    ("wipe table", 1, false, true),
    ("counters", 1, false, true),
    ("dishes", 1, false, true),
    ("meal prep", 1, false, true),
    ("feed pet / garbage", 1, false, true)
]

let weeklyJobsTemp = [
    ("sweep porch",	2.5, false, true),
    ("weed garden",	5, false, true),
    ("wash windows", 5, false, true),
    ("dusting & cobwebs", 5, false, true),
    ("mop floors", 5, false, true),
    ("clean cabinets", 5, false, true),
    ("clean fridge", 10, false, true),
    ("wash car", 17.5, false, true),
    ("mow lawn", 25, false, true),
    ("babysit (per hour)", 25, false, true)
]

let dailyHabits = [
    ("get ready for day by 10:am", 1, false, true),
    ("personal meditation (10 min)", 1, false, true),
    ("daily exercise", 1, false, true),
    ("develop talents (20 min)", 1, false, true),
    ("homework done by 5:pm", 1, false, true),
    ("good manners", 1, false, true),
    ("peacemaking (no fighting)", 1, false, true),
    ("helping hands / obedience", 1, false, true),
    ("write in journal", 1, false, true),
    ("bed by 8:pm", 1, false, true)
]

let parentDailyJobs = [
    ("job inspections", 1, false, true)
    //("kid 1-on-1 time", 1, false, true)
]

let parentWeeklyJobs = [
    //("spouse 1-on-1 time", 1, false, false),
    ("Payday", 1, false, false)
    //("planning meeting", 1, false, false)
]

let parentDailyHabits = [
    ("get self ready for day", 1, false, true),
    ("personal meditation (10 min)", 1, false, true),
    ("daily exercise", 1, false, true),
    ("develop personal talents (20 min)", 1, false, true),
    ("1-on-1 with child", 1, false, true),
    ("update finances", 1, false, true),
    ("on time to events", 1, false, true),
    ("family devotional", 1, false, true),
    ("write in journal", 1, false, true),
    ("bed by 10:pm", 1, false, true)
]




//=====================================

// Table data is as follows: job name, job multiplier, job Consistency Bonus, job editable?

let assignedJobsHabitsDad: [String] = ["meal prep",
                                         "job inspections",
                                         "get self ready for day",
                                         "personal meditation",
                                         "develop talent",
                                         "1-on-1 with child",
                                         "payday"]
let assignedJobsHabitsMom: [String] = ["counters",
                                         "feed pet",
                                         "get self ready for day",
                                         "personal meditation",
                                         "develop talent",
                                         "1-on-1 with child",
                                         "clean fridge"]
let assignedJobsHabitsSavannah: [String] = ["bedroom",
                                              "bathrooms",
                                              "get self & buddy ready for day",
                                              "personal meditation / prayer",
                                              "daily exercise (20 min)",
                                              "wash & vacuum 1 car"]
let assignedJobsHabitsAiden: [String] = ["bedroom",
                                           "laundry",
                                           "living room",
                                           "get self & buddy ready for day",
                                           "personal meditation / prayer",
                                           "daily exercise (20 min)",
                                           "wash & vacuum 1 car"]
let assignedJobsHabitsSophie: [String] = ["bedroom",
                                            "sweep & vacuum",
                                            "dishes",
                                            "get self & buddy ready for day",
                                            "personal meditation / prayer",
                                            "daily exercise (20 min)",
                                            "mop floors",
                                            "mow lawn"]

let dailyJobsSavannah = [("bedroom", 1, false, true),
                           ("bathrooms", 1, false, true)]

let weeklyJobsSavannah = [("sweep porch",	2.5, false, true),
                            ("weed garden",	5, false, true),
                            ("babysit (per hour)", 25, false, true)]

//=====================================

let expenseEnvelopes = ["clothing",
                         "personal care",
                         "sports & dance",
                         "music & art",
                         "school",
                         "electronics",
                         "summer camps",
                         "transportation",
                         "other",
                         "fun money (10%)",
                         "donations (10%)",
                         "savings (10%)"]

let clothingEnvelope = ["socks & underwear", "shoes", "shirts & pants", "coats", "dresses", "suits", "swimwear", "jewelry", "purses / wallets", "other"]
let personalCareEnvelope = ["haircuts", "hair color", "nails", "eyebrows", "makeup", "hair tools &c"]
let sportsDanceEnvelope = ["registration fees", "tuition", "uniform", "team shirt", "equipment", "competitions", "performances", "costumes"]
let musicArtEnvelope = ["tuition", "supplies & tools", "other"]
let schoolEnvelope = ["field trips", "clubs", "backpack", "supplies"]
let electronicsEnvelope = ["phone", "phone bill", "software", "games", "iPods, iPads, &c"]
let summerCampsEnvelope = ["camp #1", "camp #2", "camp #3"]
let transportationEnvelope = ["bicycle maintenance", "bike gear", "gasoline (teen car)", "car insurance (teen)", "car maintenance (teen car)", "other"]
let otherEnvelope = ["other 1", "other 2", "other 3", "other 4", "other 5"]
let funMoneyEnvelope = ["fun money"]
let donationsEnvelope = ["charitable donations"]
let savingsEnvelope = ["savings (car)"]



//=====================================

var homeIndex = 0       // MARK: global variable, need to change this

//=====================================

let tempPaydayDailyJobs = [("clean bedroom", "1","1","","1","1","E","1", 60),
                           ("clean backyard", "1","1","1","1","1","E","1", 60),
                           ("water garden & feed chickens", "X","3","3","X","3","3","3", 50)]

let tempPaydayDailyHabits = [("self ready by 10:am","1","1","1","1","1","","1", 60),
                              ("prayer & scriptures (10 min)", "3","3","1","2","2","1","", 50),
                              ("exercise (20 min)", "","1","1","1","1","","", 40),
                              ("talents (20 min)", "","1","1","1","1","1","", 50),
                              ("homework by 5:pm", "","1","1","1","1","1","", 250),
                              ("manners", "1","","1","1","","","1", 40),
                              ("peacemaking", "2","1","2","3","1","1","2", 120),
                              ("good deed", "","5","3","3","4","1","5", 50),
                              ("journal", "1","1","1","1","1","1","1", 70),
                              ("bedtime by 9:30pm", "","1","1","1","1","","1", 50)]

let tempPaydayWeeklyJobs = [("wash windows inside", "","","","","","","1", 150),
                              ("babysit", "","","","2","","","", 1000)]

let consistencyBonus: Bool = true

//=====================================

let tempDates: [String] = ["Thurs, 27 Jul 2017",
                           "Weds, 26 Jul 2017",
                           "Tues, 25 Jul 2017",
                           "Mon, 24 Jul 2017"]
var date1Data: [(String, String, Int)] = [("3:23 pm", "clean bedroom", 10),
                                          ("11:12 am", "clean bathrooms", 10),
                                          ("10:45 am", "homework done by 5:pm", 10),
                                          ("8:08 am", "unique label", 10),
                                          ("6:25 am", "wash dirty undewear", 10),
                                          ("5:23 am", "put on clean underwear", 10)]
var date2Data: [(String, String, Int)] = [("5:23 am", "don't smell bad", 10),
                                          ("7:48 am", "try to smell good even though I'm a teenager", 10),
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

//====================================

let tempJobsCB = [11,13,1,0,0,26,0,0,0,12]
let tempHabitsCB = [7,16,38,9,24,3,12,8,10,22]

//====================================


//====================================

let trainingVideos = ["bedrooms",
                      "bathrooms: toilets, sinks, & floors",
                      "laundry",
                      "vacuuming",
                      "wiping the table",
                      "kitchen counters",
                      "dishes",
                      "sweeping",
                      "car wash",
                      "dirty diapers",
                      "mopping",
                      "toilet training"]

let setupVideos = ["setup",
                   "step 1",
                   "step 2 (part one)",
                   "step 2 (part two)",
                   "step 3 (part one)",
                   "step 3 (part two)",
                   "step 3 (consistency bonus)",
                   "step 4",
                   "step 4 (doing payday)",
                   "step 5",
                   "step 5 (directed spending)"]

let miscVideos = [("How The Moneypants Solution helps prevent anger", "https://vimeo.com/153579716"),
                  ("Moneypants Boss", "https://vimeo.com/153579716"),
                  ("Fancy Foods & Treats", "https://vimeo.com/153579716")]








