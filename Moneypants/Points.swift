import Foundation

struct Points {
    var user: String
    var itemName: String
    var itemCategory: String
    var codeCEXSN: String
    var valuePerTap: Int
    var itemDate: Double
    
    static var pointsArray = [Points]()
    
    // codeCEXSN:
    // C = completed (for daily jobs, daily habits, and weekly jobs)
    // E = excused (for daily jobs only)
    // X = unexcused (for daily jobs only)
    // S = sub (for daily and weekly jobs)
    // N = not complete (for habits and weekly jobs)
}
