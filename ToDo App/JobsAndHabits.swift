import UIKit

class JobsAndHabits {
    
    var name: String
    var multiplier: Double
    var classification: String
    var order: Int
    
    init(jobName: String, jobMultiplier: Double, jobClass: String, jobOrder: Int) {
        
        // job classification must be one of five possible entries:
        // "dailyJob" "dailyHabit" "weeklyJob" "parentDailyJob" "parentWeeklyJob"
        
        self.name = jobName
        self.multiplier = jobMultiplier
        self.classification = jobClass
        self.order = jobOrder
    }
}
