import Foundation
import Firebase

struct FamilyData {
    static var yearlyIncome: Int! = 0
    static var setupProgress: Int! = 0
    static var paydayTime: String = ""

    static func getSetupProgressFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("setupProgress").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                setupProgress = value
            }
        })
    }
    
    static func loadExistingIncome(completion: @escaping (Int) -> ()) {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("income").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                yearlyIncome = value
                completion(yearlyIncome)
            }
        })
    }
    
    static func loadPaydayTimeFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("paydayTime").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? String {
                paydayTime = value
            }
        })
    }
}
