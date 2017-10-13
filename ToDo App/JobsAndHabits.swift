import UIKit
import Firebase

struct JobsAndHabits {
    var name: String
    var multiplier: Double
    var assigned: String
    var order: Int
    
    static var finalDailyJobsArray = [JobsAndHabits]()
    static var finalWeeklyJobsArray = [JobsAndHabits]()
    static var inspectionParent = ""
    static var paydayParent = ""
    static var paydayTime = ""
    
    static func loadDailyJobsFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let dailyJob = JobsAndHabits(name: name, multiplier: multiplier, assigned: assigned, order: order)
                        finalDailyJobsArray.append(dailyJob)
                        finalDailyJobsArray.sort(by: {$0.order < $1.order})
                        
                        if jobsCount == finalDailyJobsArray.count {
                            print("Excellent. There are",jobsCount,"jobs in the snapshot, and there are",finalDailyJobsArray.count,"jobs in the array")
                        }
                    }
                }
            }
        }
    }
    
    static func loadWeeklyJobsFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let weeklyJob = JobsAndHabits(name: name, multiplier: multiplier, assigned: assigned, order: order)
                        finalWeeklyJobsArray.append(weeklyJob)
                        finalWeeklyJobsArray.sort(by: {$0.order < $1.order})
                        
                        if jobsCount == finalWeeklyJobsArray.count {
                            print("Excellent. There are",jobsCount,"jobs in the snapshot, and there are",finalWeeklyJobsArray.count,"jobs in the array")
                        }
                    }
                }
            }
        }
    }
    
    static func loadPaydayAndInspectionsFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("paydayAndInspections").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let value = snapshot.value as? [String : Any] {
                inspectionParent = value["inspectionParent"] as! String
                paydayParent = value["paydayParent"] as! String
                paydayTime = value["paydayTime"] as! String
                
                print(inspectionParent,paydayParent,paydayTime)
            }
        }
    }
}



