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
        
        weekLabel.text = "for the pay week ending \(formatter.string(from: calculatePayday().next))"
        
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
        
        print("job and habit bonus value:",jobAndHabitBonusValue)
        print("75% would be at:",Double(jobAndHabitBonusValue) * 0.75)
        print("potential weekly earnings:",potentialWeeklyEarnings)
        print("total points still needed:",potentialWeeklyEarnings - pointsEarnedSinceLastPayday().total)
        print("total points halfway point:",potentialWeeklyEarnings / 2)
        
        showOrHidePointsNeeded()
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
    
    func showOrHidePointsNeeded() {
        habitsMeterLabel.text = "\(Int((Double(jobAndHabitBonusValue) * 0.75)) - pointsEarnedSinceLastPayday().habits) points needed to earn bonus"
        totalMeterLabel.text = "\(potentialWeeklyEarnings - pointsEarnedSinceLastPayday().total) points needed to meet budget"
        
        // if user has earned at least half of their total habit amount, then show the tedt label
        if (jobAndHabitBonusValue - pointsEarnedSinceLastPayday().habits) < (jobAndHabitBonusValue / 2) {
            habitsMeterLabel.isHidden = false
        } else {
            habitsMeterLabel.isHidden = true
        }
        
        // if user has earned at least half of their total weekly amount, then show the text label
        if (potentialWeeklyEarnings - pointsEarnedSinceLastPayday().total < (potentialWeeklyEarnings / 2)) {
            totalMeterLabel.isHidden = false
        } else {
            totalMeterLabel.isHidden = true
        }
    }
    
    func pointsEarnedSinceLastPayday() -> (dailyJobs: Int, habits: Int, weeklyJobs: Int, total: Int) {
        // calculate how much user has earned for all jobs and habits since last payday
        // create array to isolate current user's points for all days that are greater than last payday
        let totalPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && Date(timeIntervalSince1970: $0.itemDate) >= calculatePayday().last })
        var pointsSubtotal: Int = 0
        for pointsItem in totalPointsEarnedSinceLastPayday {
            pointsSubtotal += pointsItem.valuePerTap
        }
        
        let habitPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && Date(timeIntervalSince1970: $0.itemDate) >= calculatePayday().last })
        var habitsSubtotal: Int = 0
        for pointsItem in habitPointsEarnedSinceLastPayday {
            habitsSubtotal += pointsItem.valuePerTap
        }
        
        let dailyJobsPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && Date(timeIntervalSince1970: $0.itemDate) >= calculatePayday().last })
        var dailyJobsSubtotal: Int = 0
        for pointsItem in dailyJobsPointsEarnedSinceLastPayday {
            dailyJobsSubtotal += pointsItem.valuePerTap
        }
        
        let weeklyJobsPointsEarnedSinceLastPayday = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "weekly jobs" && Date(timeIntervalSince1970: $0.itemDate) >= calculatePayday().last })
        var weeklyJobsSubtotal: Int = 0
        for pointsItem in weeklyJobsPointsEarnedSinceLastPayday {
            weeklyJobsSubtotal += pointsItem.valuePerTap
        }
        
        return (dailyJobsSubtotal, habitsSubtotal, weeklyJobsSubtotal, pointsSubtotal)
    }
    
    func calculatePayday() -> (last: Date, next: Date) {
        let today = Date()
        var lastPayday: Date!
        var nextPayday: Date!
        
        for n in 1...7 {
            let previousDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -n, to: today)
            // format previous date to show weekday in long format
            // if weekday matches payday, then count number of days since then and only subtotal values since then
            let formatterLong = DateFormatter()
            formatterLong.dateFormat = "EEEE"
            
            if formatterLong.string(from: previousDate!).contains("Saturday") {
                lastPayday = previousDate
            }
        }
        nextPayday = Calendar.current.date(byAdding: Calendar.Component.day, value: 7, to: lastPayday)
        return (lastPayday, nextPayday)
    }
}
