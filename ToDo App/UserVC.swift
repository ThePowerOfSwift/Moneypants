import UIKit

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLower: UILabel!
    @IBOutlet weak var greenGrid: UIButton!
        
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------
        // badges
        // ------
        
        tabBarController?.tabBar.items?[2].badgeValue = "1"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = userName
        userImage.image = userPicture
        incomeLabel.text = "$\(userIncome)"
        
        userImage.layer.cornerRadius = topView.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        greenGrid.layer.cornerRadius = greenGrid.bounds.height / 6.4
        greenGrid.layer.masksToBounds = true
        greenGrid.layer.borderWidth = 0.5
        greenGrid.layer.borderColor = UIColor.black.cgColor
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d"        // day of year
        let result = formatter.string(from: date)
        
        // ---------------
        // Date calculator
        // ---------------
        
        func dayDifference(from interval : TimeInterval) -> String
        {
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
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyChoresSavannah.count
        } else if section == 1 {
            return dailyHabits.count
        } else {
            return weeklyChoresSavannah.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily chores"
        } else if section == 1 {
            return "daily habits"
        } else {
            return "weekly chores"
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
        if indexPath.section == 0 {
            let (choreHabitName, pointsLabelValue, _, _) = dailyChoresSavannah[indexPath.row]
            cell.choreHabitLabel.text = choreHabitName
            cell.pointsLabel.text = "\(pointsLabelValue * 15)"
        } else if indexPath.section == 1 {
            let (choreHabitName, pointsLabelValue, _, _) = dailyHabits[indexPath.row]
            cell.choreHabitLabel.text = choreHabitName
            cell.pointsLabel.text = "\(Int(pointsLabelValue * 15))"
        } else {
            let (choreHabitName, pointsLabelValue, _, _) = weeklyChoresSavannah[indexPath.row]
            cell.choreHabitLabel.text = choreHabitName
            cell.pointsLabel.text = "\(Int(pointsLabelValue * 15))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tapCounter += 1
//        print("button tapped at \([indexPath.section]) \([indexPath.row])")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! UserCell
//        cell.numberLabel.text = "0"
        tableView.reloadData()
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
            let alert = UIAlertController(title: "Excused From Job", message: "\(self.userName) was excused from doing the job 'clean bedroom'. \(self.userName) won't lose the consistency bonus, but \(self.userName) WILL be charged a $1.00 substitute fee.", preferredStyle: UIAlertControllerStyle.alert)
            
            // --------------------
            // Button ONE: "accept"
            // --------------------
            
            alert.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                print("excused accepted")
                
                // This alert shows up after user taps 'excused'. It allows user to choose who the substitute is
                let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.userName)'s job 'clean bedroom'?", preferredStyle: UIAlertControllerStyle.alert)
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
                    let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.userName)'s job 'clean bedroom'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
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
            let alert = UIAlertController(title: "Unexcused From Job", message: "\(self.userName) was NOT excused from doing the job 'clean bedroom'.\n\nSince this is a consistency bonus job, \(self.userName) will LOSE the consistency bonus, PLUS \(self.userName) will be charged a $1.00 substitute fee.", preferredStyle: UIAlertControllerStyle.alert)
            
            // Button ONE: "accept"
            alert.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: { (action) in
                print("unexcused accepted")
                
                // This alert shows up after user taps 'excused'. It allows user to choose who the substitute is
                let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.userName)'s job 'clean bedroom'?", preferredStyle: UIAlertControllerStyle.alert)
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
                    let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.userName)'s job 'clean bedroom'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
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
    
    // --------------
    // Alert Template
    // --------------
    
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
    
    // -----------
    // Home Button
    // -----------
    
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






