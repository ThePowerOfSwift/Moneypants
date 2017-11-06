import UIKit
import Firebase

struct JobsAndHabits {
    var name: String
    var description: String
    var assigned: String
    var order: Int
    
    static var finalDailyJobsArray = [JobsAndHabits]()
    static var finalWeeklyJobsArray = [JobsAndHabits]()
    static var finalDailyHabitsArray = [JobsAndHabits]()
    static var parentalDailyJobsArray = [JobsAndHabits]()
    static var parentalWeeklyJobsArray = [JobsAndHabits]()
    
    static func loadDailyJobsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            // if there are no jobs on Firebase, return count 0
            if jobsCount == 0 {
                completion()
                return
            } else {
                for item in snapshot.children {
                    if let snap = item as? DataSnapshot {
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
    }
    
    static func loadWeeklyJobsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            // if there are no jobs on Firebase, return count 0
            if jobsCount == 0 {
                completion()
                return
            } else {
                for item in snapshot.children {
                    if let snap = item as? DataSnapshot {
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
    }
    
    static func loadDailyHabitsFromFirebase(completion: @escaping () -> ()) {
        // have to get users list first, then get each uers's daily habits
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("members").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let usersCount = Int(snapshot.childrenCount)
            if usersCount == 0 {
                print("No users created yet")
                completion()
                return
            } else {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let username = snap.key
                    ref.child("dailyHabits").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
                        let habitsCount = Int(snapshot.childrenCount)
                        if habitsCount == 0 {
                            print("no habits created yet")
                            completion()
                            return
                        } else {
                            for item in snapshot.children {
                                if let snap = item as? DataSnapshot {
                                    if let value = snap.value as? [String : Any] {
                                        let assigned = value["assigned"] as! String
                                        let description = value["description"] as! String
                                        let name = value["name"] as! String
                                        let order = value["order"] as! Int
                                        
                                        let dailyHabit = JobsAndHabits(name: name, description: description, assigned: assigned, order: order)
                                        finalDailyHabitsArray.append(dailyHabit)
                                        finalDailyHabitsArray.sort(by: { $0.assigned < $1.assigned })
                                        // check to see that there are 10 jobs per user times the number of users
                                        if finalDailyHabitsArray.count == usersCount * habitsCount {
                                            completion()
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    static func loadPaydayAndInspectionsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("paydayAndInspections").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let jobsCount = Int(snapshot.childrenCount)
            // if there are no jobs on Firebase, return count 0
            if jobsCount == 0 {
                completion()
                return
            } else {
                for item in snapshot.children {
                    if let snap = item as? DataSnapshot {
                        if let value = snap.value as? [String : Any] {
                            let description = value["description"] as! String
                            let name = value["name"] as! String
                            let assigned = value["assigned"] as! String
                            let order = value["order"] as! Int
                            
                            let paydayAndInspections = JobsAndHabits(name: name, description: description, assigned: assigned, order: order)
                            if name == "job inspections" {
                                parentalDailyJobsArray.append(paydayAndInspections)
                            } else if name == "payday" {
                                parentalWeeklyJobsArray.append(paydayAndInspections)
                            }
                            
                            if parentalDailyJobsArray.count + parentalWeeklyJobsArray.count == jobsCount {
                                print("parent daily jobs count and parent weekly jobs count = ",jobsCount)
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
}



