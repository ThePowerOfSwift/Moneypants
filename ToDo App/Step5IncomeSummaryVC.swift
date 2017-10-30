import UIKit

class Step5IncomeSummaryVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var showDetailsButton: UIButton!
    @IBOutlet weak var weeklyIncomeTotalLabel: UILabel!
    @IBOutlet weak var homeIncomeLabel: UILabel!
    @IBOutlet weak var outsideIncomeLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let numberFormatter = NumberFormatter()
    
    var currentUser: Int!               // passed from Step5VC
    var yearlyOutsideIncome: Int!       // passed from Step5VC
    
    var currentUserName: String!
    var censusKidsMultiplier: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserName = User.usersArray[currentUser].firstName
        userImage.image = User.usersArray[currentUser].photo
        navigationItem.title = User.usersArray[currentUser].firstName
        
        showDetailsButton.setTitle("show details", for: .normal)
        viewTop.constant = -(detailsView.bounds.height)
        detailsView.isHidden = true
        
        calculateCensusFormulas()
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // MARK: TODO - update setupProgress

        performSegue(withIdentifier: "MemberExpenses", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberExpenses" {
            let nextVC = segue.destination as! Step5ExpensesVC
            nextVC.currentUser = currentUser
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func calculateCensusFormulas() {
        let secretFormula = ((5.23788 * pow(0.972976, Double(FamilyData.yearlyIncome) / 1000) + 1.56139) / 100) as Double
        let householdIncome = FamilyData.yearlyIncome
        let natlAvgYearlySpendingPerKid = Double(householdIncome!) * secretFormula
        let numberOfKids = User.usersArray.filter({ return $0.childParent == "child" }).count
        // adjust multiplier according to census data
        if numberOfKids >= 3 {
            censusKidsMultiplier = 0.76
        } else if numberOfKids == 2 {
            censusKidsMultiplier = 1
        } else if numberOfKids <= 1 {
            censusKidsMultiplier = 1.27
        }
        let adjustedNatlAvgYrlySpendingEntireFam = natlAvgYearlySpendingPerKid * censusKidsMultiplier * Double(User.usersArray.count)
        let adjustedNatlAvgYrlySpendingPerKid = natlAvgYearlySpendingPerKid * censusKidsMultiplier
        let numberOfDailyJobs = JobsAndHabits.finalDailyJobsArray.count
        let numberOfAssignedDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).count
        let numberOfWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.count
        let numberOfAssignedWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).count
        
        // need to find the yearly adjusted family income, take 20% of it for each section (in this case, daily jobs), then find the yearly amount, then multiply that by how many jobs user has
        let homeIncomePerWeekForDailyJobs = (0.20 * adjustedNatlAvgYrlySpendingEntireFam / 52) / Double(numberOfDailyJobs) * Double(numberOfAssignedDailyJobs)
        let homeIncomePerWeekForWeeklyJobs = (0.20 * adjustedNatlAvgYrlySpendingEntireFam / 52) / Double(numberOfWeeklyJobs) * Double(numberOfAssignedWeeklyJobs)
        let homeIncomePerWeekForHabitsAndBonuses = (0.60 * adjustedNatlAvgYrlySpendingPerKid / 52)
        
        let homeIncomePerWeekTotal = Int(homeIncomePerWeekForDailyJobs + homeIncomePerWeekForWeeklyJobs + homeIncomePerWeekForHabitsAndBonuses)
        let yearlyTotal = (homeIncomePerWeekTotal * 52) + yearlyOutsideIncome
        let weeklyTotal = Int(yearlyTotal / 52)
        
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        weeklyIncomeTotalLabel.text = "\(currentUserName!)'s potential weekly income is $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!)."
        homeIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: homeIncomePerWeekTotal * 52))!) / year"
        outsideIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyOutsideIncome))!) / year"
        totalIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) / year"
        summaryLabel.text = "\(currentUserName!)'s total estimated yearly income is $\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) (about $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!) per week.)"
    }
    
    @IBAction func showDetailsButtonTapped(_ sender: UIButton) {
        if viewTop.constant == -(detailsView.bounds.height) {
            detailsView.isHidden = false
            showDetailsButton.setTitle("hide details", for: .normal)
            self.viewTop.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.viewTop.constant = -(self.detailsView.bounds.height)
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            showDetailsButton.setTitle("show details", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.detailsView.isHidden = true
            }
        }
    }
}
