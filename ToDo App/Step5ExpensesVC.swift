import UIKit

class Step5ExpensesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sportsEnvelope: UIImageView!
    @IBOutlet weak var sportsSubtotal: UILabel!
    @IBOutlet weak var sportsArrow: UIImageView!
    @IBOutlet weak var sportsTableTop: NSLayoutConstraint!
    @IBOutlet weak var sportsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var sportsTableView: UITableView!
    
    @IBOutlet weak var musicArtEnvelope: UIImageView!
    @IBOutlet weak var musicArtArrow: UIImageView!
    @IBOutlet weak var musicArtTableTop: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableHeight: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableView: UITableView!
    
    @IBOutlet weak var schoolEnvelope: UIImageView!
    @IBOutlet weak var schoolArrow: UIImageView!
    @IBOutlet weak var schoolTableTop: NSLayoutConstraint!
    @IBOutlet weak var schoolTableHeight: NSLayoutConstraint!
    @IBOutlet weak var schoolTableView: UITableView!
    
    @IBOutlet weak var summerCampEnvelope: UIImageView!
    @IBOutlet weak var summerCampArrow: UIImageView!
    @IBOutlet weak var summerCampTableTop: NSLayoutConstraint!
    @IBOutlet weak var summerCampTableHeight: NSLayoutConstraint!
    @IBOutlet weak var summerCampTableView: UITableView!
    
    var currentUser: Int!               // passed from Step5VC
    var currentUserName: String!        // passed from Step5VC
    var yearlyOutsideIncome: Int!       // passed from Step5VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDelegatesAndDataSources()
        
        currentUserName = User.usersArray[currentUser].firstName
        navigationItem.title = User.usersArray[currentUser].firstName
        
        fetchExpenses()
        updateSubtotals()
    }
    
    func updateSubtotals() {
        // can probably automate this by iterating over the expensesTitles array to get each category
        for category in Expense.expenseEnvelopeTitles {
            let filteredArray = Expense.expensesArray.filter({ return $0.category == category })
            var sum: Int = 0
            for expense in filteredArray {
                sum += expense.amount
            }
            if category == "sports & dance" {
                
            }
        }
        
        
        
        let sportsArray = Expense.expensesArray.filter({ return $0.category == "sports & dance" })
        var sportsSum: Int = 0
        for expense in sportsArray {
            sportsSum += expense.amount
        }
        sportsSubtotal.text = "\(sportsSum)"
        
        
    }
    
    func tableViewDelegatesAndDataSources() {
        sportsTableView.delegate = self
        sportsTableView.dataSource = self
        sportsTableTop.constant = -(sportsTableView.bounds.height)
        
        musicArtTableView.delegate = self
        musicArtTableView.dataSource = self
        musicArtTableTop.constant = -(musicArtTableView.bounds.height)
        
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
        schoolTableTop.constant = -(schoolTableView.bounds.height)
        
        summerCampTableView.delegate = self
        summerCampTableView.dataSource = self
        summerCampTableTop.constant = -(summerCampTableView.bounds.height)
    }
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case sportsTableView:
            return Expense.expensesArray.filter({ return $0.category == "sports & dance" }).count
        case musicArtTableView:
            return Expense.expensesArray.filter({ return $0.category == "music & art" }).count
        case schoolTableView:
            return Expense.expensesArray.filter({ return $0.category == "school" }).count
        case summerCampTableView:
            return Expense.expensesArray.filter({ return $0.category == "summer camps" }).count
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sportsTableView {
            let cell = sportsTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            let array = Expense.expensesArray.filter({ $0.category == "sports & dance" }).sorted(by: { $0.order < $1.order })
            cell.expensesLabel.text = "\(array[indexPath.row].expenseName)"
            if array[indexPath.row].amount == 0 {
                cell.expenseValue.text = "-"
            } else {
                cell.expenseValue.text = "\(array[indexPath.row].amount)"
            }
            return cell
            
        } else if tableView == musicArtTableView {
            let cell = musicArtTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            let array = Expense.expensesArray.filter({ return $0.category == "music & art" }).sorted(by: { $0.order < $1.order })
            cell.expensesLabel.text = "\(array[indexPath.row].expenseName)"
            if array[indexPath.row].amount == 0 {
                cell.expenseValue.text = "-"
            } else {
                cell.expenseValue.text = "\(array[indexPath.row].amount)"
            }
            return cell
            
        } else if tableView == schoolTableView {
            let cell = schoolTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            let array = Expense.expensesArray.filter({ return $0.category == "school" }).sorted(by: { $0.order < $1.order })
            cell.expensesLabel.text = "\(array[indexPath.row].expenseName)"
            if array[indexPath.row].amount == 0 {
                cell.expenseValue.text = "-"
            } else {
                cell.expenseValue.text = "\(array[indexPath.row].amount)"
            }
            return cell
            
        } else {
            let cell = summerCampTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            let array = Expense.expensesArray.filter({ return $0.category == "summer camps" }).sorted(by: { $0.order < $1.order })
            cell.expensesLabel.text = "\(array[indexPath.row].expenseName)"
            if array[indexPath.row].amount == 0 {
                cell.expenseValue.text = "-"
            } else {
                cell.expenseValue.text = "\(array[indexPath.row].amount)"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sportsTableView {
            performSegue(withIdentifier: "EditExpense", sender: self)       // MARK: TODO - change this sender to be an array point
        }
    }
    
    // ----------
    // Navigation
    // ----------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditExpense" {
            let navigationVC = segue.destination as! UINavigationController
            let nextVC = navigationVC.topViewController as! Step5ExpenseDetailVC
            nextVC.currentUser = currentUser
            nextVC.currentUserName = currentUserName
        }
    }
    
    // MARK: Can I combine all the button taps into one function like below? Just check to see which tableview is showing?
    
    @IBAction func sportsDanceButtonTapped(_ sender: UIButton) {
        if sportsTableTop.constant == -(sportsTableView.bounds.height) {
            revealTable(table: sportsTableView, height: sportsTableHeight, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            // ...and hide all other tables
//            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        } else {
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
        }
    }
    
    @IBAction func musicArtButtonTapped(_ sender: UIButton) {
        if musicArtTableTop.constant == -(musicArtTableView.bounds.height) {
            revealTable(table: musicArtTableView, height: musicArtTableHeight, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
//            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        } else {
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
        }
    }
    
    @IBAction func schoolButtonTapped(_ sender: UIButton) {
        if schoolTableTop.constant == -(schoolTableView.bounds.height) {
            revealTable(table: schoolTableView, height: schoolTableHeight, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
//            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        } else {
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
        }
    }
    
    @IBAction func summerCampButtonTapped(_ sender: UIButton) {
        if summerCampTableTop.constant == -(summerCampTableView.bounds.height) {
            revealTable(table: summerCampTableView, height: summerCampTableHeight, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
//            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        } else {
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        }
    }
    
    
    
    
    
    
    
    
    
    
    // ---------
    // Functions
    // ---------
    
    func revealTable(table: UITableView, height: NSLayoutConstraint, topConstraint: NSLayoutConstraint, arrow: UIImageView, envelope: UIImageView) {
        table.isHidden = false
        // make table size same as number of rows
        height.constant = table.contentSize.height
        // show the opened envelope
        envelope.image = UIImage(named: "envelope white open")
        // rotate the arrow down
        UIView.animate(withDuration: 0.25) { 
            arrow.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
        }
        // show the table
        UIView.animate(withDuration: 0.25) { 
            topConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideTable(table: UITableView, topConstraint: NSLayoutConstraint, arrow: UIImageView, envelope: UIImageView) {
        // rotate the right arrow back up
        UIView.animate(withDuration: 0.25) {
            arrow.transform = CGAffineTransform(rotationAngle: (0 * .pi) / 180.0)
        }
        // show the closed envelope
        envelope.image = UIImage(named: "envelope white")
        // hide the table from view
        UIView.animate(withDuration: 0.25, animations: {
            topConstraint.constant = -(table.bounds.height)
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            table.isHidden = true
        }
    }
    
    func fetchExpenses() {
        if Expense.expensesArray.count == 0 {
            loadDefaultExpenses()
            createDefaultExpensesOnFirebase()
        }
    }
    
    func loadDefaultExpenses() {
        // create array of default expenses
        Expense.expensesArray = [Expense(ownerName: currentUserName, expenseName: "registration fees", category: "sports & dance", amount: 12, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "tuition", category: "sports & dance", amount: 220, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "uniform", category: "sports & dance", amount: 15, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "team shirt", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "equipment", category: "sports & dance", amount: 80, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "competitions", category: "sports & dance", amount: 55, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "performances", category: "sports & dance", amount: 13, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 6),
                                 Expense(ownerName: currentUserName, expenseName: "costumes", category: "sports & dance", amount: 15, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 7),
                                 Expense(ownerName: currentUserName, expenseName: "tuition", category: "music & art", amount: 80, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "supplies & tools", category: "music & art", amount: 71, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "other", category: "music & art", amount: 225, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "field trips", category: "school", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "clubs", category: "school", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "backpack", category: "school", amount: 14, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "supplies", category: "school", amount: 25, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "camp #1", category: "summer camps", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "camp #2", category: "summer camps", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "camp #3", category: "summer camps", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "socks & underwear", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "shoes", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "shirts & pants", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "coats", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "dresses", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "suits", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "swimwear", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 6),
                                 Expense(ownerName: currentUserName, expenseName: "jewelry", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 7),
                                 Expense(ownerName: currentUserName, expenseName: "purses / wallets", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 8),
                                 Expense(ownerName: currentUserName, expenseName: "other", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 9),
                                 Expense(ownerName: currentUserName, expenseName: "phone purchase", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "phone bill", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "software purchase", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "games", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "iPods, iPads, &c", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "bicycle maintenance", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "bike gear", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "gasoline (teen car)", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "car insurance (teen)", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "car maintenance (teen car)", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "other", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "haircuts", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "hair color", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "nails", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "eyebrows", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "makeup", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "hair tools &c", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "other 1", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "other 2", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "other 3", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "other 4", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "other 5", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "fun money", category: "fun money (10%)", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "charitable donations", category: "donations (10%)", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "savings (car)", category: "savings (10%)", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", order: 0)]
    }
    
    func createDefaultExpensesOnFirebase() {
        print("sending default values to Firebase...")
    }
}





















