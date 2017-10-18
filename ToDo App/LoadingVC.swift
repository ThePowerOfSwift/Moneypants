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
        
        FamilyData.getSetupProgressFromFirebase { (setupProgress) in
            //            self.progressView.progress += 0.1
            self.loadingProgress += 0.1
            print("1. SETUP PROGRESS:  ",setupProgress)
            self.checkProgress()
        }

        
        FamilyData.loadExistingIncome { (income) in
            self.loadingProgress += 0.1
            print("2. INCOME:  ",income)
            self.checkProgress()
        }

        User.loadMembers {
            self.loadingProgress += 0.3
            print("3. USERS:  ",User.finalUsersArray.count)
            self.checkProgress()
        }

        JobsAndHabits.loadDailyJobsFromFirebase {
            self.loadingProgress += 0.1
            print("4. DAILY JOBS:  ",JobsAndHabits.finalDailyJobsArray.count)
            self.checkProgress()
        }

        JobsAndHabits.loadWeeklyJobsFromFirebase {
            self.loadingProgress += 0.1
            print("5. WEEKLY JOBS:  ",JobsAndHabits.finalWeeklyJobsArray.count)
            self.checkProgress()
        }
        
        JobsAndHabits.loadDailyHabitsFromFirebase {
            self.loadingProgress += 0.1
            print("6. DAILY HABITS:  ",JobsAndHabits.finalDailyHabitsArray.count)
            self.checkProgress()
        }
        
        JobsAndHabits.loadPaydayAndInspectionsFromFirebase {
            self.loadingProgress += 0.1
            print("7. PAYDAY:  ",JobsAndHabits.parentalDailyJobsArray.count)
            self.checkProgress()
        }

        FamilyData.loadPaydayTimeFromFirebase { (paydayTime) in
            self.loadingProgress += 0.1
            print("8. PAYDAY TIME:  ",paydayTime)
            self.checkProgress()
        }
    }
    
    func checkProgress() {
        print("Loading Progress: ",loadingProgress)
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
