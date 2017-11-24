import Foundation
import Firebase

struct FamilyData {
    static var yearlyIncome: Int = 0
    static var setupProgress: Int = 0
    static var paydayTime: String = ""
    static var adjustedNatlAvgYrlySpendingEntireFam: Int = 0
    static var adjustedNatlAvgYrlySpendingPerKid: Int = 0
    static var feeValueMultiplier: Int = 0
    
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
                yearlyIncome = value
                completion(yearlyIncome)
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
        var previousPayday: Date!
        var currentPayday: Date!
        var nextPayday: Date!
        
        for n in 8...14 {
            let previousDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -n, to: today)
            // format previous date to show weekday in long format
            // if weekday matches payday, then count number of days since then and only subtotal values since then
            let formatterLong = DateFormatter()
            formatterLong.dateFormat = "EEEE"
            
            if formatterLong.string(from: previousDate!).contains(paydayWeekday) {
                previousPayday = previousDate
            }
        }
        currentPayday = Calendar.current.date(byAdding: Calendar.Component.day, value: 7, to: previousPayday)
        nextPayday = Calendar.current.date(byAdding: .day, value: 14, to: previousPayday)
        return (previousPayday, currentPayday, nextPayday)
        
        // NOTES:
        // 1. previous payday is at least a week and one day ago
        // 2. current pay period is at least one day ago (you can't have payday if the pay period hasn't ended)
        // Pay period ends the day BEFORE payday. So, payday will always be one day after the pay period ends
        // 3. next payday is at the most six days away.
        
        // pay period begins at 12:01AM on the day of payday, and ends at 11:59PM the night before the next payday
    }
}



