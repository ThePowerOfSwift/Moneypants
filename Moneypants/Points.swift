import Foundation

struct Points {
    var user: String
    var itemName: String
    var itemCategory: String
    var completedEX: String
    var valuePerTap: Int
    var itemDate: Double
    
    static var pointsArray = [Points]()
    
    // numerOfTaps (this is for showing a number in the box)
    // valuePerTap (this is the point value calculated from the magic number)
    // itemName (this is for updating the array with the proper item)
    // itemCategory (this is for future reports)
    // itemDate (this is a timestamp for calculating several things: max # of taps per day, job bonus, reports)
    // user (this is for filtering the array so the points are assigned to the right person)
}
