import UIKit

class JobsAndHabits {
    
    var name: String
    var multiplier: Double
    var classification: String
    
    init(jobName: String, jobMultiplier: Double, jobClass: String) {
        
        // job classification must be one of five possible entries:
        // "dailyJob" "dailyHabit" "weeklyJob" "parentDailyJob" "parentWeeklyJob"
        
        self.name = jobName
        self.multiplier = jobMultiplier
        self.classification = jobClass
    }
}
