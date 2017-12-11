import Foundation
import Firebase

struct FamilyData {
    static var householdIncome: Int = 0
    static var setupProgress: Int = 0
    static var budgetStartDate: TimeInterval?
    static var paydayTime: String = ""
    
    static let secretFormula = (5.23788 * pow(0.972976, Double(householdIncome) / 1000) + 1.56139) / 100
    static let numberOfKids = MPUser.usersArray.filter({ $0.childParent == "child" }).count
    
    static func censusKidsMultiplier() -> Double {
        if numberOfKids >= 3 {
            return 0.76
        } else if numberOfKids == 2 {
            return 1
        } else if numberOfKids <= 1 {
            return 1.27
        } else {
            return 0
        }
    }
    
    static var natlAvgYrlySpendingPerKid = Double(householdIncome) * secretFormula
    static var adjustedNatlAvgYrlySpendingEntireFam: Int = Int(FamilyData.natlAvgYrlySpendingPerKid * censusKidsMultiplier() * Double(MPUser.usersArray.count))
    static var adjustedNatlAvgYrlySpendingPerKid: Int = Int(natlAvgYrlySpendingPerKid * censusKidsMultiplier())
    static var feeValueMultiplier: Int = Int(Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 365.26 * 0.20 * 100)
    static var jobAndHabitBonusValue: Int = Int(Double(adjustedNatlAvgYrlySpendingPerKid) / 52.18 * 0.20 * 100)
    
    static let fees = ["fighting", "lying", "stealing", "disobedience", "bad language"]

    static func getSetupProgressFromFirebase(completion: @escaping (Int) -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("setupProgress").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                setupProgress = value
                completion(setupProgress)
            } else {
                completion(0)
            }
        })
    }
    
    static func loadExistingHouseholdIncome(completion: @escaping (Int) -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("householdIncome").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                householdIncome = value
                completion(householdIncome)
            } else {
                completion(0)
            }
        })
    }
    
    static func loadPaydayTimeFromFirebase(completion: @escaping (String) -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("paydayTime").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? String {
                paydayTime = value
                completion(paydayTime)
            } else {
                completion("")
            }
        })
    }
    
    static func loadBudgetStartDateFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("budgetStartDate").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? TimeInterval {
                budgetStartDate = value
                completion()
            } else {
                completion()
            }
        })
    }
    
    static let budgetEndDate = Calendar.current.date(byAdding: .year, value: 1, to: Date(timeIntervalSince1970: budgetStartDate!))
    
    static func calculatePayday() -> (previous: Date, current: Date, next: Date) {
        // extract day of week from paydayTime
        let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        var paydayWeekday: String!
        for day in daysOfWeek {
            if self.paydayTime.contains(day) {
                paydayWeekday = day
            }
        }
        
        // calculate most recent payday, then use that to calculate next payday
        let today = Date()
        let calendar = Calendar.current
        var previousPayday: Date!
        var currentPayday: Date!
        var nextPayday: Date!
        
        for n in 7...13 {
            let previousDate = calendar.date(byAdding: .day, value: -n, to: today)
            // format previous date to show weekday in long format
            // if weekday matches payday, then count number of days since then and only subtotal values since then
            let formatterLong = DateFormatter()
            formatterLong.dateFormat = "EEEE"
            
            if formatterLong.string(from: previousDate!).contains(paydayWeekday) {
                previousPayday = previousDate
            }
        }
        currentPayday = calendar.date(byAdding: Calendar.Component.day, value: 7, to: previousPayday)
        nextPayday = calendar.date(byAdding: .day, value: 14, to: previousPayday)
        
        previousPayday = calendar.startOfDay(for: previousPayday)
        currentPayday = calendar.startOfDay(for: currentPayday)
        nextPayday = calendar.startOfDay(for: nextPayday)
        
        return (previousPayday, currentPayday, nextPayday)
        
        // NOTES:
        // 1. previous payday is at least a week and one day ago
        // 2. current pay period is at least one day ago (you can't have payday if the pay period hasn't ended)
        // Pay period ends the day BEFORE payday. So, payday will always be one day after the pay period ends
        // 3. next payday is at the most six days away.
        
        // pay period begins at 12:01AM on the day of payday, and ends at 11:59PM the night before the next payday
    }
}



