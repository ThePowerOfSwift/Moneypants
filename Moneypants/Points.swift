import Foundation
import Firebase

struct Points {
    var user: String
    var itemName: String
    var itemCategory: String
    var code: String
    var valuePerTap: Int
    var itemDate: Double
    
    static var pointsArray = [Points]()
    
    static func loadPoints(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("points").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? DataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let user = value["user"] as! String
                        let itemName = value["itemName"] as! String
                        let itemCategory = value["itemCategory"] as! String
                        let code = value["code"] as! String
                        let valuePerTap = value["valuePerTap"] as! Int
                        let itemDate = value["itemDate"] as! Double
                        
                        let pointsItem = Points(user: user, itemName: itemName, itemCategory: itemCategory, code: code, valuePerTap: valuePerTap, itemDate: itemDate)
                        
                        Points.pointsArray.append(pointsItem)
                        completion()
                    }
                }
            }
        }
    }
    
    static func updateJobBonus() {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        for user in MPUser.usersArray {
            let jobAndHabitBonusValue = Int(Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.20 * 100)
            
            // if on payday, user has no X's for the week AND user has no jobs bonus, then calculate bonus
            let previousPayPeriodIsoArray = Points.pointsArray.filter({ $0.user == user.firstName && $0.itemCategory == "daily jobs" && $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 && ($0.code == "X" || $0.code == "B") })
            
            if Date().timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 && previousPayPeriodIsoArray.isEmpty {
//                print("give \(user.firstName) a job bonus!")
                
                // create job bonus for last day of pay period (not first day of current pay period)
                let selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: FamilyData.calculatePayday().current)!
                
                let pointsArrayItem = Points(user: user.firstName,
                                             itemName: "job bonus",
                                             itemCategory: "daily jobs",
                                             code: "B",
                                             valuePerTap: jobAndHabitBonusValue,      // previous was dailyJobsPointValue
                                             itemDate: selectedDate.timeIntervalSince1970)
                
                Points.pointsArray.append(pointsArrayItem)
                
                // add item to Firebase
                // need to organize them in some way? perhaps by date? category?
                ref.child("points").childByAutoId().setValue(["user" : user.firstName,
                                                              "itemName" : "job bonus",
                                                              "itemCategory" : "daily jobs",
                                                              "code" : "B",
                                                              "valuePerTap" : jobAndHabitBonusValue,
                                                              "itemDate" : selectedDate.timeIntervalSince1970])
                
                for (index, item) in Income.currentIncomeArray.enumerated() {
                    if item.user == user.firstName {
                        Income.currentIncomeArray[index].currentPoints += jobAndHabitBonusValue
                    }
                }
                
                // update user income on Firebase
                ref.child("mpIncome").updateChildValues([user.firstName : Income.currentIncomeArray[MPUser.currentUser].currentPoints])
            }
        }
    }
    
    // round up numbers larger than 10, unless specifically told not to
    static func formatMoney(amount: Int, rounded: Bool) -> String {
        if rounded && amount < -999 {
            return "-$\(Int((Double(abs(amount)) / 100).rounded(.up)))"
        } else if rounded && amount >= -999 && amount < 0 {
            return "-$\(String(format: "%.2f", Double(abs(amount)) / 100))"
        } else if rounded && amount > 999 {
            return "$\(Int((Double(amount) / 100).rounded(.up)))"
        } else if !rounded && amount < 0 {
            return "-$\(String(format: "%.2f", Double(abs(amount)) / 100))"
        } else {
            return "$\(String(format: "%.2f", Double(amount) / 100))"
        }
    }
    
    // code:
    // C = completed (for daily jobs, daily habits, and weekly jobs)
    // E = excused (for daily jobs only)
    // X = unexcused (for daily jobs only)
    // S = sub (for daily and weekly jobs)
    // J = job jar
    // N = not complete (for habits and weekly jobs)
    // F = fee
    // B = bonus (for daily jobs and habits)
    // P = paid (for payday items)
    // U = unpaid
    
    // daily jobs:      C, E, X, B
    // daily habits:    C, N, B
    // weekly jobs:     C, N
    // other jobs:      S, J
    // 
    // where to put P and U?
    
}
