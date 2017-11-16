import UIKit

class UserProgressPopupVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var earningsIndicatorOverlay: UIImageView!
    
    @IBOutlet weak var habitsProgressBar: UIImageView!
    @IBOutlet weak var totalEarningsProgressBar: UIImageView!
    
    @IBOutlet weak var habitsHeight: NSLayoutConstraint!
    @IBOutlet weak var totalEarningsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    var currentUserName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        weekLabel.text = "for the pay week ending \(formatter.string(from: calculatePayday().next))"
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        
        let jobAndHabitBonusValue = Int(Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.20 * 100)
        let potentialWeeklyEarnings = FamilyData.adjustedNatlAvgYrlySpendingPerKid * 100 / 52
        
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