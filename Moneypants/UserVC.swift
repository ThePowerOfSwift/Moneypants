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
        
//        tabBarController?.tabBar.items?[2].badgeValue = "1"
        
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
                    cell.selectionBoxImageView.image = UIImage(named: "X gray")
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
                } else if currentUserCategoryItemDateArray[0].codeCEXSN == "N" {
                    cell.selectionBoxImageView.image = UIImage(named: "X gray")
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
                    cell.selectionBoxImageView.image = UIImage(named: "X gray")
                }
            }
            
        // ----------
        // other jobs
        // ----------
            
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
                createNewItemForDailyHabit(indexPath: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else if currentUserCategoryItemDateArray.first?.codeCEXSN == "N" {
                alertN(indexPath: indexPath, deselectRow: true, jobOrHabit: "habit")
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
            } else if currentUserCategoryItemDateArray.first?.codeCEXSN == "C" {
                tableView.deselectRow(at: indexPath, animated: true)
            } else if currentUserCategoryItemDateArray.first?.codeCEXSN == "N" {
                alertN(indexPath: indexPath, deselectRow: true, jobOrHabit: "job")
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
                if isoArrayForItem.isEmpty {
                    self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.excusedTitle, alertMessage: self.excusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "E")
                } else {
                    if isoArrayForItem.first?.codeCEXSN == "C" {
                        self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.excusedTitle, alertMessage: self.excusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "E")
                    } else if isoArrayForItem.first?.codeCEXSN == "E" {
                        self.alertE(indexPath: indexPath, deselectRow: false)
                    } else if isoArrayForItem.first?.codeCEXSN == "X" {
                        self.alertX(indexPath: indexPath, deselectRow: false)
                    }
                }
            })
            
            // ----------------
            // unexcused action
            // ----------------
            
            let unexcusedAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                if isoArrayForItem.isEmpty {
                    self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.unexcusedTitle, alertMessage: self.unexcusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "X")
                } else {
                    if isoArrayForItem.first?.codeCEXSN == "C" {
                        self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.unexcusedTitle, alertMessage: self.unexcusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "X")
                    } else if isoArrayForItem.first?.codeCEXSN == "E" {
                        self.alertE(indexPath: indexPath, deselectRow: false)
                    } else if isoArrayForItem.first?.codeCEXSN == "X" {
                        self.alertX(indexPath: indexPath, deselectRow: false)
                    }
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
                    } else if isoArrayForItem.first?.codeCEXSN == "E" || isoArrayForItem.first?.codeCEXSN == "X" {
                        self.getParentalPasscodeThenResetToZero(indexPath: indexPath)
                    }
                }
            })
            
            excusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "excused")!)
            unexcusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "unexcused")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            
            return [resetAction, unexcusedAction, excusedAction]
            
        } else if indexPath.section == 1 {
            
            // ------------
            // daily habits
            // ------------
            
            // get an array of this user in this category for this item on this day (should be single item)
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "daily habits" && $0.itemName == self.usersDailyHabits?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            // -----------------
            // 'not done' action
            // -----------------
            
            let notDoneAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                if isoArrayForItem.isEmpty {
                    // if array is empty, create new array item with "N" and value of "0"
                    self.createZeroValueItemForDailyHabit(indexPath: indexPath)
                } else {
                    if isoArrayForItem.first?.codeCEXSN == "C" {
                        self.deleteItemFromArrayAndUpdateIncomeArrayAndLabel(isoArray: isoArrayForItem, indexPath: indexPath)
                    } else if isoArrayForItem.first?.codeCEXSN == "N" {
                        self.alertN(indexPath: indexPath, deselectRow: false, jobOrHabit: "habit")
                    }
                }
            })
            
            // ------------
            // reset action
            // ------------
            
            let resetAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                // check to see if iso array is empty. If so, don't let user reset anything (b/c it will crash the app)
                if isoArrayForItem.isEmpty {
                    // do nothing
                    tableView.setEditing(false, animated: true)
                } else {
                    if isoArrayForItem.first?.codeCEXSN == "N" {
                        self.getParentalPasscodeThenResetItemToZero(isoArray: isoArrayForItem, indexPath: indexPath)
                    } else {
                        self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "daily habits", categoryArray: self.usersDailyHabits)
                    }
                }
            })
            
            notDoneAction.backgroundColor = UIColor(patternImage: UIImage(named: "not done")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            return [resetAction, notDoneAction]
            
        } else {

            // -----------
            // weekly jobs
            // -----------
            
            // get an array of this user in this category for this item on this day (should be single item)
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "weekly jobs" && $0.itemName == self.usersWeeklyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            
            // -------------------
            // 'substitute' action
            // -------------------
            
            let substituteAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                if isoArrayForItem.isEmpty {
                    // if array is empty, create new array item with "N" and value of "0"
                    self.weeklyJobsSubDialogue(indexPath: indexPath, isoArray: isoArrayForItem)
                } else {
                    if isoArrayForItem.first?.codeCEXSN == "C" {
                        self.weeklyJobsSubDialogue(indexPath: indexPath, isoArray: isoArrayForItem)
                    } else if isoArrayForItem.first?.codeCEXSN == "N" {
                        self.alertN(indexPath: indexPath, deselectRow: false, jobOrHabit: "job")
                    }
                }
            })
            
            // ------------
            // reset action
            // ------------
            
            let resetAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                if isoArrayForItem.isEmpty {
                    tableView.setEditing(false, animated: true)
                }
            })
            
            substituteAction.backgroundColor = UIColor(patternImage: UIImage(named: "substitute")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            return [resetAction, substituteAction]
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func getParentalPasscodeThenResetItemToZero(isoArray: [Points], indexPath: IndexPath) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to override a habit that has been marked 'not done'.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, no kids
            let parentalArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                
                // if array is not empty, delete the item from the array
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily habits" && pointsItem.itemName == isoArray.first?.itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: (isoArray.first?.itemDate)!)) {
                        
                        // remove item from points array (no need to do anything else: value was already zero)
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // update tableview
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            } else {
                self.incorrectPasscodeAlert()
            }
        }))
        // Button TWO: "cancel", reset table to normal
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
            self.tableView.setEditing(false, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getParentalPasscodeThenResetToZero(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to override an excused or unexcused job.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, not kids
            let parentalArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                
                // once parental password is confirmed, simply do 2 things: remove current user's 'E' or 'X' fee, and remove sub's 'S' fee
                // then update Points array, update Income array, then update current user's label (and remove row from table if user was their own sub)
                
                // create array to isolate selected item (for current user, this category, this job name, on this date)
                // NOTE: 'Calendar.current' automatically determines local time zone (no need to setup time zone properties if calling 'Calendar.current')
                let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.itemCategory == "daily jobs" && $0.itemName == self.usersDailyJobs[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })

                // -------------------------------
                // 1. remove item for current user
                // -------------------------------
                
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == isoArrayForItem[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: pointsItem.itemDate)) {
                        
                        // ------------------------------------------------
                        // 1A. remove current user's item from points array
                        // ------------------------------------------------
                        
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        
                        // --------------------------------------
                        // 1B. update current user's income array
                        // --------------------------------------
                        
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            }
                        }
                        
                        // --------------------------------------
                        // 1C. update current user's income label
                        // --------------------------------------
                        
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                            }
                        }
                        
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                
                // -----------------------------
                // 2. remove item for substitute
                // -----------------------------
                
                var substituteName: String!
                var substituteValue: Int!
                // iterate over array to find item with code 'S' in current category with 'sub' in job name on this date (b/c there can only be one daily job with that name that has a sub)
                for (pointsIndex2, pointsItem2) in Points.pointsArray.enumerated() {
                    if pointsItem2.codeCEXSN == "S" && pointsItem2.itemCategory == "daily jobs" && pointsItem2.itemName == "\(self.usersDailyJobs[indexPath.row].name) (sub)" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: pointsItem2.itemDate)) {
                        
                        // get sub's name before deleting array item (for later use)
                        // also get the amount the sub was paid (to subtract from the income array)
                        substituteName = Points.pointsArray[pointsIndex2].user
                        substituteValue = Points.pointsArray[pointsIndex2].valuePerTap
                        
                        // ----------------------------------------------
                        // 2A. remove substitute's item from points array
                        // ----------------------------------------------
                        
                        Points.pointsArray.remove(at: pointsIndex2)
                        
                        // ------------------------------------------------------------------------------------------------
                        // 2B. reload the "other jobs" section of tableView (for rare cases where current user is also sub)
                        // ------------------------------------------------------------------------------------------------
                        
                        self.tableView.reloadSections([3], with: .automatic)
                    }
                }
                
                // ------------------------------------
                // 2C. update substitute's income array
                // ------------------------------------
                
                for (incomeIndex2, incomeItem2) in Income.currentIncomeArray.enumerated() {
                    if incomeItem2.user == substituteName {
                        Income.currentIncomeArray[incomeIndex2].currentPoints -= substituteValue
                    }
                }
                
                // -------------------------------------------------------------------------------
                // 3. update income label again in rare instance the sub was also the current user
                // -------------------------------------------------------------------------------
                
                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                    if incomeItem.user == self.currentUserName {
                        self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                    }
                }
            } else {
                self.incorrectPasscodeAlert()
            }
        }))
        // Button TWO: "cancel", and send user back to home page
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
            self.tableView.setEditing(false, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func deleteItemFromArrayAndUpdateIncomeArrayAndLabel(isoArray: [Points], indexPath: IndexPath) {
        // if array is not empty, subtract "value per tap" from income array (at user's index) and delete the item from the array, then update user's income label
        for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
            if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily habits" && pointsItem.itemName == isoArray.first?.itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: (isoArray.first?.itemDate)!)) {
                
                // update item in points array
                Points.pointsArray[pointsIndex].codeCEXSN = "N"
                
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
}






