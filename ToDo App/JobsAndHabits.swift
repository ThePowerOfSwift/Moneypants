import UIKit

class JobsAndHabits {
    
    var name: String
    var multiplier: Double
    var assigned: String        // WAS classification
    var order: Int
    
    init(jobName: String, jobMultiplier: Double, jobAssign: String, jobOrder: Int) {
        
        // job classification must be one of five possible entries:
        // "dailyJob" "dailyHabit" "weeklyJob" "parentDailyJob" "parentWeeklyJob"
        
        self.name = jobName
        self.multiplier = jobMultiplier
        self.assigned = jobAssign
        self.order = jobOrder
    }
}
