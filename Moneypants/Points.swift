import Foundation

struct Points {
    var numberOfTapsEX: String
    var valuePerTap: Int
    var itemName: String
    var itemCategory: String
    var itemDate: Double
    var user: String
    
    static var pointsArray = [Points]()
    
    // numerOfTaps (this is for showing a number in the box, but also for calculating the total for that job for that day)
    // valuePerTap (this is the point value calculated from the magic number)
    // itemName (this is for updating the array with the proper item)
    // itemCategory (this is for future reports)
    // itemDate (this is a timestamp for calculating several things: max # of taps per day, job bonus, reports)
    // user (this is for filtering the array so the points are assigned to the right person)
}
