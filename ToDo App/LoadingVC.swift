import UIKit

class LoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        
        // MARK: TODO - I can put in my progress code here for setup progress, then instantiate different VCs based off of that
        
        // MARK: TODO - need to put these functions in own view controller that has a progress indicator while loading
        FamilyData.getSetupProgressFromFirebase()
        FamilyData.loadPaydayTimeFromFirebase()
        JobsAndHabits.loadDailyJobsFromFirebase()
        JobsAndHabits.loadWeeklyJobsFromFirebase()
        JobsAndHabits.loadPaydayAndInspectionsFromFirebase()
        User.loadMembers()
        
        FamilyData.loadExistingIncome { (income) in
            print(income)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
        }
    }
}
