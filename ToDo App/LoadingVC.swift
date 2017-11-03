import UIKit
import Firebase

class LoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var progressView: UIProgressView!
    
    var loadingProgress: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        progressView.progress = 0.0
        
        
//        Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { (timer) in
//            if self.loadingProgress < 1.0 {
//                print("error. connection taking too long to load")
//                let alert = UIAlertController(title: "Network Error", message: "The Moneypants Solution app is taking too long to load. Please check your connection and try again.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
//                    alert.dismiss(animated: true, completion: nil)
//                    do {
//                        try FIRAuth.auth()?.signOut()
//                        let storyBoard: UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
//                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") // as! LoginViewController
//                        self.present(newViewController, animated: true, completion: nil)
//                    } catch let error {
//                        assertionFailure("Error signing out: \(error)")
//                    }
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
        
        
        
//        JobsAndHabits.loadPaydayAndInspectionsFromFirebase {
//            print("F:  ",JobsAndHabits.parentalDailyJobsArray)
//            self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
//        }
        

        activityIndicator.startAnimating()
        
        FamilyData.getSetupProgressFromFirebase { (setupProgress) in
            //            self.progressView.progress += 0.1
            print("1. SETUP PROGRESS:  ",setupProgress)
            
            FamilyData.loadExistingIncome { (income) in
                print("2. INCOME:  ",income)
                
                User.loadMembers {
                    print("3. USERS:  ",User.usersArray.count)
                    
                    JobsAndHabits.loadDailyJobsFromFirebase {
                        print("4. DAILY JOBS:  ",JobsAndHabits.finalDailyJobsArray.count)
                        
                        JobsAndHabits.loadWeeklyJobsFromFirebase {
                            print("5. WEEKLY JOBS:  ",JobsAndHabits.finalWeeklyJobsArray.count)
                            
                            JobsAndHabits.loadDailyHabitsFromFirebase {
                                print("6. DAILY HABITS:  ",JobsAndHabits.finalDailyHabitsArray.count)
                                
                                JobsAndHabits.loadPaydayAndInspectionsFromFirebase {
                                    print("7. PAYDAY:  ",JobsAndHabits.parentalDailyJobsArray.count)
                                    
                                    FamilyData.loadPaydayTimeFromFirebase { (paydayTime) in
                                        print("8. PAYDAY TIME:  ",paydayTime)
                                        
                                        OutsideIncome.loadOutsideIncomeFromFirebase {
                                            print("9. OUTSIDE INCOME")
                                            
                                            Expense.loadBudgetsFromFirebase {
                                                print("10. BUDGETS",Expense.expensesArray.count)
                                            
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.hidesWhenStopped = true
                                                self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        
        
        
        
        
//        FamilyData.loadExistingIncome { (income) in
//            self.loadingProgress += 0.1
//            print("2. INCOME:  ",income)
//            self.checkProgress()
//        }

//        User.loadMembers {
//            self.loadingProgress += 0.2
//            print("3. USERS:  ",User.usersArray.count)
//            self.checkProgress()
//        }

//        JobsAndHabits.loadDailyJobsFromFirebase {
//            self.loadingProgress += 0.1
//            print("4. DAILY JOBS:  ",JobsAndHabits.finalDailyJobsArray.count)
//            self.checkProgress()
//        }

//        JobsAndHabits.loadWeeklyJobsFromFirebase {
//            self.loadingProgress += 0.1
//            print("5. WEEKLY JOBS:  ",JobsAndHabits.finalWeeklyJobsArray.count)
//            self.checkProgress()
//        }
        
//        JobsAndHabits.loadDailyHabitsFromFirebase {
//            self.loadingProgress += 0.1
//            print("6. DAILY HABITS:  ",JobsAndHabits.finalDailyHabitsArray.count)
//            self.checkProgress()
//        }
//        
//        JobsAndHabits.loadPaydayAndInspectionsFromFirebase {
//            self.loadingProgress += 0.1
//            print("7. PAYDAY:  ",JobsAndHabits.parentalDailyJobsArray.count)
//            self.checkProgress()
//        }
//
//        FamilyData.loadPaydayTimeFromFirebase { (paydayTime) in
//            self.loadingProgress += 0.1
//            print("8. PAYDAY TIME:  ",paydayTime)
//            self.checkProgress()
//        }
//        
//        OutsideIncome.loadOutsideIncomeFromFirebase {
//            self.loadingProgress += 0.1
//            print("9. OUTSIDE INCOME")
//            self.checkProgress()
//        }
    }
    
//    func checkProgress() {
//        print("Loading Progress: ",loadingProgress)
//        if self.loadingProgress >= 1.0 {
//            print("all done downloading")
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.hidesWhenStopped = true
//            self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
//        } else {
//            print("still waiting...")
//        }
    
        
        
        // IF USING PROGRESS BAR
//        if self.progressView.progress == 1.0 {
//            print("all done downloading")
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.hidesWhenStopped = true
//            self.performSegue(withIdentifier: "GoToStep1EnterIncome", sender: self)
//        } else {
//            print("still waiting...")
//        }
//    }
    
//    func checkConnectivity() {
//        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
//        connectedRef.observe(.value, with: { snapshot in
//            if snapshot.value as? Bool ?? false {
//                print("Connected")
//            } else {
//                print("Not connected")
//            }
//        })
//    }
}
