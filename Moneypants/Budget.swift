import UIKit
import Firebase

struct Budget {
    var ownerName: String
    var expenseName: String
    var category: String
    var amount: Int
    var hasDueDate: Bool
    var firstPayment: String
    var repeats: String
    var finalPayment: String
    var totalNumberOfPayments: Int
    var order: Int
    
    static var budgetsArray = [Budget]()
    
    static let expenseEnvelopeTitles = ["sports & dance",
                                        "music & art",
                                        "school",
                                        "summer camps",
                                        "clothing",
                                        "electronics",
                                        "transportation",
                                        "personal care",
                                        "other",
                                        "fun money",
                                        "donations",
                                        "savings"]
    
    static func loadBudgetsFromFirebase(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("budgets").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if !snapshot.exists() {
                print("no budgets yet")
                completion()
            } else {
                let usersWithBudgets = Int(snapshot.childrenCount)
                var downloadedUsersWithBudgets = 0
                for user in MPUser.usersArray {
                    ref.child("budgets").child(user.firstName).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                        let budgetCount = Int(snapshot.childrenCount)
                        // if there are no budgets on Firebase, return count 0
                        if budgetCount == 0 {
                            print(user.firstName,"has no budget")
                            return
                        } else {
                            downloadedUsersWithBudgets += 1
                            for item in snapshot.children {
                                if let snap = item as? DataSnapshot {
                                    if let value = snap.value as? [String : Any] {
                                        let ownerName = value["ownerName"] as! String
                                        let expenseName = value["expenseName"] as! String
                                        let category = value["category"] as! String
                                        let amount = value["amount"] as! Int
                                        let hasDueDate = value["hasDueDate"] as! Bool
                                        let firstPayment = value["firstPayment"] as! String
                                        let repeats = value["repeats"] as! String
                                        let finalPayment = value["finalPayment"] as! String
                                        let totalNumberOfPayments = value["totalNumberOfPayments"] as! Int
                                        let order = value["order"] as! Int
                                        
                                        let userBudget = Budget(ownerName: ownerName, expenseName: expenseName, category: category, amount: amount, hasDueDate: hasDueDate, firstPayment: firstPayment, repeats: repeats, finalPayment: finalPayment, totalNumberOfPayments: totalNumberOfPayments, order: order)
                                        
                                        budgetsArray.append(userBudget)
                                    }
                                }
                            }
                            // wait until all users with budgets have been downloaded
                            if downloadedUsersWithBudgets == usersWithBudgets {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
}
