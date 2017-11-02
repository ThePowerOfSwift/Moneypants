import UIKit

class Step5ExpensesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var sportsEnvelope: UIImageView!
    @IBOutlet weak var sportsSubtotalLabel: UILabel!
    @IBOutlet weak var sportsArrow: UIImageView!
    @IBOutlet weak var sportsTableTop: NSLayoutConstraint!
    @IBOutlet weak var sportsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var sportsTableView: UITableView!
    
    @IBOutlet weak var musicArtEnvelope: UIImageView!
    @IBOutlet weak var musicArtSubtotalLabel: UILabel!
    @IBOutlet weak var musicArtArrow: UIImageView!
    @IBOutlet weak var musicArtTableTop: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableHeight: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableView: UITableView!
    
    @IBOutlet weak var schoolEnvelope: UIImageView!
    @IBOutlet weak var schoolSubtotalLabel: UILabel!
    @IBOutlet weak var schoolArrow: UIImageView!
    @IBOutlet weak var schoolTableTop: NSLayoutConstraint!
    @IBOutlet weak var schoolTableHeight: NSLayoutConstraint!
    @IBOutlet weak var schoolTableView: UITableView!
    
    @IBOutlet weak var summerCampEnvelope: UIImageView!
    @IBOutlet weak var summerCampSubtotalLabel: UILabel!
    @IBOutlet weak var summerCampArrow: UIImageView!
    @IBOutlet weak var summerCampTableTop: NSLayoutConstraint!
    @IBOutlet weak var summerCampTableHeight: NSLayoutConstraint!
    @IBOutlet weak var summerCampTableView: UITableView!
    
    @IBOutlet weak var clothingEnvelope: UIImageView!
    @IBOutlet weak var clothingSubtotalLabel: UILabel!
    @IBOutlet weak var clothingArrow: UIImageView!
    @IBOutlet weak var clothingTableTop: NSLayoutConstraint!
    @IBOutlet weak var clothingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var clothingTableView: UITableView!
    
    @IBOutlet weak var electronicsEnvelope: UIImageView!
    @IBOutlet weak var electronicsSubtotalLabel: UILabel!
    @IBOutlet weak var electronicsArrow: UIImageView!
    @IBOutlet weak var electronicsTableTop: NSLayoutConstraint!
    @IBOutlet weak var electronicsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var electronicsTableView: UITableView!
    
    @IBOutlet weak var transportationEnvelope: UIImageView!
    @IBOutlet weak var transportationSubtotalLabel: UILabel!
    @IBOutlet weak var transportationArrow: UIImageView!
    @IBOutlet weak var transportationTableTop: NSLayoutConstraint!
    @IBOutlet weak var transportationTableHeight: NSLayoutConstraint!
    @IBOutlet weak var transportationTableView: UITableView!
    
    @IBOutlet weak var personalCareEnvelope: UIImageView!
    @IBOutlet weak var personalCareSubtotalLabel: UILabel!
    @IBOutlet weak var personalCareArrow: UIImageView!
    @IBOutlet weak var personalCareTableTop: NSLayoutConstraint!
    @IBOutlet weak var personalCareTableHeight: NSLayoutConstraint!
    @IBOutlet weak var personalCareTableView: UITableView!
    
    @IBOutlet weak var otherEnvelope: UIImageView!
    @IBOutlet weak var otherSubtotalLabel: UILabel!
    @IBOutlet weak var otherArrow: UIImageView!
    @IBOutlet weak var otherTableTop: NSLayoutConstraint!
    @IBOutlet weak var otherTableHeight: NSLayoutConstraint!
    @IBOutlet weak var otherTableView: UITableView!
    
    @IBOutlet weak var funMoneyEnvelope: UIImageView!
    @IBOutlet weak var funMoneySubtotalLabel: UILabel!
    @IBOutlet weak var funMoneyArrow: UIImageView!
    @IBOutlet weak var funMoneyTableTop: NSLayoutConstraint!
    @IBOutlet weak var funMoneyTableHeight: NSLayoutConstraint!
    @IBOutlet weak var funMoneyTableView: UITableView!
    
    @IBOutlet weak var donationsEnvelope: UIImageView!
    @IBOutlet weak var donationsSubtotalLabel: UILabel!
    @IBOutlet weak var donationsArrow: UIImageView!
    @IBOutlet weak var donationsTableTop: NSLayoutConstraint!
    @IBOutlet weak var donationsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var donationsTableView: UITableView!
    
    @IBOutlet weak var savingsEnvelope: UIImageView!
    @IBOutlet weak var savingsSubtotalLabel: UILabel!
    @IBOutlet weak var savingsArrow: UIImageView!
    @IBOutlet weak var savingsTableTop: NSLayoutConstraint!
    @IBOutlet weak var savingsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var savingsTableView: UITableView!
    
    var currentUser: Int!               // passed from Step5VC
    var userTotalIncome: Int!           // passed from Step5VC

    var currentUserName: String!
    var tenPercentOfUserIncome: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeLabel.text = "income: $\(userTotalIncome!)"
        nextButton.isEnabled = false
        
        tableViewDelegatesAndDataSources()
        
        currentUserName = User.usersArray[currentUser].firstName
        navigationItem.title = User.usersArray[currentUser].firstName
        
        tenPercentOfUserIncome = Int(Double(userTotalIncome) * 0.10)
        
        fetchExpenses()
        updateSubtotals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sportsTableView.reloadData()
        musicArtTableView.reloadData()
        schoolTableView.reloadData()
        summerCampTableView.reloadData()
        clothingTableView.reloadData()
        electronicsTableView.reloadData()
        transportationTableView.reloadData()
        personalCareTableView.reloadData()
        otherTableView.reloadData()
        funMoneyTableView.reloadData()
        donationsTableView.reloadData()
        savingsTableView.reloadData()
        updateSubtotals()
    }
    
    func updateSubtotals() {
        let sportsArray = Expense.expensesArray.filter({ return $0.ownerName == currentUserName }).filter({ return $0.category == "sports & dance" })
        var sportsSum: Int = 0
        for expense in sportsArray {
            sportsSum += expense.amount * expense.totalNumberOfPayments
        }
        if sportsSum == 0 {
            sportsSubtotalLabel.text = "-"
        } else {
            sportsSubtotalLabel.text = "\(sportsSum)"
        }
        
        
        let musicArtArray = Expense.expensesArray.filter({ return $0.ownerName == currentUserName }).filter({ return $0.category == "music & art" })
        var musicArtSum: Int = 0
        for expense in musicArtArray {
            musicArtSum += expense.amount * expense.totalNumberOfPayments
        }
        if musicArtSum == 0 {
            musicArtSubtotalLabel.text = "-"
        } else {
            musicArtSubtotalLabel.text = "\(musicArtSum)"
        }
        
        
        let schoolArray = Expense.expensesArray.filter({ return $0.ownerName == currentUserName }).filter({ return $0.category == "school" })
        var schoolSum: Int = 0
        for expense in schoolArray {
            schoolSum += expense.amount * expense.totalNumberOfPayments
        }
        if schoolSum == 0 {
            schoolSubtotalLabel.text = "-"
        } else {
            schoolSubtotalLabel.text = "\(schoolSum)"
        }
        
        
        let summerCampArray = Expense.expensesArray.filter({ return $0.ownerName == currentUserName }).filter({ return $0.category == "summer camps" })
        var summerCampSum: Int = 0
        for expense in summerCampArray {
            summerCampSum += expense.amount * expense.totalNumberOfPayments
        }
        if summerCampSum == 0 {
            summerCampSubtotalLabel.text = "-"
        } else {
            summerCampSubtotalLabel.text = "\(summerCampSum)"
        }
        
        
        let clothingArray = Expense.expensesArray.filter({ $0.ownerName == currentUserName && $0.category == "clothing" })
        var clothingSum: Int = 0
        for expense in clothingArray {
            clothingSum += expense.amount * expense.totalNumberOfPayments
        }
        if clothingSum == 0 {
            clothingSubtotalLabel.text = "-"
        } else {
            clothingSubtotalLabel.text = "\(clothingSum)"
        }
        
        
        let electronicsArray = Expense.expensesArray.filter({ $0.ownerName == currentUserName && $0.category == "electronics" })
        var electronicsSum: Int = 0
        for expense in electronicsArray {
            electronicsSum += expense.amount * expense.totalNumberOfPayments
        }
        if electronicsSum == 0 {
            electronicsSubtotalLabel.text = "-"
        } else {
            electronicsSubtotalLabel.text = "\(electronicsSum)"
        }
        
        
        let transportationArray = Expense.expensesArray.filter({ $0.ownerName == currentUserName && $0.category == "transportation" })
        var transportationSum: Int = 0
        for expense in transportationArray {
            transportationSum += expense.amount * expense.totalNumberOfPayments
        }
        if transportationSum == 0 {
            transportationSubtotalLabel.text = "-"
        } else {
            transportationSubtotalLabel.text = "\(transportationSum)"
        }
        
        
        let personalCareArray = Expense.expensesArray.filter({ $0.ownerName == currentUserName && $0.category == "personal care" })
        var personalCareSum: Int = 0
        for expense in personalCareArray {
            personalCareSum += expense.amount * expense.totalNumberOfPayments
        }
        if personalCareSum == 0 {
            personalCareSubtotalLabel.text = "-"
        } else {
            personalCareSubtotalLabel.text = "\(personalCareSum)"
        }
        
        
        let otherArray = Expense.expensesArray.filter({ $0.ownerName == currentUserName && $0.category == "other" })
        var otherSum: Int = 0
        for expense in otherArray {
            otherSum += expense.amount * expense.totalNumberOfPayments
        }
        if otherSum == 0 {
            otherSubtotalLabel.text = "-"
        } else {
            otherSubtotalLabel.text = "\(otherSum)"
        }
        
        funMoneySubtotalLabel.text = "\(tenPercentOfUserIncome!)"
        donationsSubtotalLabel.text = "\(tenPercentOfUserIncome!)"
        savingsSubtotalLabel.text = "\(tenPercentOfUserIncome!)"
        
        // ---------
        // total sum
        // ---------
        
        let budgetArray = Expense.expensesArray.filter({ return $0.ownerName == currentUserName })
        var totalSum: Int = 0
        for budgetItem in budgetArray {
            totalSum += budgetItem.amount * budgetItem.totalNumberOfPayments
        }
        
        if totalSum == 0 {
            topLabel.text = "GOAL: get 'budget' to match 'income' by adding expenses to the envelopes below."
            budgetLabel.textColor = UIColor.red
            nextButton.isEnabled = false
        } else if totalSum == userTotalIncome {
            topLabel.text = "Excellent! Budget matches income. Please tap 'next' to continue."
            nextButton.isEnabled = true
            budgetLabel.textColor = UIColor.black
        } else if totalSum < userTotalIncome {
            topLabel.text = "You must still add more expenses. Please add $\(userTotalIncome - totalSum) to one or more expense envelopes."
            budgetLabel.textColor = UIColor.red
            nextButton.isEnabled = false
        } else {
            topLabel.text = "You must remove some expenses. Please remove $\(totalSum - userTotalIncome) from one or more expense envelopes."
            budgetLabel.textColor = UIColor.red
            nextButton.isEnabled = false
        }
        budgetLabel.text = "budget: $\(totalSum)"
    }
    
    func tableViewDelegatesAndDataSources() {
        sportsTableView.delegate = self
        sportsTableView.dataSource = self
        sportsTableTop.constant = -(sportsTableView.bounds.height)
        sportsTableView.isHidden = true
        
        musicArtTableView.delegate = self
        musicArtTableView.dataSource = self
        musicArtTableTop.constant = -(musicArtTableView.bounds.height)
        musicArtTableView.isHidden = false
        
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
        schoolTableTop.constant = -(schoolTableView.bounds.height)
        schoolTableView.isHidden = true
        
        summerCampTableView.delegate = self
        summerCampTableView.dataSource = self
        summerCampTableTop.constant = -(summerCampTableView.bounds.height)
        summerCampTableView.isHidden = true
        
        clothingTableView.delegate = self
        clothingTableView.dataSource = self
        clothingTableTop.constant = -(clothingTableView.bounds.height)
        clothingTableView.isHidden = true
        
        electronicsTableView.delegate = self
        electronicsTableView.dataSource = self
        electronicsTableTop.constant = -(electronicsTableView.bounds.height)
        electronicsTableView.isHidden = true
        
        transportationTableView.delegate = self
        transportationTableView.dataSource = self
        transportationTableTop.constant = -(transportationTableView.bounds.height)
        transportationTableView.isHidden = true
        
        personalCareTableView.delegate = self
        personalCareTableView.dataSource = self
        personalCareTableTop.constant = -(personalCareTableView.bounds.height)
        personalCareTableView.isHidden = true
        
        otherTableView.delegate = self
        otherTableView.dataSource = self
        otherTableTop.constant = -(otherTableView.bounds.height)
        otherTableView.isHidden = true
        
        funMoneyTableView.delegate = self
        funMoneyTableView.dataSource = self
        funMoneyTableTop.constant = -(funMoneyTableView.bounds.height)
        funMoneyTableView.isHidden = true
        
        donationsTableView.delegate = self
        donationsTableView.dataSource = self
        donationsTableTop.constant = -(donationsTableView.bounds.height)
        donationsTableView.isHidden = true
        
        savingsTableView.delegate = self
        savingsTableView.dataSource = self
        savingsTableTop.constant = -(savingsTableView.bounds.height)
        savingsTableView.isHidden = true
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
        case clothingTableView:
            return Expense.expensesArray.filter({ return $0.category == "clothing" }).count
        case electronicsTableView:
            return Expense.expensesArray.filter({ return $0.category == "electronics" }).count
        case transportationTableView:
            return Expense.expensesArray.filter({ return $0.category == "transportation" }).count
        case personalCareTableView:
            return Expense.expensesArray.filter({ return $0.category == "personal care" }).count
        case otherTableView:
            return Expense.expensesArray.filter({ return $0.category == "other" }).count
        case funMoneyTableView:
            return Expense.expensesArray.filter({ return $0.category == "fun money" }).count
        case donationsTableView:
            return Expense.expensesArray.filter({ return $0.category == "donations" }).count
        case savingsTableView:
            return Expense.expensesArray.filter({ return $0.category == "savings" }).count
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sportsTableView {
            return formattedTableViewCell(table: sportsTableView, filteredCategory: "sports & dance", indxPth: indexPath)
        } else if tableView == musicArtTableView {
            return formattedTableViewCell(table: musicArtTableView, filteredCategory: "music & art", indxPth: indexPath)
        } else if tableView == schoolTableView {
            return formattedTableViewCell(table: schoolTableView, filteredCategory: "school", indxPth: indexPath)
        } else if tableView == summerCampTableView {
            return formattedTableViewCell(table: summerCampTableView, filteredCategory: "summer camps", indxPth: indexPath)
        } else if tableView == clothingTableView {
            return formattedTableViewCell(table: clothingTableView, filteredCategory: "clothing", indxPth: indexPath)
        } else if tableView == electronicsTableView {
            return formattedTableViewCell(table: electronicsTableView, filteredCategory: "electronics", indxPth: indexPath)
        } else if tableView == transportationTableView {
            return formattedTableViewCell(table: transportationTableView, filteredCategory: "transportation", indxPth: indexPath)
        } else if tableView == personalCareTableView {
            return formattedTableViewCell(table: personalCareTableView, filteredCategory: "personal care", indxPth: indexPath)
        } else if tableView == otherTableView {
            return formattedTableViewCell(table: otherTableView, filteredCategory: "other", indxPth: indexPath)
        } else if tableView == funMoneyTableView {
            return formattedTableViewCell(table: funMoneyTableView, filteredCategory: "fun money", indxPth: indexPath)
        } else if tableView == donationsTableView {
            return formattedTableViewCell(table: donationsTableView, filteredCategory: "donations", indxPth: indexPath)
        } else {    // if tableView == savingsTableView {
            return formattedTableViewCell(table: savingsTableView, filteredCategory: "savings", indxPth: indexPath)
        }
    }
    
    func formattedTableViewCell(table: UITableView, filteredCategory: String, indxPth: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "expensesCell", for: indxPth) as! Step5ExpensesCell
        let array = Expense.expensesArray.filter({ return $0.category == filteredCategory }).sorted(by: { $0.order < $1.order })
        cell.expensesLabel.text = "\(array[indxPth.row].expenseName)"
        if array[indxPth.row].amount == 0 {
            cell.expenseValue.text = "-"
        } else {
            cell.expenseValue.text = "\(array[indxPth.row].amount * array[indxPth.row].totalNumberOfPayments)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case sportsTableView:
            let sportsArray = Expense.expensesArray.filter({ return $0.category == "sports & dance" })
            performSegue(withIdentifier: "EditExpense", sender: sportsArray[indexPath.row])
        case musicArtTableView:
            let musicArtArray = Expense.expensesArray.filter({ $0.category == "music & art" })
            performSegue(withIdentifier: "EditExpense", sender: musicArtArray[indexPath.row])
        case schoolTableView:
            let schoolArray = Expense.expensesArray.filter({ $0.category == "school" })
            performSegue(withIdentifier: "EditExpense", sender: schoolArray[indexPath.row])
        case summerCampTableView:
            let summerCampArray = Expense.expensesArray.filter({ $0.category == "summer camps" })
            performSegue(withIdentifier: "EditExpense", sender: summerCampArray[indexPath.row])
        case clothingTableView:
            let clothingArray = Expense.expensesArray.filter({ $0.category == "clothing" })
            performSegue(withIdentifier: "EditExpense", sender: clothingArray[indexPath.row])
        case electronicsTableView:
            let electronicsArray = Expense.expensesArray.filter({ $0.category == "electronics" })
            performSegue(withIdentifier: "EditExpense", sender: electronicsArray[indexPath.row])
        case transportationTableView:
            let transportationArray = Expense.expensesArray.filter({ $0.category == "transportation" })
            performSegue(withIdentifier: "EditExpense", sender: transportationArray[indexPath.row])
        case personalCareTableView:
            let personalCareArray = Expense.expensesArray.filter({ $0.category == "personal care" })
            performSegue(withIdentifier: "EditExpense", sender: personalCareArray[indexPath.row])
        case otherTableView:
            let otherArray = Expense.expensesArray.filter({ $0.category == "other" })
            performSegue(withIdentifier: "EditExpense", sender: otherArray[indexPath.row])
        case funMoneyTableView:
            let funMoneyArray = Expense.expensesArray.filter({ $0.category == "fun money" })
            performSegue(withIdentifier: "ShowSavings", sender: funMoneyArray[indexPath.row])
        case donationsTableView:
            let donationsArray = Expense.expensesArray.filter({ $0.category == "donations" })
            performSegue(withIdentifier: "ShowSavings", sender: donationsArray[indexPath.row])
        case savingsTableView:
            let savingsArray = Expense.expensesArray.filter({ $0.category == "savings" })
            performSegue(withIdentifier: "ShowSavings", sender: savingsArray[indexPath.row])
        default:
            print("unknown tableview selected")
        }
        
