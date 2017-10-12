import UIKit

class JobsAndHabits {
    
    var name: String
    var multiplier: Double
    var assigned: String
    var order: Int
    
    init(jobName: String, jobMultiplier: Double, jobAssign: String, jobOrder: Int) {
        
        self.name = jobName
        self.multiplier = jobMultiplier
        self.assigned = jobAssign
        self.order = jobOrder
    }
}
