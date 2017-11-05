import UIKit
import Firebase

class Step7HabitsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var selectUsersButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var currentUserName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.currentUser = (User.usersArray.count - 1)          // start with youngest user first
        currentUserName = User.usersArray[User.currentUser].firstName
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        userImage.layer.cornerRadius = userImage.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        currentUserName = ""
        instructionsLabel.text = ""
        selectUsersButton.isHidden = true
        
        habitsTableView.delegate = self
        habitsTableView.dataSource = self
        habitsTableView.tableFooterView = UIView()
        
        loadHabits()
        
        checkSetupNumber()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        habitsTableView.reloadData()
    }
    
    // ---------------
    // Setup TableView
    // ---------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // only show habit for current user, not entire habits array of all users
        let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.usersArray[User.currentUser].firstName })
        return habitsArray.count
    }
    
    // what are contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step7HabitsCell", for: indexPath) as! Step7HabitsCell
        // only show habit for current user, not entire habits array of all users. NOTE: Have to call this variable every time for table to reload properly (can't make it a global var)
        let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.usersArray[User.currentUser].firstName })
        
        if indexPath.row == 0 {
            cell.habitLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold)
        } else {
            cell.habitLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
        }
        
        cell.habitLabel.text = habitsArray[indexPath.row].name
        return cell
    }

    // Give section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "daily habits"
    }
    
    // customize title look
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.usersArray[User.currentUser].firstName })
        performSegue(withIdentifier: "EditHabit", sender: habitsArray[indexPath.row])
    }
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditHabit" {
            let nextViewController = segue.destination as! Step7EditHabitsVC
            // send the habit from the tableview cell above to Step7EditHabitsVC
            nextViewController.habit = sender as! JobsAndHabits
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if selectUsersButton.isHidden == false {
            // user has already completed this section and can move forward
            reviewOrContinueAlert()
        } else {
            // if user is NOT oldest member of family...
            if User.currentUser != 0 {
                // ...go to next user
                User.currentUser -= 1
                userImage.image = User.usersArray[User.currentUser].photo
                currentUserName = User.usersArray[User.currentUser].firstName
                instructionsLabel.text = "Review daily habits for \(User.usersArray[User.currentUser].firstName)."
                navigationItem.title = User.usersArray[User.currentUser].firstName
                habitsTableView.reloadData()
            } else if User.currentUser == 0 {
                if FamilyData.setupProgress <= 7 {
                    FamilyData.setupProgress = 7
                    ref.updateChildValues(["setupProgress" : 7])
                }
                reviewOrContinueAlert()
            }
        }
    }
    
    func reviewOrContinueAlert() {
        let alert = UIAlertController(title: "Review Habits", message: "Do you wish to review any assigned habits, or continue with setup?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "review", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            // enable hidden button and allow user to select other users for review
            self.selectUsersButton.isHidden = false
        }))
        alert.addAction(UIAlertAction(title: "continue", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            User.currentUser = (User.usersArray.count - 1)          // start financial section with youngest user first
            self.selectUsersButton.isHidden = false
            self.performSegue(withIdentifier: "MemberIncome", sender: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectUserButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A User", message: "Please choose a family member to review their habits.", preferredStyle: .alert)
        for (index, user) in User.usersArray.enumerated() {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                User.currentUser = index
                self.userImage.image = user.photo
                self.currentUserName = user.firstName
                self.instructionsLabel.text = "Choose daily habits for \(user.firstName)."
                self.navigationItem.title = user.firstName
                self.habitsTableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        
        // ORIGINAL CODE
        /*
        for (index, user) in User.usersArray.enumerated() {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                User.currentUser = index
                self.userImage.image = User.usersArray[User.currentUser].photo
                self.currentUserName = User.usersArray[User.currentUser].firstName
                self.instructionsLabel.text = "Choose daily habits for \(User.usersArray[User.currentUser].firstName)."
                self.navigationItem.title = User.usersArray[User.currentUser].firstName
                self.habitsTableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        */
        // end ORIGINAL CODE
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // ---------
    // Functions
    // ---------
    
    func loadHabits() {
        
        // MARK: make sure every user has habits (perhaps a new user was added and thus didn't get new habits yet?)
        for user in User.usersArray {
            if !JobsAndHabits.finalDailyHabitsArray.contains(where: { $0.assigned == user.firstName }) {
                print(user.firstName,"does not have any habits assigned")
                
                let parentalHabitsArray = [JobsAndHabits(name: "enter your top priority habit here", description: "daily habit", assigned: user.firstName, order: 1),
                                           JobsAndHabits(name: "prayer & scripture study", description: "daily habit", assigned: user.firstName, order: 2),
                                           JobsAndHabits(name: "exercise (20 min)", description: "daily habit", assigned: user.firstName, order: 3),
                                           JobsAndHabits(name: "journal", description: "daily habit", assigned: user.firstName, order: 4),
                                           JobsAndHabits(name: "1-on-1 time with kid", description: "daily habit", assigned: user.firstName, order: 5),
                                           JobsAndHabits(name: "practice talent (30 min)", description: "daily habit", assigned: user.firstName, order: 6),
                                           JobsAndHabits(name: "good deed / service", description: "daily habit", assigned: user.firstName, order: 7),
                                           JobsAndHabits(name: "family prayer & scriptures", description: "daily habit", assigned: user.firstName, order: 8),
                                           JobsAndHabits(name: "on time to events", description: "daily habit", assigned: user.firstName, order: 9),
                                           JobsAndHabits(name: "read (20 min)", description: "daily habit", assigned: user.firstName, order: 10)]
                
                let toddlerHabitsArray = [JobsAndHabits(name: "reading & writing lesson", description: "daily habit", assigned: user.firstName, order: 1),
                                          JobsAndHabits(name: "pick up toys after play", description: "daily habit", assigned: user.firstName, order: 2),
                                          JobsAndHabits(name: "please & thank you", description: "daily habit", assigned: user.firstName, order: 3),
                                          JobsAndHabits(name: "kindness & peacemaking", description: "daily habit", assigned: user.firstName, order: 4),
                                          JobsAndHabits(name: "nap", description: "daily habit", assigned: user.firstName, order: 5),
                                          JobsAndHabits(name: "immediate obedience", description: "daily habit", assigned: user.firstName, order: 6),
                                          JobsAndHabits(name: "bedtime by 7:pm", description: "daily habit", assigned: user.firstName, order: 7),
                                          JobsAndHabits(name: "use toilet / dry bed", description: "daily habit", assigned: user.firstName, order: 8),
                                          JobsAndHabits(name: "pray", description: "daily habit", assigned: user.firstName, order: 9),
                                          JobsAndHabits(name: "exercise (10 min)", description: "daily habit", assigned: user.firstName, order: 10)]
                
                let standardHabitsArray = [JobsAndHabits(name: "enter your top priority habit here", description: "daily habit", assigned: user.firstName, order: 1),
                                           JobsAndHabits(name: "prayer & scripture study", description: "daily habit", assigned: user.firstName, order: 2),
                                           JobsAndHabits(name: "exercise (20 min)", description: "daily habit", assigned: user.firstName, order: 3),
                                           JobsAndHabits(name: "practice talent (20 min)", description: "daily habit", assigned: user.firstName, order: 4),
                                           JobsAndHabits(name: "homework done by 5:pm", description: "daily habit", assigned: user.firstName, order: 5),
                                           JobsAndHabits(name: "good deed / service", description: "daily habit", assigned: user.firstName, order: 6),
                                           JobsAndHabits(name: "peacemaking (no fighting)", description: "daily habit", assigned: user.firstName, order: 7),
                                           JobsAndHabits(name: "helping hands", description: "daily habit", assigned: user.firstName, order: 8),
                                           JobsAndHabits(name: "write in journal", description: "daily habit", assigned: user.firstName, order: 9),
                                           JobsAndHabits(name: "bed by 8:pm", description: "daily habit", assigned: user.firstName, order: 10)]
                
                if user.childParent == "parent" {
                    // append local array with parental array...
                    JobsAndHabits.finalDailyHabitsArray += parentalHabitsArray
                    // ...and send array to Firebase
                    for dailyHabit in parentalHabitsArray {
                        ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                                 "description" : dailyHabit.description,
                                                                                                 "assigned" : user.firstName,
                                                                                                 "order" : dailyHabit.order])
                    }
                } else if calculateAge(birthday: "\(user.birthday)") < 5 {
                    // append local array with toddler array...
                    JobsAndHabits.finalDailyHabitsArray += toddlerHabitsArray
                    // ...and send array to Firebase
                    for dailyHabit in toddlerHabitsArray {
                        ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                                 "description" : dailyHabit.description,
                                                                                                 "assigned" : user.firstName,
                                                                                                 "order" : dailyHabit.order])
                    }
                } else {
                    // append local array with standard array...
                    JobsAndHabits.finalDailyHabitsArray += standardHabitsArray
                    // ...and send array to Firebase
                    for dailyHabit in standardHabitsArray {
                        ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                                 "description" : dailyHabit.description,
                                                                                                 "assigned" : user.firstName,
                                                                                                 "order" : dailyHabit.order])
                    }
                }
                
            } else {
                print("\(user.firstName) has habits assigned")
            }
        }
        habitsTableView.reloadData()
    }
    
    func checkSetupNumber() {
        // if user has already been to this page of setup...
        if FamilyData.setupProgress >= 7 {
            // ...unhide the 'select user' button and allow user to choose other members for review
            selectUsersButton.isHidden = false
        } else {
            selectUsersButton.isHidden = true
        }
        userImage.image = User.usersArray[User.currentUser].photo
        currentUserName = User.usersArray[User.currentUser].firstName
        instructionsLabel.text = "Review daily habits for \(User.usersArray[User.currentUser].firstName)."
        navigationItem.title = User.usersArray[User.currentUser].firstName
        habitsTableView.reloadData()
    }
    
    func calculateAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyyMMdd"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calculatedAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
        let age = calculatedAge.year
        return age!
    }
}








