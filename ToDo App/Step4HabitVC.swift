import UIKit
import Firebase

class Step4HabitVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var selectUsersButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var currentMember: Int = 0           // used for cycling through users when 'next' button is tapped
    var currentUserName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        userImage.layer.cornerRadius = userImage.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        User.finalUsersArray.sort(by: {$0.birthday > $1.birthday})       // sort users by birthday with youngest first

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
        let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.finalUsersArray[currentMember].firstName })
        return habitsArray.count
    }
    
    // what are contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step4HabitCell", for: indexPath) as! Step4HabitCell
        // only show habit for current user, not entire habits array of all users. NOTE: Have to call this variable every time for table to reload properly (can't make it a global var)
        let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.finalUsersArray[currentMember].firstName })
        
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
        let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.finalUsersArray[currentMember].firstName })
        performSegue(withIdentifier: "EditHabit", sender: habitsArray[indexPath.row])
    }
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditHabit" {
            let nextViewController = segue.destination as! Step4EditHabitVC
            // send the habit from the tableview cell above to Step4EditHabitVC
            nextViewController.habit = sender as! JobsAndHabits
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if selectUsersButton.isHidden == false {
            // user has already completed this section and can move forward
            reviewOrContinueAlert()
        } else {
            // if user is NOT oldest member of family...
            if currentMember != (User.finalUsersArray.count - 1) {
                // ...go to next user
                currentMember += 1
                //            let habitsArray = JobsAndHabits.finalDailyHabitsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == User.finalUsersArray[currentMember].firstName })
                userImage.image = User.finalUsersArray[currentMember].photo
                currentUserName = User.finalUsersArray[currentMember].firstName
                instructionsLabel.text = "Review daily habits for \(User.finalUsersArray[currentMember].firstName)."
                navigationItem.title = User.finalUsersArray[currentMember].firstName
                habitsTableView.reloadData()
            } else if currentMember == (User.finalUsersArray.count - 1) {
                if FamilyData.setupProgress <= 43 {
                    FamilyData.setupProgress = 43
                    ref.updateChildValues(["setupProgress" : 43])
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
            self.performSegue(withIdentifier: "MemberIncome", sender: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectUserButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A User", message: "Please choose a family member to review their habits.", preferredStyle: .alert)
        for (index, user) in User.finalUsersArray.enumerated() {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                self.currentMember = index
                self.userImage.image = User.finalUsersArray[self.currentMember].photo
                self.currentUserName = User.finalUsersArray[self.currentMember].firstName
                self.instructionsLabel.text = "Choose daily habits for \(User.finalUsersArray[self.currentMember].firstName)"
                self.navigationItem.title = User.finalUsersArray[self.currentMember].firstName
                self.habitsTableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
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
        for user in User.finalUsersArray {
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
                    for (index, dailyHabit) in parentalHabitsArray.enumerated() {
                        ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                                 "description" : "habit description",
                                                                                                 "assigned" : user.firstName,
                                                                                                 "order" : index])
                    }
                } else if calculateAge(birthday: "\(user.birthday)") < 5 {
                    // append local array with toddler array...
                    JobsAndHabits.finalDailyHabitsArray += toddlerHabitsArray
                    // ...and send array to Firebase
                    for (index, dailyHabit) in toddlerHabitsArray.enumerated() {
                        ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                                 "description" : "habit description",
                                                                                                 "assigned" : user.firstName,
                                                                                                 "order" : index])
                    }
                } else {
                    // append local array with standard array...
                    JobsAndHabits.finalDailyHabitsArray += standardHabitsArray
                    // ...and send array to Firebase
                    for (index, dailyHabit) in standardHabitsArray.enumerated() {
                        ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                                 "description" : "habit description",
                                                                                                 "assigned" : user.firstName,
                                                                                                 "order" : index])
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
        if FamilyData.setupProgress >= 43 {
            // ...unhide the 'select user' button and allow user to choose other members for review
            selectUsersButton.isHidden = false
        } else {
            selectUsersButton.isHidden = true
        }
        userImage.image = User.finalUsersArray[0].photo
        currentUserName = User.finalUsersArray[0].firstName
        instructionsLabel.text = "Review daily habits for \(User.finalUsersArray[0].firstName)."
        navigationItem.title = User.finalUsersArray[0].firstName
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








