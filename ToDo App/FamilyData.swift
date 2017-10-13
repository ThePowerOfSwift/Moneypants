import Foundation
import Firebase

struct FamilyData {
    static var yearlyIncome: Int! = 0
    static var setupProgress: Int! = 0

    static func getSetupProgressFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("setupProgress").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                setupProgress = value
                print("the user's current setup progress is step \(FamilyData.setupProgress!)")
            }
        })
    }
    
    static func loadExistingIncome() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("income").observe(.value, with: { (snapshot) in
            if let value = snapshot.value as? NSNumber {
                yearlyIncome = value as Int!
                print("family income is: \(yearlyIncome!)")
            }
        })
    }
}
