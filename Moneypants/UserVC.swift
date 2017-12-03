import UIKit
import AVFoundation
import Firebase

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLower: UILabel!
    
    // flyover
    @IBOutlet weak var habitBonusView: UIView!
    @IBOutlet weak var trophyView: UIImageView!
    @IBOutlet weak var habitBonusCenterConstraint: NSLayoutConstraint!
    
    // progress meters
    @IBOutlet weak var habitProgressMeterHeight: NSLayoutConstraint!
    @IBOutlet weak var habitProgressMeterView: UIImageView!
    @IBOutlet weak var totalProgressMeterHeight: NSLayoutConstraint!
    @IBOutlet weak var habitTotalProgressView: UIView!
    @IBOutlet weak var habitBonusAmountLabel: UILabel!
    
    let feesDebts: [String] = ["add a fee...", "make a withdrawal..."]
    
    var currentUserName: String!
    
    var usersDailyJobs: [JobsAndHabits]!
    var usersDailyHabits: [JobsAndHabits]!
    var usersWeeklyJobs: [JobsAndHabits]!
    var dailyJobsPointValue: Int!
    var priorityHabitPointValue: Int!
    var regularHabitPointValue: Int!
    var weeklyJobsPointValue: Int!
    var jobAndHabitBonusValue: Int!
    var substituteFee: Int!
    
    var subFeeFormatted: String!
    var excusedTitle: String!
    var excusedMessage: String!
    var unexcusedTitle: String!
    var unexcusedMessage: String!
    
    var habitBonusSound = AVAudioPlayer()
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    var selectedDate: Date!
    var selectedDateNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        selectedDate = Date()
        selectedDateNumber = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        habitBonusCenterConstraint.constant = -300

        userImage.image = MPUser.usersArray[MPUser.currentUser].photo
        
        usersDailyJobs = JobsAndHabits.finalDailyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == currentUserName })
        usersDailyHabits = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == currentUserName })
        usersWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == currentUserName })
        dailyJobsPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) * 0.20 / 52 / Double(JobsAndHabits.finalDailyJobsArray.count) * 100 / 7).rounded(.up))
        priorityHabitPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.065 / 7 * 100).rounded(.up))
        regularHabitPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.015 / 7 * 100).rounded(.up))
        weeklyJobsPointValue = Int((Double(FamilyData.adjustedNatlAvgYrlySpendingEntireFam) * 0.20 / 52 / Double(JobsAndHabits.finalWeeklyJobsArray.count) * 100).rounded(.up))
        jobAndHabitBonusValue = Int(Double(FamilyData.adjustedNatlAvgYrlySpendingPerKid) / 52 * 0.20 * 100)
        substituteFee = FamilyData.feeValueMultiplier / usersDailyJobs.count
    
        customizeImages()
        updateFormattedDate()
        checkIncome()
        prepHabitBonusSFX()
        updateProgressMeters(animated: false)
        Points.updateJobBonus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        checkIncome()
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
        let subJobsArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "S" && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
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
        let subJobsArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "S" && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
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
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "daily jobs" &&
                $0.itemName == usersDailyJobs?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
                
            cell.jobHabitLabel.text = usersDailyJobs?[indexPath.row].name
            cell.pointsLabel.text = "\(dailyJobsPointValue ?? 0)"
            cell.pointsLabel.textColor = .lightGray
            cell.accessoryType = .none
            cell.selectionBoxLabel.text = ""

            if currentUserCategoryItemDateArray.isEmpty {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobHabitLabel.textColor = .black
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].code == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark")
                    cell.selectionBoxImageView.tintColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)
                } else if currentUserCategoryItemDateArray[0].code == "X" {
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
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.itemName == usersDailyHabits?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
                
            cell.jobHabitLabel.text = usersDailyHabits?[indexPath.row].name
            cell.selectionBoxLabel.text = ""
            cell.pointsLabel.textColor = .lightGray
            cell.accessoryType = .none
            
            if indexPath.row == 0 {
                cell.pointsLabel.text = "\(priorityHabitPointValue ?? 0)"
            } else {
                cell.pointsLabel.text = "\(regularHabitPointValue ?? 0)"
            }
            
            if currentUserCategoryItemDateArray.isEmpty {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobHabitLabel.textColor = .black
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].code == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark")
                    cell.selectionBoxImageView.tintColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)
                } else if currentUserCategoryItemDateArray[0].code == "N" {
                    cell.selectionBoxImageView.image = UIImage(named: "X gray")
                }
            }
            
        // -----------
        // weekly jobs
        // -----------
            
        } else if indexPath.section == 2 {
            // get an array of this user in this category for this item on this day.
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "weekly jobs" &&
                $0.itemName == usersWeeklyJobs?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            cell.jobHabitLabel.text = usersWeeklyJobs?[indexPath.row].name
            cell.pointsLabel.text = "\(weeklyJobsPointValue ?? 0)"
            cell.pointsLabel.textColor = .lightGray
            cell.selectionBoxLabel.text = ""
            cell.accessoryType = .none
            
            if currentUserCategoryItemDateArray.isEmpty {
                // check to see if the week has the job completed
                let previousWeeklyJobsIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.itemCategory == "weekly jobs" &&
                    $0.itemName == usersWeeklyJobs[indexPath.row].name &&
                    $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
                    $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
                
                let currentWeeklyJobsIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.itemCategory == "weekly jobs" &&
                    $0.itemName == usersWeeklyJobs[indexPath.row].name &&
                    $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
                
                // if current pay period already has the job done, mark all other days of the week with gray checkmark
                if selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && selectedDate.timeIntervalSince1970 < FamilyData.calculatePayday().current.timeIntervalSince1970 && !previousWeeklyJobsIsoArray.isEmpty {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark")
                    cell.selectionBoxImageView.tintColor = .lightGray
                } else if selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 && !currentWeeklyJobsIsoArray.isEmpty {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark")
                    cell.selectionBoxImageView.tintColor = .lightGray
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "blank")
                    cell.jobHabitLabel.textColor = .black
                }
            } else {
                cell.jobHabitLabel.textColor = .lightGray
                if currentUserCategoryItemDateArray[0].code == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark")
                    cell.selectionBoxImageView.tintColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
                } else if currentUserCategoryItemDateArray[0].code == "X" {
                    cell.selectionBoxImageView.image = UIImage(named: "X red")
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "X gray")
                }
            }
            
        // ----------
        // other jobs
        // ----------
            
        } else if indexPath.section == 3 {
            let subJobsArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.code == "S" &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            cell.jobHabitLabel.text = subJobsArray[indexPath.row].itemName
            cell.jobHabitLabel.textColor = .lightGray
            cell.pointsLabel.text = "\(subJobsArray[indexPath.row].valuePerTap)"
            cell.selectionBoxImageView.image = UIImage(named: "checkmark")
            cell.selectionBoxImageView.tintColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)
            cell.selectionBoxLabel.text = ""
            cell.accessoryType = .none
            
        // ------------------
        // fees & withdrawals
        // ------------------
            
        } else if indexPath.section == 4 {
            cell.selectionBoxImageView.image = nil
            cell.jobHabitLabel.text = feesDebts[indexPath.row]
            cell.jobHabitLabel.textColor = .black
            cell.pointsLabel.text = ""
            cell.accessoryType = .disclosureIndicator
            cell.selectionBoxLabel.textColor = .red
            cell.selectionBoxLabel.text = ""
            
            // fees
            if indexPath.row == 0 {
                // get an array of this user in this category for this item on this day (this may contain multiple values b/c user can add up to 3 fees per day)
                let isoArrayForItem = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "F" &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
                
                if isoArrayForItem.isEmpty {
                    cell.jobHabitLabel.textColor = .black
                    cell.selectionBoxLabel.text = ""
                } else {
                    // display # of fees user has
                    cell.selectionBoxLabel.text = "\(isoArrayForItem.count)"
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
            // if the array isn't empty, check the code. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let dailyJobIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "daily jobs" &&
                $0.itemName == usersDailyJobs?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            if dailyJobIsoArray.isEmpty {
                createNewPointsItem(itemName: usersDailyJobs[indexPath.row].name, itemCategory: "daily jobs", code: "C", valuePerTap: dailyJobsPointValue)
                updateProgressMeters(animated: true)
                tableView.reloadData()
//                tableView.reloadRows(at: [indexPath], with: .automatic)
                
                // ------------------
                // seventh day logic:
                // ------------------
                
                // if selected date is last day of pay period, AND rest of current payday has no X's or B's, AND the count of the number of assigned jobs is the same as the number of completed jobs, or E's, then create job bonus, and then show flyover
                
                // 1. create array for current user in daily jobs for current pay period
                let currentPayPeriodIsoArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
                
                // 2. make sure current day is last day of pay period
                let lastDayOfCurrentPayPeriod = Calendar.current.date(byAdding: .day, value: -1, to: FamilyData.calculatePayday().next)
                
                // 3. get list of user's assigned daily jobs
                let assignedDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName })
                
                // 4. if selected date is the last day of the current pay period
                if Calendar.current.isDate(selectedDate, inSameDayAs: lastDayOfCurrentPayPeriod!) &&
                    // 5. and the current pay period has no X's or B's
                    !currentPayPeriodIsoArray.contains(where: { $0.code == "X" || $0.code == "B" }) &&
                    // 6. and user has completed all their assigned jobs for the day (the last day of the pay period)
                    assignedDailyJobs.count == currentPayPeriodIsoArray.filter({ ($0.code == "C" || $0.code == "E") && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: lastDayOfCurrentPayPeriod!) }).count {
                    createNewPointsItem(itemName: "job bonus", itemCategory: "daily jobs", code: "B", valuePerTap: jobAndHabitBonusValue)
                    updateProgressMeters(animated: true)
                }
                
                // --------------------------------
                // eighth day logic (payday logic): is in viewDidLoad method
                // --------------------------------
                
                // no need for default job bonus
                // if on payday, user has no X's for the week AND user has no jobs bonus, then calculate bonus
                
            } else if dailyJobIsoArray[0].code == "X" {
                alertX(indexPath: indexPath, deselectRow: true)
            } else if dailyJobIsoArray[0].code == "E" {
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
            // if the array isn't empty, check the code. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let habitIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.itemName == usersDailyHabits?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            if habitIsoArray.isEmpty {
                var valuePerTap = 0
                if indexPath.row == 0 { valuePerTap = priorityHabitPointValue }
                else { valuePerTap = regularHabitPointValue }
                
                createNewPointsItem(itemName: usersDailyHabits[indexPath.row].name, itemCategory: "daily habits", code: "C", valuePerTap: valuePerTap)
                updateProgressMeters(animated: true)
                
//                createNewItemForDailyHabit(indexPath: indexPath)
                tableView.reloadData()
//                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else if habitIsoArray.first?.code == "N" {
                alertN(indexPath: indexPath, deselectRow: true, jobOrHabit: "habit")
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            showHabitBonusIfEarned()
        }
        
        // -----------
        // weekly jobs
        // -----------
    
        if indexPath.section == 2 {
            // get an array of this user in this category for this item on this day. If it doesn't exist, then create it w/ tap value = C.
            // if the array isn't empty, check the code. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let weeklyJobIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "weekly jobs" &&
                $0.itemName == usersWeeklyJobs?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            if weeklyJobIsoArray.isEmpty {
                // if weekly job is blank, still need to check if user has already done weekly job on another day
                // need to find out which week user is trying to select: 1. previous pay period, and 2. current pay period
                
                let prevPayPeriod = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.itemCategory == "weekly jobs" &&
                    $0.itemName == usersWeeklyJobs[indexPath.row].name &&
                    $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
                    $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
                
                let currentPayPeriod = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.itemCategory == "weekly jobs" &&
                    $0.itemName == usersWeeklyJobs[indexPath.row].name &&
                    $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
                
                // if selected date is in previous pay period and there are no weekly jobs done, then
                if selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && selectedDate.timeIntervalSince1970 < FamilyData.calculatePayday().current.timeIntervalSince1970 && prevPayPeriod.isEmpty {
                    createNewPointsItem(itemName: usersWeeklyJobs[indexPath.row].name, itemCategory: "weekly jobs", code: "C", valuePerTap: weeklyJobsPointValue)
                    updateProgressMeters(animated: true)
                    
//                    createNewPointsItemForWeeklyJobs(indexPath: indexPath)
                    tableView.reloadData()
                } else if selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 && currentPayPeriod.isEmpty {
                    createNewPointsItem(itemName: usersWeeklyJobs[indexPath.row].name, itemCategory: "weekly jobs", code: "C", valuePerTap: weeklyJobsPointValue)
                    updateProgressMeters(animated: true)
                    
//                    createNewPointsItemForWeeklyJobs(indexPath: indexPath)
                    tableView.reloadData()
                } else {
                    weeklyJobAlreadyCompletedAlert(indexPath: indexPath)
                    tableView.reloadData()
                }
//                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else if weeklyJobIsoArray.first?.code == "C" {
                tableView.deselectRow(at: indexPath, animated: true)
            } else if weeklyJobIsoArray.first?.code == "N" {
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
                // get an array of this user in this category for this item on this day (this may contain multiple values b/c user can add up to 3 fees per day)
                let isoArrayForItem = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "F" &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
                
                if isoArrayForItem.count == 3 {
                    tooManyStrikesAlert()
                    tableView.deselectRow(at: indexPath, animated: true)
                } else {
                    performSegue(withIdentifier: "FeesDetailSegue", sender: self)
                }
            } else {
                performSegue(withIdentifier: "DebtsDetailSegue", sender: self)
            }
        }
        
        updateProgressMeters(animated: true)
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
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName &&
                $0.itemCategory == "daily jobs" &&
                $0.itemName == self.usersDailyJobs?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            // --------------
            // excused action
            // --------------
            
            let excusedAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                // ...check to see if iso array is empty. If so, don't let user reset anything b/c it will crash the app (b/c the array is empty)
                if isoArrayForItem.isEmpty {
                    self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.excusedTitle, alertMessage: self.excusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "E")
                } else {
                    if isoArrayForItem.first?.code == "C" {
                        self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.excusedTitle, alertMessage: self.excusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "E")
                    } else if isoArrayForItem.first?.code == "E" {
                        self.alertE(indexPath: indexPath, deselectRow: false)
                    } else if isoArrayForItem.first?.code == "X" {
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
                    if isoArrayForItem.first?.code == "C" {
                        self.runExcusedUnexcusedDialogueForDailyJob(alertTitle: self.unexcusedTitle, alertMessage: self.unexcusedMessage, isoArray: isoArrayForItem, indexPath: indexPath, assignEorX: "X")
                    } else if isoArrayForItem.first?.code == "E" {
                        self.alertE(indexPath: indexPath, deselectRow: false)
                    } else if isoArrayForItem.first?.code == "X" {
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
                    if isoArrayForItem[0].code == "C" {
                        self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "daily jobs", categoryArray: self.usersDailyJobs)
                    } else if isoArrayForItem.first?.code == "E" || isoArrayForItem.first?.code == "X" {
                        self.getParentalPasscodeThenResetToZero(indexPath: indexPath, category: "daily jobs", categoryArray: self.usersDailyJobs)
                    }
                }
            })
            
            excusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "excused")!)
            unexcusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "unexcused")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            
            return [resetAction, unexcusedAction, excusedAction]
            
        }
        
        // ------------
        // daily habits
        // ------------
        
        if indexPath.section == 1 {
            // get an array of this user in this category for this item on this day (should be single item)
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.itemName == self.usersDailyHabits?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            // -----------------
            // 'not done' action
            // -----------------
            
            let notDoneAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                if isoArrayForItem.isEmpty {
                    // if array is empty, create new array item with "N" and value of "0"
                    self.createZeroValueItemForDailyHabit(indexPath: indexPath)
                } else {
                    if isoArrayForItem.first?.code == "C" {
                        // refresh selectedDate variable with selected time
                        self.selectedDate = Calendar.current.date(byAdding: .day, value: self.selectedDateNumber, to: Date())
                        self.updateItemInArrayAndUpdateIncomeArrayAndLabel(isoArray: isoArrayForItem, indexPath: indexPath)
                        self.checkIfUserStillEarnedBonusAndUpdateAccordingly()
                    } else if isoArrayForItem.first?.code == "N" {
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
                    if isoArrayForItem.first?.code == "N" {
                        self.getParentalPasscodeThenResetItemToZero(isoArray: isoArrayForItem, indexPath: indexPath)
                    } else {
                        self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "daily habits", categoryArray: self.usersDailyHabits)
                        self.checkIfUserStillEarnedBonusAndUpdateAccordingly()
                    }
                }
            })
        
            notDoneAction.backgroundColor = UIColor(patternImage: UIImage(named: "not done")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            
            return [resetAction, notDoneAction]
        }
        
        // -----------
        // weekly jobs
        // -----------
        
        if indexPath.section == 2 {
            // get an array of this user in this category for this item on this day (should be single item)
            let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName &&
                $0.itemCategory == "weekly jobs" &&
                $0.itemName == self.usersWeeklyJobs?[indexPath.row].name &&
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
            
            // -------------------
            // 'substitute' action
            // -------------------
            
            let substituteAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
                if isoArrayForItem.isEmpty {
                    // need to check if job has been completed for the week
                    // if so, let user know it's already been done
                    let prevPayPeriod = Points.pointsArray.filter({ $0.user == self.currentUserName &&
                        $0.itemCategory == "weekly jobs" &&
                        $0.itemName == self.usersWeeklyJobs[indexPath.row].name &&
                        $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
                        $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
                    
                    let currentPayPeriod = Points.pointsArray.filter({ $0.user == self.currentUserName &&
                        $0.itemCategory == "weekly jobs" &&
                        $0.itemName == self.usersWeeklyJobs[indexPath.row].name &&
                        $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
                    
                    // if selected date is in previous pay period and the selected weekly job is already done, then show message telling user job is already done
                    if self.selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && self.selectedDate.timeIntervalSince1970 < FamilyData.calculatePayday().current.timeIntervalSince1970 && !prevPayPeriod.isEmpty {
                        self.weeklyJobAlreadyCompletedAlert(indexPath: indexPath)
                        
                        // if selected date is in current pay period and the selected weekly job is already done, then show message telling user job is already done
                    } else if self.selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 && !currentPayPeriod.isEmpty {
                        print("job already done for current week")
                        self.weeklyJobAlreadyCompletedAlert(indexPath: indexPath)
                    } else {
                        // if array is empty, create new array item with "N" and value of "0"
                        self.weeklyJobsSubDialogue(indexPath: indexPath, isoArray: isoArrayForItem)
                    }
                } else {
                    if isoArrayForItem.first?.code == "C" {
                        self.weeklyJobsSubDialogue(indexPath: indexPath, isoArray: isoArrayForItem)
                    } else if isoArrayForItem.first?.code == "N" {
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
                } else if isoArrayForItem.first?.code == "C" {
                    self.removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: indexPath, category: "weekly jobs", categoryArray: self.usersWeeklyJobs)
                } else if isoArrayForItem.first?.code == "N" {
                    self.getParentalPasscodeThenResetToZero(indexPath: indexPath, category: "weekly jobs", categoryArray: self.usersWeeklyJobs)
                }
            })
            
            substituteAction.backgroundColor = UIColor(patternImage: UIImage(named: "substitute")!)
            resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
            
            return [resetAction, substituteAction]
        }
        let nothing = UITableViewRowAction()
        return [nothing]
    }
    
    // ----------
    // Navigation
    // ----------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeesDetailSegue" {
            print("heading over to fees now!!!")
            let nextVC = segue.destination as! FeeVC
            nextVC.selectedDate = selectedDate
            nextVC.selectedDateNumber = selectedDateNumber
        } else if segue.identifier == "DebtsDetailSegue" {
            print("headed over to record some expenses")
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dateArrowLeftTapped(_ sender: UIButton) {
        if dateLower.text == "yesterday" {
            getParentalPasscodeBeforeProceeding()
        } else if Calendar.current.isDate(selectedDate, inSameDayAs: FamilyData.calculatePayday().previous) == true {
            limitReachedAlert()
        } else {
            // subtract one day from selected date
            let today = Date()
            selectedDateNumber! -= 1
            selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateNumber, to: today)
            updateFormattedDate()
        }
        tableView.reloadData()
    }
    
    @IBAction func dateArrowRightTapped(_ sender: UIButton) {
        // check to see if day is already 'today'. If so, user can't go forward any more
        if Calendar.current.isDateInToday(selectedDate) {
            print("can't go into the future!")
        } else {
            // add one day to currently selected date
            let today = Date()
            selectedDateNumber! += 1
            selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateNumber, to: today)
            updateFormattedDate()
        }
        tableView.reloadData()
    }
    
    // ---------
    // Functions
    // ---------
    
    func getParentalPasscodeBeforeProceeding() {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "To change information for more than one day ago, a parental passcode is required.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        })
        // Button ONE: "okay"
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, not kids
            let parentalPasscodeArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalPasscodeArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                // subtract one day from selected date
                let today = Date()
                self.selectedDateNumber! -= 1
                self.selectedDate = Calendar.current.date(byAdding: .day, value: self.selectedDateNumber, to: today)
                self.updateFormattedDate()
                self.tableView.reloadData()
            } else {
                self.incorrectPasscodeAlert()
            }
        }))
        // Button TWO: "cancel"
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func limitReachedAlert() {
        let alert = UIAlertController(title: "Limit Reached", message: "You can only go back to the beginning of the previous pay period.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func removeSelectedItemFromPointsArrayAndUpdateIncomeArray(indexPath: IndexPath, category: String, categoryArray: [JobsAndHabits]) {
        // create array to isolate selected item (there should only be one item with current user, current category, current name, and current date of today)
        // NOTE: 'Calendar.current' automatically determines local time zone (no need to setup time zone properties if calling 'Calendar.current')
        let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName &&
            $0.itemCategory == category &&
            $0.itemName == categoryArray[indexPath.row].name &&
            Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: selectedDate) })
        
        if isoArrayForItem.isEmpty {
            // do nothing (this is the rare instance where user is resetting an excused or unexcused job that was assigned to themself)
            // update user's income label
            tableView.setEditing(false, animated: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                // isolate item in Points array (current user, current category, current item name, and current date)
                if pointsItem.user == self.currentUserName &&
                    pointsItem.itemCategory == category &&
                    pointsItem.itemName == isoArrayForItem[0].itemName &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: pointsItem.itemDate), inSameDayAs: selectedDate) {
                    
                    // remove item from points array
                    Points.pointsArray.remove(at: pointsIndex)
                    
                    // update user's income array & income label
                    for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                        if incomeItem.user == self.currentUserName {
                            Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                            updateProgressMeters(animated: true)
                        }
                    }
                    tableView.setEditing(false, animated: true)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }

    func getParentalPasscodeThenResetToZero(indexPath: IndexPath, category: String, categoryArray: [JobsAndHabits]) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to override an excused or unexcused job.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, not kids
            let parentalPasscodeArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalPasscodeArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                
                // once parental password is confirmed, simply do 2 things: remove current user's 'E' or 'X' fee, and remove sub's 'S' fee
                // then update Points array, update Income array, then update current user's label (and remove row from table if user was their own sub)
                
                // create array to isolate selected item (for current user, this category, this job name, on this date)
                // NOTE: 'Calendar.current' automatically determines local time zone (no need to setup time zone properties if calling 'Calendar.current')
                let isoArrayForItem = Points.pointsArray.filter({ $0.user == self.currentUserName &&
                    $0.itemCategory == category &&
                    $0.itemName == categoryArray[indexPath.row].name &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: self.selectedDate) })
                
                // -------------------------------
                // 1. remove item for current user
                // -------------------------------
                
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName &&
                        pointsItem.itemCategory == category &&
                        pointsItem.itemName == isoArrayForItem[0].itemName &&
                        Calendar.current.isDate(Date(timeIntervalSince1970: pointsItem.itemDate), inSameDayAs: self.selectedDate) {
                        
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
                                self.updateProgressMeters(animated: true)
                            }
                        }
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                
                // check array for value (if current chose 'none' as sub, there will be no "S" entry and the array will be empty)
                let subIsoArray = Points.pointsArray.filter({ $0.code == "S" &&
                    $0.itemCategory == "other jobs" &&      // previously was "category"
                    $0.itemName == "\(categoryArray[indexPath.row].name) (sub)" &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: self.selectedDate) })
                
                if !subIsoArray.isEmpty {
                    
                    // -----------------------------
                    // 2. remove item for substitute
                    // -----------------------------
                    
                    var substituteName: String!
                    var substituteValue: Int!
                    // iterate over array to find item with code 'S' in current category with 'sub' in job name on this date (b/c there can only be one daily job with that name that has a sub)
                    for (pointsIndex2, pointsItem2) in Points.pointsArray.enumerated() {
                        if pointsItem2.code == "S" &&
                            pointsItem2.itemCategory == "other jobs" &&      // previously was "category"
                            pointsItem2.itemName == "\(categoryArray[indexPath.row].name) (sub)" &&
                            Calendar.current.isDate(Date(timeIntervalSince1970: pointsItem2.itemDate), inSameDayAs: self.selectedDate) {
                            
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
                            self.updateProgressMeters(animated: true)
                        }
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
    
    func pointsEarnedInPayPeriod(previousOrCurrent: String) -> (dailyJobs: Int, habits: Int, weeklyJobs: Int, total: Int) {
        var isoArrayForPayPeriod: [Points]!
        
        let previous = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
            $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        let current = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        if previousOrCurrent == "previous" {
            isoArrayForPayPeriod = previous
        } else {
            isoArrayForPayPeriod = current
        }
        
        // calculate how much user has earned for all jobs and habits in current pay period
        // create array to isolate current user's points for all days that are in current pay period
        let dailyJobsSubtotal = isoArrayForPayPeriod.filter({ $0.itemCategory == "daily jobs" }).reduce(0, { $0 + $1.valuePerTap })
        let habitsSubtotal = isoArrayForPayPeriod.filter({ $0.itemCategory == "daily habits" }).reduce(0, { $0 + $1.valuePerTap })
        let weeklyJobsSubtotal = isoArrayForPayPeriod.filter({ $0.itemCategory == "weekly jobs" }).reduce(0, { $0 + $1.valuePerTap })
        let pointsSubtotal = isoArrayForPayPeriod.reduce(0, { $0 + $1.valuePerTap })
        
        return (dailyJobsSubtotal, habitsSubtotal, weeklyJobsSubtotal, pointsSubtotal)
    }
    
    func updateUserIncomeOnFirebase() {
        ref.child("mpIncome").updateChildValues([currentUserName! : Income.currentIncomeArray[MPUser.currentUser].currentPoints])
    }
    
    func prepHabitBonusSFX() {
        do {
            habitBonusSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "008732264-coin-gold", ofType: "wav")!))
            habitBonusSound.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func createNewPointsItem(itemName: String, itemCategory: String, code: String, valuePerTap: Int) {
        if itemName == "job bonus" {
            // create job bonus for last day of pay period (not first day of current pay period)
            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: FamilyData.calculatePayday().current)
        } else {
            // refresh selectedDate variable with current time
            selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateNumber, to: Date())
        }
        
        let pointsArrayItem = Points(user: currentUserName,
                                     itemName: itemName,      // previous was (usersDailyJobs?[indexPath.row].name)!
                                     itemCategory: itemCategory,
                                     code: code,
                                     valuePerTap: valuePerTap,      // previous was dailyJobsPointValue
                                     itemDate: selectedDate.timeIntervalSince1970)
        
        Points.pointsArray.append(pointsArrayItem)
        
        // add item to Firebase
        // need to organize them in some way? perhaps by date? category?
        ref.child("points").childByAutoId().setValue(["user" : currentUserName,
                                                      "itemName" : itemName,
                                                      "itemCategory" : itemCategory,
                                                      "code" : code,
                                                      "valuePerTap" : valuePerTap,
                                                      "itemDate" : selectedDate.timeIntervalSince1970])
        
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += valuePerTap
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
        updateUserIncomeOnFirebase()
    }
}






