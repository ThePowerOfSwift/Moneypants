import Foundation

import Firebase

struct OutsideIncome {
    let userName: String
    var allOthers: Int
    var babysitting: Int
    var houseCleaning: Int
    var mowingLawns: Int
    var summerJobs: Int
    
    static var incomeArray = [OutsideIncome]()
    
    static func loadOutsideIncomeFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("outsideIncome").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let outsideIncomeCount = Int(snapshot.childrenCount)
            if outsideIncomeCount == 0 {
                // if there are no outside income amounts, return count 0
                completion()
            } else {
                for item in snapshot.children {
                    let snap = item as? DataSnapshot
                    let userName = snap?.key
                    if let value = snap?.value as? [String : Any] {
                        let allOthers = value["allOthers"] as! Int
                        let babysitting = value["babysitting"] as! Int
                        let houseCleaning = value["houseCleaning"] as! Int
                        let mowingLawns = value["mowingLawns"] as! Int
                        let summerJobs = value["summerJobs"] as! Int
                        
                        let outsideIncome = OutsideIncome(userName: userName!,
                                                          allOthers: allOthers,
                                                          babysitting: babysitting,
                                                          houseCleaning: houseCleaning,
                                                          mowingLawns: mowingLawns,
                                                          summerJobs: summerJobs)
                        incomeArray.append(outsideIncome)
                        
                        if incomeArray.count == outsideIncomeCount {
                            completion()
                        }
                    }
                }
            }
        }
    }
}
