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
        
        checkIncome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func checkIncome() {
        if Income.currentPointsArray.filter({ $0.user == currentUserName }).isEmpty {
            // create a default array
            let newUserPoints = Income(user: currentUserName, currentPoints: 0)
            Income.currentPointsArray.append(newUserPoints)
            incomeLabel.text = "$0.00"
        } else {
            for (index, item) in Income.currentPointsArray.enumerated() {
                if item.user == currentUserName {
//                    Income.currentPointsArray[index].currentPoints = 0
                    incomeLabel.text = "$\(Income.currentPointsArray[index].currentPoints)"
                }
            }
        }
    }
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == currentUserName })
        let userDailyHabits = JobsAndHabits.finalDailyHabitsArray.filter({ return $0.assigned == currentUserName })
        let userWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ return $0.assigned == currentUserName })
        if section == 0 {
            return userDailyJobs.count
        } else if section == 1 {
            return userDailyHabits.count
        } else  if section == 2 {
            return userWeeklyJobs.count
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
        } else {
            return "fees & withdrawals"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
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
                if currentUserCategoryItemDateArray[0].completedEX == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].completedEX == "X" {
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
                if currentUserCategoryItemDateArray[0].completedEX == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].completedEX == "X" {
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
                if currentUserCategoryItemDateArray[0].completedEX == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].completedEX == "X" {
                    cell.selectionBoxImageView.image = UIImage(named: "X red")
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "E gray")
                }
            }
            
        // ------------------
        // fees & withdrawals
        // ------------------
            
        } else if indexPath.section == 3 {
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
                if currentUserCategoryItemDateArray[0].completedEX == "C" {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                } else if currentUserCategoryItemDateArray[0].completedEX == "X" {
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
            // if the array isn't empty, check the completedEX. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.itemName == usersDailyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            if currentUserCategoryItemDateArray.isEmpty {
                // create new Points item and append to array
                let numberOfTaps = "C"
                let valuePerTap = dailyJobsPointValue
                let itemName = usersDailyJobs?[indexPath.row].name
                let itemCategory = "daily jobs"
                let itemDate = Date().timeIntervalSince1970
                let user = currentUserName
                
                let pointThingy = Points(completedEX: numberOfTaps, valuePerTap: valuePerTap!, itemName: itemName!, itemCategory: itemCategory, itemDate: itemDate, user: user!)
                Points.pointsArray.append(pointThingy)
                
                // update local array
                for (index, item) in Income.currentPointsArray.enumerated() {
                    if item.user == currentUserName {
                        Income.currentPointsArray[index].currentPoints += valuePerTap!
                        incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentPointsArray[index].currentPoints) / 100))"
                    }
                }
                
                tableView.reloadData()
                
            // if array isn't empty, check if numberOfTapsEX has an 'X' or an 'E'
            } else if currentUserCategoryItemDateArray[0].completedEX == "X" || currentUserCategoryItemDateArray[0].completedEX == "E" {
                print("need to get parental permission, then reset value to C")
                let alert = UIAlertController(title: "Parent Permission Required", message: "To override an 'excused' or 'unexcused' job, you must enter a parental password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                // update Points item with numberOfTapEX = 1
                
                
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
            // if the array isn't empty, check the completedEX. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && $0.itemName == usersDailyHabits?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            if currentUserCategoryItemDateArray.isEmpty {
                // create new Points item and append to array
                var valuePerTap = 0

                let numberOfTaps = "C"
                if indexPath.row == 0 {
                    valuePerTap = priorityHabitPointValue!
                } else {
                    valuePerTap = regularHabitPointValue!
                }
                let itemName = usersDailyHabits?[indexPath.row].name
                let itemCategory = "daily habits"
                let itemDate = Date().timeIntervalSince1970
                let user = currentUserName
                
                let pointThingy = Points(completedEX: numberOfTaps, valuePerTap: valuePerTap, itemName: itemName!, itemCategory: itemCategory, itemDate: itemDate, user: user!)
                Points.pointsArray.append(pointThingy)
                
                // update local array
                for (index, item) in Income.currentPointsArray.enumerated() {
                    if item.user == currentUserName {
                        Income.currentPointsArray[index].currentPoints += valuePerTap
                        incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentPointsArray[index].currentPoints) / 100))"
                    }
                }
                
                tableView.reloadData()
                
            // if array isn't empty and completedEX isn't 'X' or 'E' (if array is 'C')
            } else {
                // do nothing
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // -----------
        // weekly jobs
        // -----------
        
        if indexPath.section == 2 {
            // get an array of this user in this category for this item on this day. If it doesn't exist, then create it w/ tap value = C.
            // if the array isn't empty, check the completedEX. If it's X or E, it needs a parental pword, then it becomes C. Otherwise, do nothing
            let currentUserCategoryItemDateArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "weekly jobs" && $0.itemName == usersWeeklyJobs?[indexPath.row].name && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
            if currentUserCategoryItemDateArray.isEmpty {
                // create new Points item and append to array
                let numberOfTaps = "C"
                let valuePerTap = weeklyJobsPointValue
                let itemName = usersWeeklyJobs?[indexPath.row].name
                let itemCategory = "weekly jobs"
                let itemDate = Date().timeIntervalSince1970
                let user = currentUserName
                
                let pointThingy = Points(completedEX: numberOfTaps, valuePerTap: valuePerTap!, itemName: itemName!, itemCategory: itemCategory, itemDate: itemDate, user: user!)
                Points.pointsArray.append(pointThingy)
                
                // update local array
                for (index, item) in Income.currentPointsArray.enumerated() {
                    if item.user == currentUserName {
                        Income.currentPointsArray[index].currentPoints += valuePerTap!
                        incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentPointsArray[index].currentPoints) / 100))"
                    }
                }
                
                tableView.reloadData()
                
            // if array isn't empty, check if numberOfTapsEX has an 'X' or an 'E'
            // might want to put this code in the 'swipe from right' section, not here: if user wants to reset, they need parental password
            } else if currentUserCategoryItemDateArray[0].completedEX == "X" || currentUserCategoryItemDateArray[0].completedEX == "E" {
                print("need to get parental permission, then reset value to C")
                let alert = UIAlertController(title: "Parent Permission Required", message: "To override an 'excused' or 'unexcused' job, you must enter a parental password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                // update Points item with numberOfTapEX = C
                
                
            // if array isn't empty and numberOfTapsEX isn't 'X' or 'E'
            } else {
                // do nothing
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // ------------------
        // fees & withdrawals
        // ------------------
        
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "FeesDetailSegue", sender: self)
            } else {
                performSegue(withIdentifier: "DebtsDetailSegue", sender: self)
            }
        }
        
        updateUserTotal()
    }
    
    // ----------------------------------
    // customize swipe from right buttons
    // ----------------------------------
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //print(cell.frame.size.height)     // for determining height of cell b/c image for swipe must match cell height
        
        // --------------
        // excused action
        // --------------
        
        let excusedAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
            
            // Create alert and allow user to cancel
            let alert = UIAlertController(title: "Excused From Job", message: "\(self.currentUserName) was excused from doing the job 'clean bedroom'. \(self.currentUserName) won't lose the consistency bonus, but \(self.currentUserName) WILL be charged a $1.00 substitute fee.", preferredStyle: UIAlertControllerStyle.alert)
            
            // --------------------
            // Button ONE: "accept"
            // --------------------
            
            alert.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                print("excused accepted")
                
                // This alert shows up after user taps 'excused'. It allows user to choose who the substitute is
                let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.currentUserName)'s job 'clean bedroom'?", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Dad", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    let tempSubstituteName: String = "Dad"
                    self.subConfirmAlert(alertTitle: "Confirm Job Substitute", alertMessage: "You chose \(tempSubstituteName) as the job substitute for 'clean bedroom'. \(tempSubstituteName) will get paid the $1.00 substitute fee.\n\nDo you wish to continue?", substitute: tempSubstituteName)
                    print("\(tempSubstituteName) selected as substitute")
                }))
                alert2.addAction(UIAlertAction(title: "Mom", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    let tempSubstituteName: String = "Mom"
                    self.subConfirmAlert(alertTitle: "Confirm Job Substitute", alertMessage: "You chose \(tempSubstituteName) as the job substitute for 'clean bedroom'. \(tempSubstituteName) will get paid the $1.00 substitute fee.\n\nDo you wish to continue?", substitute: tempSubstituteName)
                    print("\(tempSubstituteName) selected as substitute")
                }))
                alert2.addAction(UIAlertAction(title: "Aiden", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    let tempSubstituteName: String = "Aiden"
                    self.subConfirmAlert(alertTitle: "Confirm Job Substitute", alertMessage: "You chose \(tempSubstituteName) as the job substitute for 'clean bedroom'. \(tempSubstituteName) will get paid the $1.00 substitute fee.\n\nDo you wish to continue?", substitute: tempSubstituteName)
                    print("\(tempSubstituteName) selected as substitute")
                }))
                alert2.addAction(UIAlertAction(title: "None", style: .cancel, handler: { (action) in
                    
                    // This alert shows up after user taps 'none'. It allows user to confirm a lack of sub, or to cancel
                    let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.currentUserName)'s job 'clean bedroom'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
                    alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                        print("nobody selected as sub. canceled")
                        alert3.dismiss(animated: true, completion: nil)}))
                    alert3.addAction(UIAlertAction(title: "accept", style: .default, handler: { (action) in
                        print("nobody selected as sub. confirmed")
                        alert3.dismiss(animated: true, completion: nil)}))
                    self.present(alert3, animated: true, completion: nil)}))
                    
                self.present(alert2, animated: true, completion: nil)}))
            
            // --------------------
            // Button TWO: "cancel"
            // --------------------
            
            alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel , handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                print("excused canceled")
            }))
            self.present(alert, animated: true, completion: nil)
        })
        
        // ----------------
        // unexcused action
        // ----------------
        
        let unexcusedAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
            
            // Create alert and allow user to cancel
            let alert = UIAlertController(title: "Unexcused From Job", message: "\(self.currentUserName) was NOT excused from doing the job 'clean bedroom'.\n\nSince this is a consistency bonus job, \(self.currentUserName) will LOSE the consistency bonus, PLUS \(self.currentUserName) will be charged a $1.00 substitute fee.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Button ONE: "accept"
            alert.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: { (action) in
                print("unexcused accepted")
                
                // This alert shows up after user taps 'excused'. It allows user to choose who the substitute is
                let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.currentUserName)'s job 'clean bedroom'?", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "Dad", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    let tempSubstituteName: String = "Dad"
                    self.subConfirmAlert(alertTitle: "Confirm Job Substitute", alertMessage: "You chose \(tempSubstituteName) as the job substitute for 'clean bedroom'. \(tempSubstituteName) will get paid the $1.00 substitute fee.\n\nDo you wish to continue?", substitute: tempSubstituteName)
                    print("\(tempSubstituteName) selected as substitute")
                }))
                alert2.addAction(UIAlertAction(title: "Mom", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    let tempSubstituteName: String = "Mom"
                    self.subConfirmAlert(alertTitle: "Confirm Job Substitute", alertMessage: "You chose \(tempSubstituteName) as the job substitute for 'clean bedroom'. \(tempSubstituteName) will get paid the $1.00 substitute fee.\n\nDo you wish to continue?", substitute: tempSubstituteName)
                    print("\(tempSubstituteName) selected as substitute")
                }))
                alert2.addAction(UIAlertAction(title: "Aiden", style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    let tempSubstituteName: String = "Aiden"
                    self.subConfirmAlert(alertTitle: "Confirm Job Substitute", alertMessage: "You chose \(tempSubstituteName) as the job substitute for 'clean bedroom'. \(tempSubstituteName) will get paid the $1.00 substitute fee.\n\nDo you wish to continue?", substitute: tempSubstituteName)
                    print("\(tempSubstituteName) selected as substitute")
                }))
                alert2.addAction(UIAlertAction(title: "None", style: .default, handler: { (action) in
                    
                    // This alert shows up after user taps 'none'. It allows user to confirm a lack of sub, or to cancel
                    let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.currentUserName)'s job 'clean bedroom'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
                    alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                        print("nobody selected as sub. canceled")
                        alert3.dismiss(animated: true, completion: nil)
                    }))
                    alert3.addAction(UIAlertAction(title: "accept", style: .default, handler: { (action) in
                        print("nobody selected as sub. confirmed")
                        alert3.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert3, animated: true, completion: nil)
                }))
                
                self.present(alert2, animated: true, completion: nil)
            }))
            
            // --------------------
            // Button TWO: "cancel"
            // --------------------
            
            alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel , handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                print("unexcused canceled")
            }))
            
            self.present(alert, animated: true, completion: nil)
        })
        
        // ------------
        // reset action
        // ------------
        
        let resetAction = UITableViewRowAction(style: .default, title: "         ", handler: { (action, indexPath) in
            print("reset tapped")
        })
        
        excusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "excused")!)       // button image must be same height as tableview row height
        unexcusedAction.backgroundColor = UIColor(patternImage: UIImage(named: "unexcused")!)
        resetAction.backgroundColor = UIColor(patternImage: UIImage(named: "reset")!)
        
        return [resetAction, unexcusedAction, excusedAction]
    }
    
    // ---------
    // Functions
    // ---------
    
    func updateUserTotal() {
//        for (index, item) in Income.currentPointsArray.enumerated() {
//            if item.user == currentUserName {
//                Income.currentPointsArray[index].currentPoints +=
//                    incomeLabel.text = "$\(Income.currentPointsArray[index].currentPoints)"
//            }
//        }
//        incomeLabel.text = "\(Income.currentPointsArray[MPUser.currentUser].currentPoints)"
    }
    
    // Alert Template
    func subConfirmAlert (alertTitle: String, alertMessage: String, substitute: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "pay \(substitute) $1.00", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("\(substitute) confirmed as substitute")
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("canceled")
        }))
        self.present(alert, animated: true, completion: nil)
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






