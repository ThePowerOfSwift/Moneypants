import UIKit

class UserProgressPopupVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var earningsIndicatorOverlay: UIImageView!
    
    @IBOutlet weak var habitsProgressBar: UIImageView!
    @IBOutlet weak var totalEarningsProgressBar: UIImageView!
    
    @IBOutlet weak var habitsMeterLabel: UILabel!
    @IBOutlet weak var totalMeterLabel: UILabel!
    @IBOutlet weak var habitBonusLabel: UILabel!
    
    @IBOutlet weak var habitsHeight: NSLayoutConstraint!
    @IBOutlet weak var totalEarningsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    var currentUserName: String!
    var jobAndHabitBonusValue: Int!
    var potentialWeeklyEarnings: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        weekLabel.text = "for the pay week ending \(formatter.string(from: FamilyData.calculatePayday().next))"
        
        print(FamilyData.calculatePayday().next)
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        
        jobAndHabitBonusValue = Int(Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.20 * 100)
        potentialWeeklyEarnings = FamilyData.adjustedNatlAvgYrlySpendingPerKid * 100 / 52
        
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        popupViewTop.layer.cornerRadius = 50
        popupViewTopWhite.layer.cornerRadius = 40
        
        earningsIndicatorOverlay.layer.cornerRadius = 5
        earningsIndicatorOverlay.layer.masksToBounds = true
        
        habitsProgressBar.layer.cornerRadius = 2
        habitsProgressBar.layer.masksToBounds = true
        totalEarningsProgressBar.layer.cornerRadius = 2
        totalEarningsProgressBar.layer.masksToBounds = true
        
        habitsHeight.constant = earningsIndicatorOverlay.bounds.height * CGFloat(pointsEarnedSinceLastPayday().habits) / CGFloat(jobAndHabitBonusValue)
        totalEarningsHeight.constant = earningsIndicatorOverlay.bounds.height * CGFloat(pointsEarnedSinceLastPayday().total) / CGFloat(potentialWeeklyEarnings)
        
//        print("job and habit bonus value:",jobAndHabitBonusValue)
//        print("75% would be at:",Double(jobAndHabitBonusValue) * 0.75)
//        print("potential weekly earnings:",potentialWeeklyEarnings)
//        print("total points still needed:",potentialWeeklyEarnings - pointsEarnedSinceLastPayday().total)
//        print("total points halfway point:",potentialWeeklyEarnings / 2)
        
        updateMeterAppearance()
    }
    
    // ----------
    // navigation
    // ----------
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // ---------
    // functions
    // ---------
    
    func updateMeterAppearance() {
        
        // -----------
        // habit meter
        // -----------
        
        // if user has not earned at least a third of their total habit amount, then hide the text label
        if pointsEarnedSinceLastPayday().habits < (jobAndHabitBonusValue / 3) {
            // hide the bottom text
            habitsMeterLabel.isHidden = true
            // show the 'bonus' goal
            habitBonusLabel.isHidden = false
            // make the progress bar purple
            habitsProgressBar.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0) // purple
            
            // if user has earned between 1/3 and 75% of their bonus, then show the label and the 'bonus' goal
        } else if pointsEarnedSinceLastPayday().habits > (jobAndHabitBonusValue / 3) && pointsEarnedSinceLastPayday().habits < Int(Double(jobAndHabitBonusValue) * 0.75) {
            // show the habits meter text
            habitsMeterLabel.isHidden = false
            habitsMeterLabel.text = "\(Int((Double(jobAndHabitBonusValue) * 0.75)) - pointsEarnedSinceLastPayday().habits) points\nneeded to\nearn bonus"
            // hide the 'bonus' goal
            habitBonusLabel.isHidden = true
            // make the progress bar purple
            habitsProgressBar.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0) // purple
            
            // if user has earned bonus, hide 'bonus' text and change meter label text to 'bonus earned'
        } else if pointsEarnedSinceLastPayday().habits >= Int(Double(jobAndHabitBonusValue) * 0.75) {
            // hide the habits meter text
            habitsMeterLabel.text = "bonus earned!"
            // hide the bonus goal
            habitBonusLabel.isHidden = true
            // make the progress bar gree
            habitsProgressBar.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0) // green
        }
        
        // -----------
        // total meter
        // -----------
        
        // if user has not earned at least a third of their total weekly amount, then hide the text label
        if pointsEarnedSinceLastPayday().total < (potentialWeeklyEarnings / 3) {
            totalMeterLabel.isHidden = true
            
            // if user has earned between 1/3 and 100% of their total, then show the meter label text
        } else if pointsEarnedSinceLastPayday().total >= (potentialWeeklyEarnings / 3) && pointsEarnedSinceLastPayday().total < potentialWeeklyEarnings {
            totalMeterLabel.text = "\(potentialWeeklyEarnings - pointsEarnedSinceLastPayday().total) points\nneeded to\nmeet budget"
        } else {
            totalMeterLabel.text = "budget\nenvelopes\nfull for this\npay period"
        }
    }
    
    func pointsEarnedSinceLastPayday() -> (dailyJobs: Int, habits: Int, weeklyJobs: Int, total: Int) {
        // calculate how much user has earned for all jobs and habits since last payday
        // create array to isolate current user's points for all days that are greater than last payday
        let totalPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().current })
        var pointsSubtotal: Int = 0
        for pointsItem in totalPointsEarnedSinceLastPayday {
            pointsSubtotal += pointsItem.valuePerTap
        }
        
        let habitPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && $0.code == "C" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().current })
        var habitsSubtotal: Int = 0
        for pointsItem in habitPointsEarnedSinceLastPayday {
            habitsSubtotal += pointsItem.valuePerTap
        }
        
        let dailyJobsPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().current })
        var dailyJobsSubtotal: Int = 0
        for pointsItem in dailyJobsPointsEarnedSinceLastPayday {
            dailyJobsSubtotal += pointsItem.valuePerTap
        }
        
        let weeklyJobsPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "weekly jobs" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().current })
        var weeklyJobsSubtotal: Int = 0
        for pointsItem in weeklyJobsPointsEarnedSinceLastPayday {
            weeklyJobsSubtotal += pointsItem.valuePerTap
        }
        
        return (dailyJobsSubtotal, habitsSubtotal, weeklyJobsSubtotal, pointsSubtotal)
    }
}
