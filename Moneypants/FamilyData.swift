import Foundation
import Firebase

struct FamilyData {
    static var yearlyIncome: Int = 0
    static var setupProgress: Int = 0
    static var paydayTime: String = ""
    static var adjustedNatlAvgYrlySpendingEntireFam: Int = 0
    static var adjustedNatlAvgYrlySpendingPerKid: Int = 0
    static var feeValueMultiplier: Int = 0

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
}
