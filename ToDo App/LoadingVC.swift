import UIKit
import Firebase

class LoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var loadingProgress: Double = 0
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0.0

        activityIndicator.startAnimating()
        
        FamilyData.getSetupProgressFromFirebase { (setupProgress) in
            self.progressView.setProgress(0.1, animated: true)
            print("1. SETUP PROGRESS:  ",setupProgress)
            
            FamilyData.loadExistingIncome { (income) in
                self.progressView.setProgress(0.2, animated: true)
                print("2. INCOME:  ",income)
                
                User.loadMembers {
                    self.progressView.setProgress(0.3, animated: true)
                    print("3. USERS:  ",User.usersArray.count)
                    
                    JobsAndHabits.loadDailyJobsFromFirebase {
                        self.progressView.setProgress(0.4, animated: true)
                        print("4. DAILY JOBS:  ",JobsAndHabits.finalDailyJobsArray.count)
                        
                        JobsAndHabits.loadWeeklyJobsFromFirebase {
                            self.progressView.setProgress(0.5, animated: true)
                            print("5. WEEKLY JOBS:  ",JobsAndHabits.finalWeeklyJobsArray.count)
                            
                            JobsAndHabits.loadDailyHabitsFromFirebase {
                                self.progressView.setProgress(0.6, animated: true)
                                print("6. DAILY HABITS:  ",JobsAndHabits.finalDailyHabitsArray.count)
                                
                                JobsAndHabits.loadPaydayAndInspectionsFromFirebase {
                                    self.progressView.setProgress(0.7, animated: true)
                                    print("7. PAYDAY:  ",JobsAndHabits.parentalDailyJobsArray.count)
                                    
                                    FamilyData.loadPaydayTimeFromFirebase { (paydayTime) in
                                        self.progressView.setProgress(0.8, animated: true)
                                        print("8. PAYDAY TIME:  ",paydayTime)
                                        
                                        OutsideIncome.loadOutsideIncomeFromFirebase {
                                            self.progressView.setProgress(0.9, animated: true)
                                            print("9. OUTSIDE INCOME")
                                            
                                            Expense.loadBudgetsFromFirebase {
                                                self.progressView.setProgress(1.0, animated: true)
                                                print("10. BUDGETS",Expense.budgetsArray.count)
                                                
                                                self.activityIndicator.stopAnimating()
                                                self.activityIndicator.hidesWhenStopped = true
                                                
                                                // if user has completed setup, go to home page
                                                if FamilyData.setupProgress == 11 {
                                                    print("user has completed setup. Loading home page...")
                                                    
                                                    self.performSegue(withIdentifier: "Home", sender: self)
                                                    
//                                                    self.window = UIWindow(frame: UIScreen.main.bounds)
//                                                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
//                                                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
//                                                    self.window?.rootViewController = initialViewController
//                                                    self.window?.makeKeyAndVisible()
                                                    
                                                    
                                                } else {
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
        }
    }
}
