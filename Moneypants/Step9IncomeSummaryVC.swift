import UIKit
import Firebase

class Step9IncomeSummaryVC: UIViewController {
    
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
    
    var yearlyOutsideIncome: Int!       // passed from Step8OutsideIncomeVC
    var yearlyTotal: Int!
    
    var currentUserName: String!
    var censusKidsMultiplier: Double!
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        userImage.image = MPUser.usersArray[MPUser.currentUser].photo
        navigationItem.title = MPUser.usersArray[MPUser.currentUser].firstName
        
        showDetailsButton.setTitle("show details", for: .normal)
        viewTop.constant = -(detailsView.bounds.height)
        detailsView.isHidden = true
        
        calculateCensusFormulas()
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // update setupProgress
        if FamilyData.setupProgress <= 9 {
            FamilyData.setupProgress = 9
            ref.updateChildValues(["setupProgress" : 9])
        }
        performSegue(withIdentifier: "MemberExpenses", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberExpenses" {
            let nextVC = segue.destination as! Step10ExpensesVC
            nextVC.userTotalIncome = yearlyTotal
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    // CHANGE ALL NUMBERS TO DECIMAL -- UNUSED
    func calculateCensusFormulasWithDecimal() {
//        let secretFormula = Decimal((5.23788 * pow(0.972976, Double(FamilyData.yearlyIncome) / 1000) + 1.56139) / 100)
//        let householdIncome = Decimal(FamilyData.yearlyIncome)
//        let natlAvgYearlySpendingPerKid = householdIncome * secretFormula
//        let numberOfKids = User.usersArray.filter({ return $0.childParent == "child" }).count
//        // adjust multiplier according to census data
//        if numberOfKids >= 3 {
//            censusKidsMultiplier = 0.76
//        } else if numberOfKids == 2 {
//            censusKidsMultiplier = 1
//        } else if numberOfKids <= 1 {
//            censusKidsMultiplier = 1.27
//        }
//        let adjustedNatlAvgYrlySpendingEntireFam = natlAvgYearlySpendingPerKid * censusKidsMultiplier * Decimal(User.usersArray.count)
//        let adjustedNatlAvgYrlySpendingPerKid = natlAvgYearlySpendingPerKid * censusKidsMultiplier
//        let numberOfDailyJobs = JobsAndHabits.finalDailyJobsArray.count
//        let numberOfAssignedDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).count
//        let numberOfWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.count
//        let numberOfAssignedWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).count
//        
//        // need to find the yearly adjusted family income, take 20% of it for each section (in this case, daily jobs), then find the yearly amount, then multiply that by how many jobs user has
//        let homeIncomePerWeekForDailyJobs = (0.20 * adjustedNatlAvgYrlySpendingEntireFam / 52) / Decimal(numberOfDailyJobs) * Decimal(numberOfAssignedDailyJobs)
//        let homeIncomePerWeekForWeeklyJobs = (0.20 * adjustedNatlAvgYrlySpendingEntireFam / 52) / Decimal(numberOfWeeklyJobs) * Decimal(numberOfAssignedWeeklyJobs)
//        let homeIncomePerWeekForHabitsAndBonuses = (0.60 * adjustedNatlAvgYrlySpendingPerKid / 52)
//        let homeIncomePerWeekTotal = homeIncomePerWeekForDailyJobs + homeIncomePerWeekForWeeklyJobs + homeIncomePerWeekForHabitsAndBonuses
//        
//        yearlyTotal = (homeIncomePerWeekTotal * 52) + Decimal(yearlyOutsideIncome)
//        let weeklyTotal = yearlyTotal / 52
//        
//        
//        numberFormatter.numberStyle = NumberFormatter.Style.decimal
//        weeklyIncomeTotalLabel.text = "\(currentUserName!)'s potential weekly income is $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!)."
//        homeIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: homeIncomePerWeekTotal * 52))!) / year"
//        outsideIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyOutsideIncome))!) / year"
//        totalIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) / year"
//        summaryLabel.text = "\(currentUserName!)'s total estimated yearly income is $\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) (about $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!) per week.)"
    }
    
    func calculateCensusFormulas() {
        // get secret formula %
        let secretFormula = ((5.23788 * pow(0.972976, Double(FamilyData.yearlyIncome) / 1000) + 1.56139) / 100) as Double
        let householdIncome = FamilyData.yearlyIncome
        let natlAvgYearlySpendingPerKid = Double(householdIncome) * secretFormula
        let numberOfKids = MPUser.usersArray.filter({ return $0.childParent == "child" }).count
        // adjust multiplier according to census data
        if numberOfKids >= 3 {
            censusKidsMultiplier = 0.76
        } else if numberOfKids == 2 {
            censusKidsMultiplier = 1
        } else if numberOfKids <= 1 {
            censusKidsMultiplier = 1.27
        }
        
        // these two values are basis for all the family points
        FamilyData.adjustedNatlAvgYrlySpendingEntireFam = Int(natlAvgYearlySpendingPerKid * censusKidsMultiplier * Double(MPUser.usersArray.count))
        FamilyData.adjustedNatlAvgYrlySpendingPerKid = Int(natlAvgYearlySpendingPerKid * censusKidsMultiplier)
        
        let numberOfDailyJobs = JobsAndHabits.finalDailyJobsArray.count
        let numberOfAssignedDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).count
        let numberOfWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.count
        let numberOfAssignedWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).count
        
        // need to find the yearly adjusted family income, take 20% of it for each section (in this case, daily jobs), then find the yearly amount, then multiply that by how many jobs user has
        let homeIncomePerWeekForDailyJobs = (0.20 * Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) / 52) / Double(numberOfDailyJobs) * Double(numberOfAssignedDailyJobs)
        let homeIncomePerWeekForWeeklyJobs = (0.20 * Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) / 52) / Double(numberOfWeeklyJobs) * Double(numberOfAssignedWeeklyJobs)
        let homeIncomePerWeekForHabitsAndBonuses = (0.60 * Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52)
        let homeIncomePerWeekTotal = homeIncomePerWeekForDailyJobs + homeIncomePerWeekForWeeklyJobs + homeIncomePerWeekForHabitsAndBonuses
        
        yearlyTotal = Int((homeIncomePerWeekTotal * 52) + Double(yearlyOutsideIncome))
        let weeklyTotal = yearlyTotal / 52
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        weeklyIncomeTotalLabel.text = "\(currentUserName!)'s potential weekly income is $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!)."
        homeIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: Int(homeIncomePerWeekTotal * 52)))!) / year"
        outsideIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyOutsideIncome))!) / year"
        totalIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) / year"
        summaryLabel.text = "\(currentUserName!)'s total estimated yearly income is $\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) (about $\(numberFormatter.string(from: NSNumber(value: Int(weeklyTotal)))!) per week.)"
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
