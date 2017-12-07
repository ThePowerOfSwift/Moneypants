import UIKit
import Firebase

class PaydayDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var paydayCollectionView: UICollectionView!
    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    
    var currentUserName: String!
    var paydayEarnings: Int!
    var previousPayday: TimeInterval!
    var currentPayday: TimeInterval!
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    var paydayData: [(icon: String, category: String, amount: Int)] = []
    var totalEarningsFormatted: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paydayCollectionView.dataSource = self
        paydayCollectionView.delegate = self
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        questionButton.layer.cornerRadius = questionButton.layer.bounds.height / 6.4
        questionButton.layer.masksToBounds = true
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        // get array of current user's income for all categories except withdrawals, and then total the amounts
        paydayEarnings = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.code != "W" &&
            $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
            $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 }).reduce(0, { $0 + $1.valuePerTap })
        
        totalEarningsFormatted = "$\(String(format: "%.2f", Double(paydayEarnings!) / 100))"
        totalEarningsLabel.text = totalEarningsFormatted
        
        previousPayday = FamilyData.calculatePayday().previous.timeIntervalSince1970
        currentPayday = FamilyData.calculatePayday().current.timeIntervalSince1970
        
        Points.updateJobBonus()
        createIsoArraysAndSubtotalsForCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = paydayCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! PaydayDetailsCell
        
        if paydayData[indexPath.row].amount == 0 {
            cell.bgImageView.layer.backgroundColor = UIColor.lightGray.cgColor
            cell.categoryImageView.alpha = 0.5
            cell.categoryLabel.alpha = 0.5
            cell.categoryAmountLabel.text = "$ -"
        } else if paydayData[indexPath.row].amount < 0 {
            cell.bgImageView.layer.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1).cgColor
            cell.categoryImageView.alpha = 1.0
            cell.categoryLabel.alpha = 1.0
            cell.categoryAmountLabel.text = "-$\(String(format: "%.2f", Double(abs(paydayData[indexPath.row].amount)) / 100))"
        } else {
            cell.bgImageView.layer.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1).cgColor
            cell.categoryImageView.alpha = 1.0
            cell.categoryLabel.alpha = 1.0
            cell.categoryAmountLabel.text = "$\(String(format: "%.2f", Double(paydayData[indexPath.row].amount) / 100))"
        }
        
        cell.categoryImageView.image = UIImage(named: paydayData[indexPath.row].icon)
        cell.categoryImageView.tintColor = UIColor.white
        cell.categoryLabel.text = paydayData[indexPath.row].category
        
        return cell
    }
    
    // ----------
    // navigation
    // ----------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if paydayData[indexPath.row].amount == 0 {
            noDataInCategoryAlert(indexPath: indexPath)
        } else {
            performSegue(withIdentifier: "PaydayDetailsPopup", sender: paydayData[indexPath.row].category)
        }
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let tenPercentOfEarnings = Int((Double(paydayEarnings) * 0.10).rounded(.up))
        let remainingSeventyPercent = paydayEarnings - (tenPercentOfEarnings * 3)       // remaining money after 10-10-10
        
        let messageText = NSMutableAttributedString(string: "\(currentUserName!) earned \(totalEarningsFormatted!). Be sure to compliment progress.\n\n\(MPUser.gender(user: MPUser.currentUser).his_her) money will be allocated like this:\n\n\t10% charity\t\t\t= $\(String(format: "%.2f", Double(tenPercentOfEarnings) / 100))\n\t10% personal money\t= $\(String(format: "%.2f", Double(tenPercentOfEarnings) / 100))\n\t10% savings\t\t\t= $\(String(format: "%.2f", Double(tenPercentOfEarnings) / 100))\n\n\t70% expenses\t\t= $\(String(format: "%.2f", Double(remainingSeventyPercent) / 100))\n\nWhen you are done paying \(currentUserName!), click 'okay'. This will zero out \(MPUser.gender(user: MPUser.currentUser).his_her.lowercased()) account for the pay period and mark \(MPUser.gender(user: MPUser.currentUser).him_her.lowercased()) as 'paid'.",
            attributes: [NSParagraphStyleAttributeName : paragraphStyle,
                         NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                         NSForegroundColorAttributeName : UIColor.black])
        // Not sure what this does, but it works
        let alert = UIAlertController(title: "\(currentUserName!)'s Payday", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "okay"
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Okay. Pay \(currentUserName!) \(totalEarningsFormatted!)", style: .default, handler: { (action) in
            self.allocateIncomeToEnvelopes()
            self.markUserAsPaid()
            
            self.withdrawalDialogueIfNeeded()
            _ = self.navigationController?.popViewController(animated: true)
            
            
            
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaydayDetailsPopup" {
            let nextVC = segue.destination as! PaydayDetailsPopup
            nextVC.categoryLabelText = sender as! String
        }
    }
    
    // ---------
    // functions
    // ---------
    
    func withdrawalDialogueIfNeeded() {
        let withdrawalsList = Points.pointsArray.filter({ $0.code == "W" && $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        if !withdrawalsList.isEmpty {
            let alert = UIAlertController(title: "Withdrawals", message: "\(currentUserName!) has some withdrawals to pay for:\n\n\(withdrawalsList)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "These items are now paid", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func markUserAsPaid() {
        if let incomeIndex = Income.currentIncomeArray.index(where: { $0.user == currentUserName }) {
            // create payday item for user and append to points array
            let paydayItem = Points(user: currentUserName,
                                    itemName: "week ending \(FamilyData.calculatePayday().current.timeIntervalSince1970)",
                                    itemCategory: "payday",
                                    code: "C",
                                    valuePerTap: -(paydayEarnings),
                                    itemDate: Date().timeIntervalSince1970,
                                    paid: true)
            
            Points.pointsArray.append(paydayItem)
            
            // subtract payday amount from user's total income
            Income.currentIncomeArray[incomeIndex].currentPoints -= paydayEarnings
        }
        
        // mark all payday items as 'paid' for current user
        for (index, points) in Points.pointsArray.enumerated() {
            if points.user == currentUserName &&
                points.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
                points.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 {
                
                Points.pointsArray[index].paid = true
            }
        }
    }
    
    func createIsoArraysAndSubtotalsForCategories() {
        // need to recalculate this to only include days since previous payday up to current payday (7 days)
        // what about excused and unexcused daily jobs? need to subtract those from this number
        let dailyJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "daily jobs" &&
            ($0.code == "C" || $0.code == "B") &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        let excusedDailyJobs = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "daily jobs" &&
            $0.code == "E" &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        let unexcusedDailyJobs = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "daily jobs" &&
            $0.code == "X" &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        let dailyHabitsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "daily habits" &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        let weeklyJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "weekly jobs" &&
            ($0.code == "C" || $0.code == "N") &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        // what is code for job jar? need to include those completed jobs in here...
        let otherJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.code == "S" &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        let feesFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.code == "F" &&
            $0.itemDate >= previousPayday &&
            $0.itemDate < currentPayday })
        
        // need to setup withdrawals
        //        withdrawalsFilterd = Withdrawal.withdrawalsArray.filter({  })
        
        // all unpaid amounts. How to calculate this?? It can't just be all the transactions that occurred before the past payday...
        // maybe I need to add a 'reconciled' or 'paid' tag to each item on payday?
        // and how far back do I go to get this information? A week? A month?
        
        let unpaidFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemDate < previousPayday })
        
        // create daily jobs points subtotal for current user
        var dailyJobsSubtotal: Int = 0
        for item in dailyJobsFiltered {
            dailyJobsSubtotal += item.valuePerTap
        }
        
        // subtract excused jobs
        var dailyJobsExcusedSubtotal: Int = 0
        for item in excusedDailyJobs {
            dailyJobsExcusedSubtotal += item.valuePerTap
        }
        
        var dailyJobsUnexcusedSubtotal: Int = 0
        for item in unexcusedDailyJobs {
            dailyJobsUnexcusedSubtotal += item.valuePerTap
        }
        
        var dailyHabitsSubtotal: Int = 0
        for item in dailyHabitsFiltered {
            dailyHabitsSubtotal += item.valuePerTap
        }
        
        var weeklyJobsSubtotal: Int = 0
        for item in weeklyJobsFiltered {
            weeklyJobsSubtotal += item.valuePerTap
        }
        
        var otherJobsSubtotal: Int = 0
        for item in otherJobsFiltered {
            otherJobsSubtotal += item.valuePerTap
        }
        
        var feesSubtotal: Int = 0
        for item in feesFiltered {
            feesSubtotal += item.valuePerTap
        }
        
        var unpaidSubtotal: Int = 0
        for item in unpaidFiltered {
            unpaidSubtotal += item.valuePerTap
        }
        
        paydayData = [("broom", "daily jobs", dailyJobsSubtotal + dailyJobsExcusedSubtotal + dailyJobsUnexcusedSubtotal),
                      ("workout", "daily habits", dailyHabitsSubtotal),
                      ("lawnmower white", "weekly jobs", weeklyJobsSubtotal),
                      ("broom plus white", "other jobs", otherJobsSubtotal),
                      ("dollar minus white", "fees", feesSubtotal),
                      ("dollar white", "unpaid", unpaidSubtotal),
                      ("shopping cart small white", "withdrawals", 0)]
        
        if paydayData.filter({ $0.amount != 0 }).isEmpty {
            noDataAlert()
        }
    }
    
    func noDataInCategoryAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "No Data", message: "\(currentUserName!) has no transactions in '\(paydayData[indexPath.row].category)' for this payday period.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func noDataAlert() {
        let alert = UIAlertController(title: "No Data", message: "\(currentUserName!) has no transactions for this payday period.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func allocateIncomeToEnvelopes() {
        // 1. get an iso array for current user and their budgeted items (items that aren't budgeted as zero)
        let budgetIso = Budget.budgetsArray.filter({ $0.ownerName == currentUserName && $0.amount > 0 })
        let tenPercentOfEarnings = Int((Double(paydayEarnings) * 0.10).rounded(.up))
        let remainingSeventyPercent = paydayEarnings - (tenPercentOfEarnings * 3)
        
        // do all the math HERE for allocating income to the envelopes
        for (budgetIndex, budgetItem) in Budget.budgetsArray.enumerated() {
            if budgetItem.category == "donations" && budgetItem.ownerName == currentUserName {
                Budget.budgetsArray[budgetIndex].currentValue += tenPercentOfEarnings
            }
            if budgetItem.category == "savings" && budgetItem.ownerName == currentUserName {
                Budget.budgetsArray[budgetIndex].currentValue += tenPercentOfEarnings
            }
            if budgetItem.category == "fun money" && budgetItem.ownerName == currentUserName {
                Budget.budgetsArray[budgetIndex].currentValue += tenPercentOfEarnings
            }
        }
        // determine if user can pay all their bills without parental help (this is actually done back in step 10 of setup)
        print(budgetIso)
        
        
        
        
        
        
        let allBills = budgetIso.reduce(0, { $0 + ($1.amount * $1.totalNumberOfPayments) })
        print("Q:",allBills)
        
        
        
        
        
        
        
        /*

        // get list of bills with due dates (Father has two) first
        // get bill with most recent due date
        // if there's enough money, pay that bill
        // if not, pay what is available and that's it.
        // then move on to next most recent due date bill
        // if there's enough money, pay that bill
        // if not, pay what is available
        // if there's money left over after paying bills with due dates, fill other envelopes in current order (clothing, personal care, sports, music, etc.)
        let billsWithDueDates = budgetIso.filter({ $0.hasDueDate == true }).sorted(by: { $0.firstPayment < $1.firstPayment })
        // calculate how much money user should be putting into the first bill...
        
        for bill in billsWithDueDates {
            // get total amount for year
            print("R:",bill.amount / 365.26 * 7)
            
            // convert YYYYMMDD to just YYYYMM (make day first day of month)
            let timestamp = bill.firstPayment
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let convertedDateFromTimestamp = formatter.date(from: timestamp)
            let components = Calendar.current.dateComponents([.year, .month], from: convertedDateFromTimestamp!)
            let startOfBillMonth = Calendar.current.date(from: components)
            print("S:",startOfBillMonth)
            
            // calculate how much money should go into the bill's envelope
            // need to find out how many paydays will occur between now and when bill is due
            print("T:",FamilyData.calculatePayday().current)
            let numberOfWeeksTilDue = startOfBillMonth?.weeks(from: FamilyData.calculatePayday().current)
            print("U:",numberOfWeeksTilDue)
            
//            let numberOfWeeks = convertedDateFromTimestamp?.weeks(from: FamilyData.calculatePayday().current)
//            print("Q:",numberOfWeeks)
//            print("R:",bill.amount / numberOfWeeks!)
        }
        */
        
        
        

//        print(billsWithDueDates)
//        
//        
//        
//        print(remainingSeventyPercent)
    }
}




