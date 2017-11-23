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
    
    static func loadExistingIncome(completion: @escaping (Int) -> ()) {
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
    
    static func calculatePayday() -> (last: Date, next: Date) {
        // extract day of week from paydayTime
        let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
//        let payday = "Saturday 2 PM"
        var paydayWeekday: String!
        for day in daysOfWeek {
            if self.paydayTime.contains(day) {
                paydayWeekday = day
            }
        }
        
        // calculate most recent payday, then use that to calculate next payday
        let today = Date()
        var lastPayday: Date!
        var nextPayday: Date!
        
        for n in 1...7 {
            let previousDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -n, to: today)
            // format previous date to show weekday in long format
            // if weekday matches payday, then count number of days since then and only subtotal values since then
            let formatterLong = DateFormatter()
            formatterLong.dateFormat = "EEEE"
            
            if formatterLong.string(from: previousDate!).contains(paydayWeekday) {
                lastPayday = previousDate
            }
        }
        nextPayday = Calendar.current.date(byAdding: Calendar.Component.day, value: 7, to: lastPayday)
        return (lastPayday, nextPayday)
    }
}
