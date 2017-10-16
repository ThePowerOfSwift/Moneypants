import UIKit
import Firebase

class LoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var progressView: UIProgressView!
    
    var loadingProgress: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        progressView.progress = 0.0

        activityIndicator.startAnimating()
        
        JobsAndHabits.loadPaydayAndInspectionsFromFirebase {
            print("PAYDAY:  ",JobsAndHabits.parentalDailyJobsArray.count)
//            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            self.checkProgress()
        }
        
        JobsAndHabits.loadWeeklyJobsFromFirebase {
            print("WEEKLY JOBS:  ",JobsAndHabits.finalWeeklyJobsArray.count)
//            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            self.checkProgress()
        }
        
        JobsAndHabits.loadDailyJobsFromFirebase {
            print("DAILY JOBS:  ",JobsAndHabits.finalDailyJobsArray.count)
//            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            self.checkProgress()
        }
        
        FamilyData.loadPaydayTimeFromFirebase { (paydayTime) in
            print("PAYDAY TIME:  ",paydayTime)
//            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            self.checkProgress()
        }
        
        FamilyData.getSetupProgressFromFirebase { (setupProgress) in
            print("SETUP PROGRESS:  ",setupProgress)
//            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            self.checkProgress()
        }

        User.loadMembers {
            print("USERS:  ",User.finalUsersArray.count)
//            self.progressView.progress += 0.4
            self.loadingProgress += 0.4
            self.checkProgress()
        }
        
        FamilyData.loadExistingIncome { (income) in
            print("INCOME:  ",income)
//            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            self.checkProgress()
        }
    }
    
    func checkProgress() {
        if self.loadingProgress == 1.0 {
            print("all done downloading")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
        } else {
            print("still waiting...")
        }
        
        
        
        // IF USING PROGRESS BAR
//        if self.progressView.progress == 1.0 {
//            print("all done downloading")
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.hidesWhenStopped = true
//            self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
//        } else {
//            print("still waiting...")
//        }
    }
    
    func checkConnectivity() {
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
            } else {
                print("Not connected")
            }
        })
    }
}
