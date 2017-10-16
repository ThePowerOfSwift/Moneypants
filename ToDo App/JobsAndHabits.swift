import UIKit
import Firebase

struct JobsAndHabits {
    var name: String
    var description: String
    var assigned: String
    var order: Int
    
    static var finalDailyJobsArray = [JobsAndHabits]()
    static var finalWeeklyJobsArray = [JobsAndHabits]()
    static var parentalDailyJobsArray = [JobsAndHabits]()
    static var parentalWeeklyJobsArray = [JobsAndHabits]()
    
    static func loadDailyJobsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let description = value["description"] as! String
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let dailyJob = JobsAndHabits(name: name, description: description, assigned: assigned, order: order)
                        // MARK: TODO - do I need to change this 'sort' to 'sortby'? so it's non-destructive?
                        finalDailyJobsArray.append(dailyJob)
                        finalDailyJobsArray.sort(by: {$0.order < $1.order})
                        
                        if finalDailyJobsArray.count == jobsCount {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    static func loadWeeklyJobsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let description = value["description"] as! String
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let weeklyJob = JobsAndHabits(name: name, description: description, assigned: assigned, order: order)
                        finalWeeklyJobsArray.append(weeklyJob)
                        finalWeeklyJobsArray.sort(by: {$0.order < $1.order})
                        
                        if finalWeeklyJobsArray.count == jobsCount {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    static func loadPaydayAndInspectionsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = FIRAuth.auth()?.currentUser
        let ref = FIRDatabase.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("paydayAndInspections").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let description = value["description"] as! String
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let paydayAndInspections = JobsAndHabits(name: name, description: description, assigned: assigned, order: order)
                        if name == "daily inspections" {
                            parentalDailyJobsArray.append(paydayAndInspections)
                        } else if name == "weekly payday" {
                            parentalWeeklyJobsArray.append(paydayAndInspections)
                        }
                        
                        if parentalDailyJobsArray.count + parentalWeeklyJobsArray.count == jobsCount {
                            completion()
                        }
                    }
                }
            }
        }
    }
}



