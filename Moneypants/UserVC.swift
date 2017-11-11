import UIKit

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLower: UILabel!
    @IBOutlet weak var greenGrid: UIButton!
    
    let feesDebts: [String] = ["add a fee...", "add a withdrawal..."]
    
    var currentUserName: String!
    
    var usersDailyJobs: [JobsAndHabits]!
    var usersDailyHabits: [JobsAndHabits]!
    var usersWeeklyJobs: [JobsAndHabits]!
    var dailyJobsPointValue: Int!
    var priorityHabitPointValue: Int!
    var regularHabitPointValue: Int!
    var weeklyJobsPointValue: Int!
    var substituteFee: Int!
    
    var subFeeFormatted: String!
    var excusedTitle: String!
    var excusedMessage: String!
    var unexcusedTitle: String!
    var unexcusedMessage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------
        // badges
        // ------
        
        tabBarController?.tabBar.items?[2].badgeValue = "1"
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        userImage.image = MPUser.usersArray[MPUser.currentUser].photo
        
        userImage.layer.cornerRadius = topView.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        greenGrid.layer.cornerRadius = greenGrid.bounds.height / 6.4
        greenGrid.layer.masksToBounds = true
        greenGrid.layer.borderWidth = 0.5
        greenGrid.layer.borderColor = UIColor.black.cgColor
        
        usersDailyJobs = JobsAndHabits.finalDailyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == currentUserName })
        usersDailyHabits = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == currentUserName })
        usersWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == currentUserName })
        dailyJobsPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) * 0.20 / 52 / Double(JobsAndHabits.finalDailyJobsArray.count) * 100 / 7).rounded(.up))
        priorityHabitPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.065 / 7 * 100).rounded(.up))
        regularHabitPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.015 / 7 * 100).rounded(.up))
        weeklyJobsPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) * 0.2 / 52 / Double(JobsAndHabits.finalWeeklyJobsArray.count) * 100).rounded(.up))
        substituteFee = FamilyData.feeValueMultiplier / usersDailyJobs.count
        
        checkIncome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == currentUserName })
        let userDailyHabits = JobsAndHabits.finalDailyHabitsArray.filter({ return $0.assigned == currentUserName })
        let userWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ return $0.assigned == currentUserName })
        let subJobsArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.codeCEXSN == "S" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
        if section == 0 {
            return userDailyJobs.count
        } else if section == 1 {
            return userDailyHabits.count
        } else if section == 2 {
            return userWeeklyJobs.count
        } else if section == 3 {
            return subJobsArray.count
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else if section == 1 {
            return "daily habits"
        } else if section == 2 {
            return "weekly jobs"
        } else if section == 3 {
            return "other jobs"
        } else {
            return "fees & withdrawals"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // create array to isolate
        let subJobsArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.codeCEXSN == "S" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
        if section == 3 && subJobsArray.isEmpty {
            return 0
        } else {
            return 28
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! UserCell
        
        // ----------
        // daily jobs
        // ----------
        
        if indexPath.section == 0 {
            // get an array of this user in this category for this item on this day.
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.itemName == usersDailyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            cell.jobHabitLabel.text = usersDailyJobs?[indexPath.row].name
            cell.pointsLabel.text = "\(dailyJobsPointValue ?? 0)"
            cell.pointsLabel.textColor = .lightGray
            cell.accessoryType = .none
            if currentUserCategoryItemDateArray.isEmpty {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobHabitLabel.textColor = .black
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].codeCEXSN == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].codeCEXSN == "X" {
                    cell.selectionBoxImageView.image = UIImage(named: "X red")
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "E gray")
                }
            }
            
        // ------------
        // daily habits
        // ------------
            
        } else if indexPath.section == 1 {
            // get an array of this user in this category for this item on this day.
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && $0.itemName == usersDailyHabits?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            cell.jobHabitLabel.text = usersDailyHabits?[indexPath.row].name
            if indexPath.row == 0 {
                cell.pointsLabel.text = "\(priorityHabitPointValue ?? 0)"
            } else {
                cell.pointsLabel.text = "\(regularHabitPointValue ?? 0)"
            }
            cell.pointsLabel.textColor = .lightGray
            cell.accessoryType = .none
            if currentUserCategoryItemDateArray.isEmpty {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobHabitLabel.textColor = .black
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].codeCEXSN == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].codeCEXSN == "X" {
                    cell.selectionBoxImageView.image = UIImage(named: "X red")
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "E gray")
                }
            }
            
        // -----------
        // weekly jobs
        // -----------
            
        } else if indexPath.section == 2 {
            // get an array of this user in this category for this item on this day.
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "weekly jobs" && $0.itemName == usersWeeklyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            cell.jobHabitLabel.text = usersWeeklyJobs?[indexPath.row].name
            cell.pointsLabel.text = "\(weeklyJobsPointValue ?? 0)"
            cell.pointsLabel.textColor = .lightGray
            cell.accessoryType = .none
            if currentUserCategoryItemDateArray.isEmpty {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobHabitLabel.textColor = .black
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].codeCEXSN == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].codeCEXSN == "X" {
                    cell.selectionBoxImageView.image = UIImage(named: "X red")
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "E gray")
                }
            }
            
        // -----
        // other
        // -----
            
        } else if indexPath.section == 3 {
            let subJobsArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.codeCEXSN == "S" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            cell.jobHabitLabel.text = subJobsArray[indexPath.row].itemName
            cell.jobHabitLabel.textColor = .lightGray
            cell.pointsLabel.text = "\(subJobsArray[indexPath.row].valuePerTap)"
            cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
            
        // ------------------
        // fees & withdrawals
        // ------------------
            
        } else if indexPath.section == 4 {
            // get an array of this user in this category for this item on this day.
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "fees & withdrawals" && $0.itemName == usersWeeklyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            cell.jobHabitLabel.text = feesDebts[indexPath.row]
            cell.jobHabitLabel.textColor = .black
            cell.pointsLabel.text = ""
            cell.accessoryType = .disclosureIndicator
            if currentUserCategoryItemDateArray.isEmpty {
                cell.selectionBoxImageView.image = nil
                //                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobHabitLabel.textColor = .black
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].codeCEXSN == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].codeCEXSN == "X" {
                    cell.selectionBoxImageView.image = UIImage(named: "X red")
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "E gray")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ----------
        // daily jobs
        // ----------
        
        if indexPath.section == 0 {
            // get an array of this user in this category for this item on this day. If it doesn't exist, then create it w/ tap value = C.
            // if the array isn't empty, check the codeCEXSN. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.itemName == usersDailyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            if currentUserCategoryItemDateArray.isEmpty {
                createNewPointsItemForDailyJobs(indexPath: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                // if array isn't empty, check if numberOfTapsEX has an 'X' or an 'E'
            } else if currentUserCategoryItemDateArray[0].codeCEXSN == "X" {
                alertX(indexPath: indexPath, deselectRow: true)
            } else if currentUserCategoryItemDateArray[0].codeCEXSN == "E" {
                alertE(indexPath: indexPath, deselectRow: true)
                
                // if array isn't empty and numberOfTapsEX isn't 'X' or 'E' (if array is just 'C')
            } else {
                // do nothing
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // ------------
        // daily habits
        // ------------
        
        if indexPath.section == 1 {
            // get an array of this user in this category for this item on this day. If it doesn't exist, then create it w/ tap value = C.
            // if the array isn't empty, check the codeCEXSN. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && $0.itemName == usersDailyHabits?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            if currentUserCategoryItemDateArray.isEmpty {
                createNewPointsItemForHabits(indexPath: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // -----------
        // weekly jobs
        // -----------
    
        if indexPath.section == 2 {
            // get an array of this user in this category for this item on this day. If it doesn't exist, then create it w/ tap value = C.
            // if the array isn't empty, check the codeCEXSN. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "weekly jobs" && $0.itemName == usersWeeklyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            if currentUserCategoryItemDateArray.isEmpty {
                createNewPointsItemForWeeklyJobs(indexPath: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }  else {
                // do nothing (because this info is now in the 'swipe from right' section of code
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // -----
        // other
        // -----
        
        if indexPath.section == 3 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        // ------------------
        // fees & withdrawals
        // ------------------
        
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "FeesDetailSegue", sender: self)
            } else {
                performSegue(withIdentifier: "DebtsDetailSegue", sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // disable editing for 'fees and withdrawals' and 'other jobs'
        if indexPath.section == 3 || indexPath.section == 4 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // ----------
        // daily jobs
        // ----------
        
        if indexPath.section == 0 {
            subFeeFormatted = String(format: "%.2f", Double(substituteFee) / 100)
            
            excusedTitle = "Excused From Job"
            excusedMessage = "\(self.currentUserName!) was excused from doing the job '\(self.usersDailyJobs[indexPath.row].name)'. \(MPUser.gender(user: MPUser.currentUser).he_she) won't lose \(MPUser.gender(user: MPUser.currentUser).his_her.lowercased()) job bonus, but \(MPUser.gender(user: MPUser.currentUser).he_she.lowercased()) WILL be charged a $\(subFeeFormatted!) substitute fee."
            
            unexcusedTitle = "Unexcused From Job"
            unexcusedMessage = "\(self.currentUserName!) was NOT excused from doing the job '\(self.usersDailyJobs[indexPath.row].name)'.\n\n\(MPUser.gender(user: MPUser.currentUser).he_she) will LOSE \(MPUser.gender(user: MPUser.currentUser).his_her.lowercased()) job bonus, PLUS \(MPUser.gender(user: MPUser.currentUser).he_she.lowercased()) will be charged a $\(subFeeFormatted!) substitute fee."

            // get an array of this user in this category for this item on this day (should be single item)
            // this code recalculates each time a row is selected
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "daily jobs" && $0.itemName == self.usersDailyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            // --------------
            // excused action
            // --------------
            
            let excusedAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                // ...check to see if iso array is empty. If so, don't let user reset anything b/c it will crash the app (b/c the array is empty)
                if !isoArrayForItem.isEmpty {
                    if isoArrayForItem[0].codeCEXSN == "E" {
                        self.alertE(indexPath: indexPath, deselectRow: false)
                    } else if isoArrayForItem[0].codeCEXSN == "X" {
                        self.alertX(indexPath: indexPath, deselectRow: false)
                    } else {
                        self.runExcusedUnexcusedDialogue(alertTitle: self.excusedTitle, alertMessage: self.excusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "E")
                    }
                } else {
                    self.runExcusedUnexcusedDialogue(alertTitle: self.excusedTitle, alertMessage: self.excusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "E")
                }
            })
            
            // ----------------
            // unexcused action
            // ----------------
            
            let unexcusedAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                
                if !isoArrayForItem.isEmpty {
                    if isoArrayForItem[0].codeCEXSN == "E" {
                        self.alertE(indexPath: indexPath, deselectRow: false)
                    } else if isoArrayForItem[0].codeCEXSN == "X" {
                        self.alertX(indexPath: indexPath, deselectRow: false)
                    } else {
                        self.runExcusedUnexcusedDialogue(alertTitle: self.unexcusedTitle, alertMessage: self.unexcusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "X")
                    }
                } else {
                    self.runExcusedUnexcusedDialogue(alertTitle: self.unexcusedTitle, alertMessage: self.unexcusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "X")
                }
            })
            
            // ------------
            // reset action
            // ------------
            
            let resetAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                // ...check to see if iso array is empty. If so, don't let user reset anything b/c it will crash the app (b/c the array is empty)
                if isoArrayForItem.isEmpty {
                    // do nothing
                    tableView.setEditing(false, animated: true)
                } else {
                    // need to check if item is 'X' or 'E', and if so, need parental password to reset to zero. Otherwise, user can reset 'C' to zero
                    if isoArrayForItem[0].codeCEXSN == "C" {
                        self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "daily jobs", categoryArray: self.usersDailyJobs)
                    } else {
                        self.getParentalPasscodeThenResetToZero(indexPath: indexPath)
                    }
                }
            })
            
            excusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "excused")!)       // button image must be same height as tableview row height
            unexcusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "unexcused")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            
            return [resetAction, unexcusedAction, excusedAction]
            
        } else if indexPath.section == 1 {
            
            // ------------
            // daily habits
            // ------------
            
            // get an array of this user in this category for this item on this day (should be single item)
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "daily habits" && $0.itemName == self.usersDailyHabits?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            // ----------------
            // unexcused action
            // ----------------
            
            let notDoneAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                
                if isoArrayForItem.isEmpty {
                    print("array is empty")
                } else {
                    print("array is not empty")
                }
            })
            
            let resetAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                // check to see if it's empty. If so, don't let user reset anything (b/c it will crash the app)
                // get an array of this user in this category for this item on this day (should be single item)
                let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "daily habits" && $0.itemName == self.usersDailyHabits?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
                if isoArrayForItem.isEmpty {
                    // do nothing
                    tableView.setEditing(false, animated: true)
                } else {
                    self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "daily habits", categoryArray: self.usersDailyHabits)
                }
            })
            
            notDoneAction.backgroundColor = UIColor(patternImage: UIImage(named: "not done")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            return [resetAction, notDoneAction]
            
        } else {
            
            // -----------
            // weekly jobs
            // -----------
            
            let resetAction = UITableViewRowAction()
            return [resetAction]
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func checkIncome() {
        if Income.currentIncomeArray.filter({ $0.user == currentUserName }).isEmpty {
            // create a default array
            let newUserPoints = Income(user: currentUserName, currentPoints: 0)
            Income.currentIncomeArray.append(newUserPoints)
            incomeLabel.text = "$0.00"
        } else {
            for (index, item) in Income.currentIncomeArray.enumerated() {
                if item.user == currentUserName {
                    incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                }
            }
        }
    }
    
    func getParentalPasscodeThenResetToZero(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to override an excused or unexcused job.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
        })
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, not kids
            let parentalArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                
                // create array to isolate selected item
                let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "daily jobs" && $0.itemName == self.usersDailyJobs[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
                
                
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == isoArrayForItem[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: pointsItem.itemDate)) {
                        
                        // remove item from points array
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // update user's income array
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            }
                        }
                        
                        // update user's income label
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                            }
                        }
                        
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                
                // find the daily job with that name on that day for current user and remove it
                self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "daily jobs", categoryArray: self.usersDailyJobs)
                
                // remove job substitute daily job
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == "\((self.usersDailyJobs?[indexPath.row].name)!) (sub)" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: pointsItem.itemDate)) {
                        
                        // find name of substitute before deleting item
                        let substituteName = Points.pointsArray[pointsIndex].user
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // update substitute's income array
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == substituteName {
                                Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            }
                        }
                    }
                }
                
                // update current user's income again (for rare instances when current user assigned themself as substitute)
                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                    if incomeItem.user == self.currentUserName {
                        self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                    }
                }
                
                self.tableView.setEditing(false, animated: true)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.incorrectPasscodeAlert()
            }
        }))
        // Button TWO: "cancel", and send user back to home page
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
            self.tableView.setEditing(false, animated: true)

            //                            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func runExcusedUnexcusedDialogue(alertTitle: String, alertMessage: String, isoArray: [Points], indexPath: IndexPath, assignEorX: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)

        // --------------------
        // Button ONE: "accept"
        // --------------------
        
        alert.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // -----------------
            // Choose substitute
            // -----------------
            
            let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.currentUserName!)'s job '\(self.usersDailyJobs[indexPath.row].name)'?", preferredStyle: UIAlertControllerStyle.alert)
            for user in MPUser.usersArray {
                alert2.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    
                    // ---------------------------
                    // Confirm / Cancel substitute
                    // ---------------------------
                    
                    self.confirmOrCancelSubstitute(isoArray: isoArray, nameOfSub: user.firstName, eORx: assignEorX, indexPath: indexPath)
                }))
            }
            
            // -------------
            // NO substitute
            // -------------
            
            alert2.addAction(UIAlertAction(title: "None", style: .cancel, handler: { (action) in
                let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.currentUserName!)'s job '\(self.usersDailyJobs[indexPath.row].name)'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
                alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    // do nothing
                    self.tableView.setEditing(false, animated: true)
                    alert3.dismiss(animated: true, completion: nil)}))
                alert3.addAction(UIAlertAction(title: "accept", style: .default, handler: { (action) in
                    
                    // --------------------------------------------------------------------------------------------------------------------
                    // 1. if user had added points to their point chart for that job, delete them and their values and update income totals
                    // --------------------------------------------------------------------------------------------------------------------
                    
                    if !isoArray.isEmpty {
                        let selectedItemDate = Date(timeIntervalSince1970: isoArray[0].itemDate) //
                        for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                            if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == isoArray[0].itemName && Calendar.current.isDateInToday(selectedItemDate) {
                                
                                // remove item from points array
                                Points.pointsArray.remove(at: pointsIndex)
                                
                                // subtract item from user's income array
                                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                                    if incomeItem.user == self.currentUserName {
                                        Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                                    }
                                }
                                self.tableView.setEditing(false, animated: true)
                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                    
                    // ----------------------------------------------------------------------------
                    // 2. charge user substitution fee in Points array and then update Income array
                    // ----------------------------------------------------------------------------
                    
                    // subtract fee from Points Array
                    let loseSubstitutionPoints = Points(user: self.currentUserName, itemName: "\(self.usersDailyJobs[indexPath.row].name)", itemCategory: "daily jobs", codeCEXSN: assignEorX, valuePerTap: -(self.substituteFee), itemDate: Date().timeIntervalSince1970)
                    Points.pointsArray.append(loseSubstitutionPoints)
                    
                    // subtract fee from Income array and update income label
                    for (index, item) in Income.currentIncomeArray.enumerated() {
                        if item.user == self.currentUserName {
                            Income.currentIncomeArray[index].currentPoints -= self.substituteFee
                            self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                        }
                    }
                    
                    self.tableView.setEditing(false, animated: true)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    alert3.dismiss(animated: true, completion: nil)}))
                self.present(alert3, animated: true, completion: nil)}))
            self.present(alert2, animated: true, completion: nil)}))
        
        // --------------------
        // Button TWO: "cancel"
        // --------------------
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel , handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.setEditing(false, animated: true)
            print("excused canceled")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertE(indexPath: IndexPath, deselectRow: Bool) {
        let alertE = UIAlertController(title: "Excused", message: "This job is currently excused. In order to change it, tap the 'reset' button.", preferredStyle: .alert)
        alertE.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alertE.dismiss(animated: true, completion: nil)
            
            // to determine whether to perform tableview animation upon alert dismissal
            if deselectRow {
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else {
                //                self.tableView.setEditing(false, animated: true)
            }
        }))
        self.present(alertE, animated: true, completion: nil)
    }
    
    func alertX(indexPath: IndexPath, deselectRow: Bool) {
        let alertX = UIAlertController(title: "Unexcused", message: "This job is currently unexcused. In order to change it, tap the 'reset' button.", preferredStyle: .alert)
        alertX.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alertX.dismiss(animated: true, completion: nil)
            
            // to determine whether to perform tableview animation upon alert dismissal
            if deselectRow {
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else {
                //                self.tableView.setEditing(false, animated: true)
            }
        }))
        self.present(alertX, animated: true, completion: nil)
    }
    
    func confirmOrCancelSubstitute(isoArray: [Points], nameOfSub: String, eORx: String, indexPath: IndexPath) {
        let substituteName: String = nameOfSub
        let substituteSubtotal = substituteFee + dailyJobsPointValue

        let dailyJobsPointsFormatter = String(format: "%.2f", Double(dailyJobsPointValue) / 100)
        let susbtituteSubtotalFormatted = String(format: "%.2f", Double(substituteSubtotal) / 100)
        
        let alert3 = UIAlertController(title: "Confirm Job Substitute", message: "\(substituteName) was the job substitute for '\(self.usersDailyJobs[indexPath.row].name)'. \(substituteName) earned the $\(subFeeFormatted!) substitute fee plus $\(dailyJobsPointsFormatter) for completing the job.\n\nDo you wish to continue?", preferredStyle: .alert)
        
        // ------------------
        // Confirm substitute
        // ------------------
        
        alert3.addAction(UIAlertAction(title: "pay \(substituteName) $\(susbtituteSubtotalFormatted)", style: .default, handler: { (action) in
            alert3.dismiss(animated: true, completion: nil)
            
            // -----------------------------------------------------------------------------------------------------------------
            // 1. subtract existing job from Points array AND Income array (if user already erroneously marked it as "complete")
            // -----------------------------------------------------------------------------------------------------------------
            
            if !isoArray.isEmpty {
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == isoArray[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: isoArray[0].itemDate)) {
                        
                        // remove item from points array
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // subtract from user's income array
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            }
                        }
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            // -------------------------------------------------------------------
            // 2. charge current user the sub fee in Income array AND Points array
            // -------------------------------------------------------------------
            
            // subtract from income array
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == self.currentUserName {
                    Income.currentIncomeArray[incomeIndex].currentPoints -= self.substituteFee
                }
            }
            
            // create charge in points array
            let loseSubstitutionPoints = Points(user: self.currentUserName, itemName: "\(self.usersDailyJobs[indexPath.row].name)", itemCategory: "daily jobs", codeCEXSN: eORx, valuePerTap: -(self.substituteFee), itemDate: Date().timeIntervalSince1970)
            Points.pointsArray.append(loseSubstitutionPoints)
            
            // -----------------------------------------------------------------------------------------
            // 3. pay the susbtitute the substitution fee AND job value in Income array AND Points array
            // -----------------------------------------------------------------------------------------
            
            // add fee and job value to substitute's Points array
            let earnedSubstitutionFee = Points(user: substituteName, itemName: "\(self.usersDailyJobs[indexPath.row].name) (sub)", itemCategory: "daily jobs", codeCEXSN: "S", valuePerTap: (self.substituteFee + self.dailyJobsPointValue), itemDate: Date().timeIntervalSince1970)
            Points.pointsArray.append(earnedSubstitutionFee)
            
            // update current user's table view with new row in 'other jobs' only if they assigned the substitution to themself
            if substituteName == self.currentUserName {
                let subJobsArray = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.codeCEXSN == "S" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
                
                let jobSubIndexPath = IndexPath(row: subJobsArray.count - 1, section: 3)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [jobSubIndexPath], with: .automatic)
                self.tableView.endUpdates()
            }
            
            // add fee and job value to Income array at substitute's index
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == substituteName {
                    Income.currentIncomeArray[incomeIndex].currentPoints += (self.substituteFee + self.dailyJobsPointValue)
                }
            }
            
            // --------------------------------------------------------------------------------
            // 4. update the current user's income label last (after all calculations are done)
            // --------------------------------------------------------------------------------
            
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == self.currentUserName {
                    self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                }
            }
            
            self.tableView.setEditing(false, animated: true)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            print("\(substituteName) confirmed as substitute")
        }))
        
        // -----------------
        // Cancel substitute
        // -----------------
        
        alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert3.dismiss(animated: true, completion: nil)
            self.tableView.setEditing(false, animated: true)
            print("canceled")
        }))
        self.present(alert3, animated: true, completion: nil)
        print("\(substituteName) selected as substitute")
    }
    
    func updateUserIncome(itemValue: Int) {
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += itemValue
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
    }
    
    func createNewPointsItemForDailyJobs(indexPath: IndexPath) {
        let tapCode = "C"
        let valuePerTap = dailyJobsPointValue
        let itemName = usersDailyJobs?[indexPath.row].name
        let itemCategory = "daily jobs"
        let itemDate = Date().timeIntervalSince1970
        let user = currentUserName
        
        let pointsArrayItem = Points(user: user!, itemName: itemName!, itemCategory: itemCategory, codeCEXSN: tapCode, valuePerTap: valuePerTap!, itemDate: itemDate)
        Points.pointsArray.append(pointsArrayItem)
        
        // // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += valuePerTap!
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
    }
    
    func createNewPointsItemForHabits(indexPath: IndexPath) {
        var valuePerTap = 0
        
        let tapCode = "C"
        if indexPath.row == 0 {
            valuePerTap = priorityHabitPointValue!
        } else {
            valuePerTap = regularHabitPointValue!
        }
        let itemName = usersDailyHabits?[indexPath.row].name
        let itemCategory = "daily habits"
        let itemDate = Date().timeIntervalSince1970
        let user = currentUserName
        
        let pointThingy = Points(user: user!, itemName: itemName!, itemCategory: itemCategory, codeCEXSN: tapCode, valuePerTap: valuePerTap, itemDate: itemDate)
        Points.pointsArray.append(pointThingy)
        
        // // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += valuePerTap
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
    }
    
    func createNewPointsItemForWeeklyJobs(indexPath: IndexPath) {
        let tapCode = "C"
        let valuePerTap = weeklyJobsPointValue
        let itemName = usersWeeklyJobs?[indexPath.row].name
        let itemCategory = "weekly jobs"
        let itemDate = Date().timeIntervalSince1970
        let user = currentUserName
        
        let newItemTapped = Points(user: user!, itemName: itemName!, itemCategory: itemCategory, codeCEXSN: tapCode, valuePerTap: valuePerTap!, itemDate: itemDate)
        Points.pointsArray.append(newItemTapped)
        
        // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += weeklyJobsPointValue
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
    }
    
    func removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: IndexPath, category: String, categoryArray: [JobsAndHabits]) {
        // create array to isolate selected item (there should only be one item with current user, current category, current name, and current date of today)
        // NOTE: 'Calendar.current' automatically determines local time zone (no need to setup time zone properties if calling 'Calendar.current')
        let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == category && $0.itemName == categoryArray[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
        
        if isoArrayForItem.isEmpty {
            // do nothing (this is the rare instance where user is resetting an excused or unexcused job that was assigned to themself)
            // update user's income label
            tableView.setEditing(false, animated: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                if pointsItem.user == self.currentUserName && pointsItem.itemCategory == category && pointsItem.itemName == isoArrayForItem[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: (isoArrayForItem.first?.itemDate)!)) {
                    
                    // remove item from points array
                    Points.pointsArray.remove(at: pointsIndex)
                    
                    // update user's income array & income label
                    for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                        if incomeItem.user == self.currentUserName {
                            Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                        }
                    }
                    tableView.setEditing(false, animated: true)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func incorrectPasscodeAlert() {
        let wrongPasscodeAlert = UIAlertController(title: "Incorrect Passcode", message: "Please try again.", preferredStyle: .alert)
        wrongPasscodeAlert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            wrongPasscodeAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(wrongPasscodeAlert, animated: true, completion: nil)
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // -----------------
    // Green Grid Button
    // -----------------
    
    @IBAction func greenGridButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // ---------------
    // Date calculator
    // ---------------
    
    func dayDifference(from interval : TimeInterval) -> String {
        
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
}






