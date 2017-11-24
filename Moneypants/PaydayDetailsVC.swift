import UIKit

class PaydayDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var paydayCollectionView: UICollectionView!
    @IBOutlet weak var totalEarningsLabel: UILabel!
    
    var currentUserName: String!
    var currentUserIncome: Int!
    
    var paydayData: [(icon: String, category: String, amount: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paydayCollectionView.dataSource = self
        paydayCollectionView.delegate = self
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        currentUserIncome = Income.currentIncomeArray.filter({ $0.user == currentUserName }).first?.currentPoints
        totalEarningsLabel.text = "$\(String(format: "%.2f", Double(currentUserIncome!) / 100))"
        
        createIsoArraysAndSubtotalsForCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = paydayCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! PaydayDetailsCell
        
        if paydayData[indexPath.row].2 == 0 {
            cell.bgImageView.layer.backgroundColor = UIColor.lightGray.cgColor
            cell.categoryImageView.alpha = 0.5
            cell.categoryLabel.alpha = 0.5
            cell.categoryAmountLabel.text = "$ -"
        } else if paydayData[indexPath.row].2 < 0 {
            cell.bgImageView.layer.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1).cgColor
            cell.categoryImageView.alpha = 1.0
            cell.categoryLabel.alpha = 1.0
            cell.categoryAmountLabel.text = "-$\(String(format: "%.2f", Double(abs(paydayData[indexPath.row].2)) / 100))"
        } else {
            cell.bgImageView.layer.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1).cgColor
            cell.categoryImageView.alpha = 1.0
            cell.categoryLabel.alpha = 1.0
            cell.categoryAmountLabel.text = "$\(String(format: "%.2f", Double(paydayData[indexPath.row].2) / 100))"
        }
        
        cell.categoryImageView.image = UIImage(named: paydayData[indexPath.row].0)
        cell.categoryImageView.tintColor = UIColor.white
        cell.categoryLabel.text = paydayData[indexPath.row].1
        
        return cell
    }
    
    // ----------
    // navigation
    // ----------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if paydayData[indexPath.row].2 == 0 {
            noDataInCategoryAlert(indexPath: indexPath)
        } else {
            performSegue(withIdentifier: "PaydayDetailsPopup", sender: paydayData[indexPath.row].1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! PaydayDetailsPopup
        nextVC.categoryLabelText = sender as! String
    }
    
    // ---------
    // functions
    // ---------
    
    func createIsoArraysAndSubtotalsForCategories() {
        // need to recalculate this to only include days since previous payday up to current payday (7 days)
        // what about excused and unexcused daily jobs? need to subtract those from this number
        let dailyJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.code == "C" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        let excusedUnexcusedDailyJobs = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.code == "E" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        let unexcusedDailyJobs = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.code == "X" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        
        
        
        
        
        // and what about the job bonus? Does that go here? How to calculate that?
        // it happens on button tap for daily jobs. When user taps 'daily job', app runs program to see if that day is the seventh day since previous payday. If so, app checks to see if there are any 'x' marks in their points array for daily jobs. If not, then user gets a bonus. It's a Points item, and the code is "B". NOTE: make sure you erase it if user undoes job bonus with an "X". How to do that?
        // question: what if user leaves daily job blank? does it automatically become unexcused?
        
        
        
        
        
        if unexcusedDailyJobs.isEmpty {
            print("user should get their payday bonus...")
        }
        
        let dailyHabitsFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && $0.code == "C" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        let weeklyJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "weekly jobs" && $0.code == "C" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        // what is code for job jar? need to include those completed jobs in here...
        let otherJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "S" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        let feesFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "F" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
        
        // need to setup withdrawals
        //        withdrawalsFilterd = Withdrawal.withdrawalsArray.filter({  })
        
        // all unpaid amounts. How to calculate this?? It can't just be all the transactions that occurred before the past payday...
        // maybe I need to add a 'reconciled' or 'paid' tag to each item on payday?
        // and how far back do I go to get this information? A week? A month?
        let unpaidFiltered = Points.pointsArray.filter({ $0.user == currentUserName && Date(timeIntervalSince1970: $0.itemDate) < FamilyData.calculatePayday().previous })
        
        
        // create daily jobs points subtotal for current user
        var dailyJobsSubtotal: Int = 0
        for item in dailyJobsFiltered {
            dailyJobsSubtotal += item.valuePerTap
        }
        
        // subtract excused jobs
        var dailyJobsExcusedUnexcusedSubtotal: Int = 0
        for item in excusedUnexcusedDailyJobs {
            dailyJobsExcusedUnexcusedSubtotal += item.valuePerTap
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
        
        paydayData = [("broom white", "daily jobs", dailyJobsSubtotal + dailyJobsExcusedUnexcusedSubtotal),
                      ("music white", "daily habits", dailyHabitsSubtotal),
                      ("lawnmower white", "weekly jobs", weeklyJobsSubtotal),
                      ("broom plus white", "other jobs", otherJobsSubtotal),
                      ("dollar minus white", "fees", feesSubtotal),
                      ("shopping cart small white", "withdrawals", 0),
                      ("dollar white", "unpaid", unpaidSubtotal)]
        
        if paydayData.filter({ $0.2 != 0 }).isEmpty {
            noDataAlert()
        }
    }
    
    func noDataInCategoryAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "No Data", message: "\(currentUserName!) has no transactions in '\(paydayData[indexPath.row].1)' for this payday period.", preferredStyle: .alert)
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
}




