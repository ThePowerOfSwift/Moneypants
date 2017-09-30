/*
// FUNCTION #1: Use this for count functions

// this function returns 10 (not 1,2,3,4,5,6,7,8,9,10)
func getDailyJobs(completion: @escaping ([String : Any]) -> ()) {
    ref.child("dailyJobs").observe(.value, with: { (snapshot) in
        completion((snapshot.value as? [String : Any])!)
    })
}

// ViewDidLoad
getDailyJobs { (dailyJobsList) in
    for job in dailyJobsList {
        print(job.key)
    }
}



// =======================================================



// FUNCTION #2

// 2B. This works completely (just need to simplify)
func getDailyJobs2(completion: @escaping ([[String : Any]]) -> ()) {
    var dictionary = [[String : Any]]()
    ref.child("dailyJobs").observe(.value, with: { (snapshot) in
        for child in (snapshot.children) {
            let snap = child as! FIRDataSnapshot
            if let value = snap.value as? [String : Any] {
                dictionary.append(value)
            }
        }
        completion(dictionary)
    })
}

// ViewDidLoad. This works!! Completely.
getDailyJobs2 { (dictionary) in
    print(dictionary.count)
    for item in dictionary {
        let name = item["name"] as! String
        let multiplier = item["multiplier"] as! Double
        let assigned = item["assigned"] as! String
        let order = item["order"] as! Int
        
        let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
        self.dailyJobs.append(dailyJob)
    }
    print(self.dailyJobs.count)
}



// =======================================================



// FUNCTION #3

// don't know why, but this returns items asynchronously: instead of returning count: 10, it returns count: 1,2,3,4,5,6,7,8,9,10. Why?
func getDailyJobs3(completion: @escaping () -> ()) {
    ref.child("dailyJobs").observe(.childAdded, with: { (snapshot) in
        if let value = snapshot.value as? [String : Any] {
            let assigned = value["assigned"] as! String
            let multiplier = value["multiplier"] as! Double
            let name = value["name"] as! String
            let order = value["order"] as! Int
            
            let dailyJobs = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
            self.dailyJobs.append(dailyJob)
            
            completion()
        }
    })
}

// Returns async incrementally, not upon completion. Don't know why
getDailyJobs3 {
    print(self.dailyJobs.count)
}




// =======================================================





*/

    