//        if tableView == sportsTableView {
//            let sportsArray = Expense.expensesArray.filter({ return $0.category == "sports & dance" })
//            performSegue(withIdentifier: "EditExpense", sender: sportsArray[indexPath.row])
//        } else if tableView == musicArtTableView {
//            let musicArtArray = Expense.expensesArray.filter({ $0.category == "music & art" })
//            performSegue(withIdentifier: "EditExpense", sender: musicArtArray[indexPath.row])
//        }
    }
    
    // ----------
    // Navigation
    // ----------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditExpense" {
            let navigationVC = segue.destination as! UINavigationController
            let nextVC = navigationVC.topViewController as! Step5ExpenseDetailVC
            nextVC.currentUser = currentUser
            nextVC.expense = sender as? Expense
        } else if segue.identifier == "ShowSavings" {
            let navigationVC = segue.destination as! UINavigationController
            let nextVC = navigationVC.topViewController as! Step5ExpenseDetailVC
            nextVC.currentUser = currentUser
            nextVC.expense = sender as? Expense
            nextVC.expenseAmountCellIsEnabled = false
            nextVC.hasDueDateCellIsEnabled = false
            nextVC.expenseAmountDollarSignLabelColor = UIColor.lightGray
            nextVC.expenseAmountTextFieldColor = UIColor.lightGray
            nextVC.hasDueDateLabelColor = UIColor.lightGray
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentUser < (User.usersArray.count - 1) {
            currentUser! += 1
            let storyboard = UIStoryboard(name: "Setup", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Step5VC")
            
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            performSegue(withIdentifier: "Congrats", sender: self)
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
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
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
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
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
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
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
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        }
    }
    
    @IBAction func clothingButtonTapped(_ sender: UIButton) {
        if clothingTableTop.constant == -(clothingTableView.bounds.height) {
            revealTable(table: clothingTableView, height: clothingTableHeight, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
//                        hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
        }
    }
    
    @IBAction func electronicsButtonTapped(_ sender: UIButton) {
        if electronicsTableTop.constant == -(electronicsTableView.bounds.height) {
            revealTable(table: electronicsTableView, height: electronicsTableHeight, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
//            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
        }
    }
    
    @IBAction func transportationButtonTapped(_ sender: UIButton) {
        if transportationTableTop.constant == -(transportationTableView.bounds.height) {
            revealTable(table: transportationTableView, height: transportationTableHeight, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
//            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
        }
    }
    
    @IBAction func personalCareButtonTapped(_ sender: UIButton) {
        if personalCareTableTop.constant == -(personalCareTableView.bounds.height) {
            revealTable(table: personalCareTableView, height: personalCareTableHeight, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
//            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
        }
    }
    
    @IBAction func otherButtonTapped(_ sender: UIButton) {
        if otherTableTop.constant == -(otherTableView.bounds.height) {
            revealTable(table: otherTableView, height: otherTableHeight, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            //            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
        }
    }
    
    @IBAction func funMoneyButtonTapped(_ sender: UIButton) {
        funMoneyDonationsButtonsTapped()
    }
    
    @IBAction func donationsButtonTapped(_ sender: UIButton) {
        funMoneyDonationsButtonsTapped()
    }
    
    @IBAction func savingsButtonTapped(_ sender: UIButton) {
        if savingsTableTop.constant == -(savingsTableView.bounds.height) {
            revealTable(table: savingsTableView, height: savingsTableHeight, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
            // ...and hide all other tables
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
            hideTable(table: clothingTableView, topConstraint: clothingTableTop, arrow: clothingArrow, envelope: clothingEnvelope)
            hideTable(table: electronicsTableView, topConstraint: electronicsTableTop, arrow: electronicsArrow, envelope: electronicsEnvelope)
            hideTable(table: transportationTableView, topConstraint: transportationTableTop, arrow: transportationArrow, envelope: transportationEnvelope)
            hideTable(table: personalCareTableView, topConstraint: personalCareTableTop, arrow: personalCareArrow, envelope: personalCareEnvelope)
            hideTable(table: otherTableView, topConstraint: otherTableTop, arrow: otherArrow, envelope: otherEnvelope)
            hideTable(table: funMoneyTableView, topConstraint: funMoneyTableTop, arrow: funMoneyArrow, envelope: funMoneyEnvelope)
            hideTable(table: donationsTableView, topConstraint: donationsTableTop, arrow: donationsArrow, envelope: donationsEnvelope)
            //            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        } else {
            hideTable(table: savingsTableView, topConstraint: savingsTableTop, arrow: savingsArrow, envelope: savingsEnvelope)
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func funMoneyDonationsButtonsTapped() {
        let alert = UIAlertController(title: "Cannot Edit", message: "'Fun Money' and 'Donations' are automatically calculated and cannot be edited.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
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
        Expense.expensesArray = [Expense(ownerName: currentUserName, expenseName: "registration fees", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "tuition", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "uniform", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "team shirt", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "equipment", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "competitions", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "performances", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 6),
                                 Expense(ownerName: currentUserName, expenseName: "costumes", category: "sports & dance", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 7),
                                 Expense(ownerName: currentUserName, expenseName: "tuition", category: "music & art", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "supplies & tools", category: "music & art", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "other", category: "music & art", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "field trips", category: "school", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "clubs", category: "school", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "backpack", category: "school", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "supplies", category: "school", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "camp #1", category: "summer camps", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "camp #2", category: "summer camps", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "camp #3", category: "summer camps", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "socks & underwear", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "shoes", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "shirts & pants", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "coats", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "dresses", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "suits", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "swimwear", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 6),
                                 Expense(ownerName: currentUserName, expenseName: "jewelry", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 7),
                                 Expense(ownerName: currentUserName, expenseName: "purses / wallets", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 8),
                                 Expense(ownerName: currentUserName, expenseName: "other", category: "clothing", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 9),
                                 Expense(ownerName: currentUserName, expenseName: "phone purchase", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "phone bill", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "software purchase", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "games", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "iPods, iPads, &c", category: "electronics", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "bicycle maintenance", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "bike gear", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "gasoline (teen car)", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "car insurance (teen)", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "car maintenance (teen car)", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "other", category: "transportation", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "haircuts", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "hair color", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "nails", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "eyebrows", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "makeup", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "hair tools &c", category: "personal care", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 5),
                                 Expense(ownerName: currentUserName, expenseName: "other #1", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "other #2", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 1),
                                 Expense(ownerName: currentUserName, expenseName: "other #3", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 2),
                                 Expense(ownerName: currentUserName, expenseName: "other #4", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 3),
                                 Expense(ownerName: currentUserName, expenseName: "other #5", category: "other", amount: 0, hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 4),
                                 Expense(ownerName: currentUserName, expenseName: "fun money", category: "fun money", amount: Int(tenPercentOfUserIncome), hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "charitable donations", category: "donations", amount: Int(tenPercentOfUserIncome), hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0),
                                 Expense(ownerName: currentUserName, expenseName: "savings for...", category: "savings", amount: Int(tenPercentOfUserIncome), hasDueDate: false, firstPayment: "none", repeats: "never", finalPayment: "none", totalNumberOfPayments: 1, order: 0)]
    }
    
    func createDefaultExpensesOnFirebase() {
        print("sending default values to Firebase...")
    }
}





















