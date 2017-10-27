import Foundation
import UIKit

struct Expense {
    var ownerName: String
    var expenseName: String
    var category: String
    var amount: Int
    var hasDueDate: Bool
    var firstPayment: String
    var repeats: String
    var finalPayment: String
    var order: Int
    
    static var expensesArray = [Expense]()
    
    static let expenseEnvelopeTitles = ["sports & dance",
                                        "music & art",
                                        "school",
                                        "summer camps",
                                        "clothing",
                                        "electronics",
                                        "transportation",
                                        "personal care",
                                        "other",
                                        "fun money (10%)",
                                        "donations (10%)",
                                        "savings (10%)"]
}
