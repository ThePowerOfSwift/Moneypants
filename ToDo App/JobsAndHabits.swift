import UIKit
import Firebase

struct JobsAndHabits {
    var name: String
    var multiplier: Double
    var assigned: String
    var order: Int
    
    static var finalDailyJobsArray = [JobsAndHabits]()
    static var finalWeeklyJobsArray = [JobsAndHabits]()
    static var parentalDailyJobsArray = [JobsAndHabits]()
    static var parentalWeeklyJobsArray = [JobsAndHabits]()
    
    static func loadDailyJobsFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let dailyJob = JobsAndHabits(name: name, multiplier: multiplier, assigned: assigned, order: order)
                        // MARK: TODO - do I need to change this 'sort' to 'sortby'? so it's non-destructive?
                        finalDailyJobsArray.append(dailyJob)
                        finalDailyJobsArray.sort(by: {$0.order < $1.order})
                    }
                }
            }
        }
    }
    
    static func loadWeeklyJobsFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
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
                    }
                }
            }
        }
    }
    
    static func loadPaydayAndInspectionsFromFirebase() {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("paydayAndInspections").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let paydayAndInspections = JobsAndHabits(name: name, multiplier: multiplier, assigned: assigned, order: order)
                        if name == "daily inspections" {
                            parentalDailyJobsArray.append(paydayAndInspections)
                        } else if name == "weekly payday" {
                            parentalWeeklyJobsArray.append(paydayAndInspections)
                        }
                    }
                }
            }
        }
    }
}



