import Foundation

var yearlyIncomeOutside: Int! = 0
var yearlyIncomeMPS: Int! = 0

struct Expense {
    let expenseCategory: String!
    let expenseName: String!
    let expenseDueDate: NSDate?
    let expenseAmount: Double!
}

var expenseTwo = Expense(expenseCategory: "clothing", expenseName: "socks", expenseDueDate: nil, expenseAmount: 40)

// ---------------------------------------
// global variables for example storyboard
// ---------------------------------------

var pets = ["dog", "fish", "bird"]
var petDescription = ["likes to bark", "swims a lot", "has wings"]




// ------
// sample
// ------

struct Person {
    let firstName: String
    let lastName: String
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
}

let aPerson = Person(firstName: "Beau", lastName: "Papadakis")
let myFullName = aPerson.fullName()
