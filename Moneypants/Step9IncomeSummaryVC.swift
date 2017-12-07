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
    
    func calculateCensusFormulas() {
        let numberOfDailyJobs = JobsAndHabits.finalDailyJobsArray.count
        let numberOfAssignedDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).count
        let numberOfWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.count
        let numberOfAssignedWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).count
        // need to find the yearly adjusted family income, take 20% of it for each section (in this case, daily jobs), then find the yearly amount, then multiply that by how many jobs user has
        
        // daily jobs
        let dailyJobPointsPerInstance = (Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) * 0.20 / 365.26 / Double(numberOfDailyJobs) * 100).rounded(.up)
        let homeIncomePerWeekForDailyJobs = Int(dailyJobPointsPerInstance) * 7 * numberOfAssignedDailyJobs
        
        // daily habits (include priority habit and 9 regular habits)
        let priorityHabitPointsPerInstance = (Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 365.26 * 0.065 * 100).rounded(.up)
        let regularHabitPointsPerInstance = (Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 365.26 * 0.015 * 100).rounded(.up)
        let homeIncomePerWeekForHabits = Int((priorityHabitPointsPerInstance * 7) + (regularHabitPointsPerInstance * 9 * 7))
        
        // weekly jobs
        let weeklyJobPointsPerInstance = (Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) * 0.20 / 52.18 / Double(numberOfWeeklyJobs) * 100).rounded(.up)
        let homeIncomePerWeekForWeeklyJobs = Int(weeklyJobPointsPerInstance) * numberOfAssignedWeeklyJobs
        
        // weekly and yearly totals (include daily jobs, daily habits, weekly jobs, and both job bonus and habit bonus -- each worth 20%)
        let homeIncomePerWeek = homeIncomePerWeekForDailyJobs + homeIncomePerWeekForHabits + homeIncomePerWeekForWeeklyJobs + (FamilyData.jobAndHabitBonusValue * 2)
        let homeIncomePerYear = Int(Double(homeIncomePerWeek) * 52.18)
        let outsideIncomePerWeek = Int(Double(yearlyOutsideIncome) / 52.18 * 100)
        let outsideIncomePerYear = yearlyOutsideIncome * 100
        let totalIncomePerWeek = homeIncomePerWeek + outsideIncomePerWeek
        let totalIncomePerYear = homeIncomePerYear + outsideIncomePerYear
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        
        weeklyIncomeTotalLabel.text = "\(currentUserName!)'s potential weekly income is $\(formatter.string(from: NSNumber(value: homeIncomePerWeek / 100))!)."
        homeIncomeLabel.text = "$\(formatter.string(from: NSNumber(value: homeIncomePerYear / 100))!) / year"
        outsideIncomeLabel.text = "$\(formatter.string(from: NSNumber(value: outsideIncomePerYear / 100))!) / year"
        totalIncomeLabel.text = "$\(formatter.string(from: NSNumber(value: totalIncomePerYear / 100))!) / year"
        summaryLabel.text = "\(currentUserName!)'s total estimated yearly income is $\(formatter.string(from: NSNumber(value: totalIncomePerYear / 100))!) (about $\(formatter.string(from: NSNumber(value: totalIncomePerWeek / 100))!) per week.)"
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
