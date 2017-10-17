import UIKit
import Firebase

class Step4HabitVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var habitsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var selectUsersButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var reviewAllButton: UIButton!
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
        reviewAllButton.isHidden = true
        
        habitsTableView.delegate = self
        habitsTableView.dataSource = self
        habitsTableView.tableFooterView = UIView()
        
        fetchHabits()
        
        loadFirstUser()
        
        // only show habit for current user, not entire habits array of all users
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
        if FamilyData.setupProgress <= 43 {
            FamilyData.setupProgress = 43
            ref.updateChildValues(["setupProgress" : 43])
        }
    }
    
    @IBAction func selectUserButtonTapped(_ sender: UIButton) {
        print("choose user button tapped")
    }
    
    @IBAction func reviewAllButtonTapped(_ sender: UIButton) {
        print("review all button tapped")
    }
    
    // ---------
    // Functions
    // ---------
    
    func fetchHabits() {
        
        // MARK: TODO - check each user individually to make sure they have 10 habits (perhaps a new user was added and thus didn't get new habits yet?)
        
        if JobsAndHabits.finalDailyHabitsArray.count == 0 {
            loadDefaultDailyHabits()
            createDefaultDailyHabitsOnFirebase()
        }
    }
    
    func loadDefaultDailyHabits() {
        // MARK: TODO - check for age of user, and create age-appropriate habits list
        for user in User.finalUsersArray {
            print(user.birthday)
            if user.birthday > 18 {
                JobsAndHabits.finalDailyHabitsArray = [JobsAndHabits(name: "enter your top priority habit here", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 1),
                                                       JobsAndHabits(name: "prayer & scripture study", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 2),
                                                       JobsAndHabits(name: "exercise (20 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 3),
                                                       JobsAndHabits(name: "journal", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 4),
                                                       JobsAndHabits(name: "1-on-1 time with kid", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 5),
                                                       JobsAndHabits(name: "practice talent (30 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 6),
                                                       JobsAndHabits(name: "good deed / service", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 7),
                                                       JobsAndHabits(name: "family prayer & scriptures", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 8),
                                                       JobsAndHabits(name: "on time to events", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 9),
                                                       JobsAndHabits(name: "read (20 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 10)]
            } else if user.birthday < 5 {
                JobsAndHabits.finalDailyHabitsArray = [JobsAndHabits(name: "reading & writing lesson", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 1),
                                                       JobsAndHabits(name: "pick up toys after play", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 2),
                                                       JobsAndHabits(name: "please & thank you", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 3),
                                                       JobsAndHabits(name: "kindness & peacemaking", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 4),
                                                       JobsAndHabits(name: "nap", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 5),
                                                       JobsAndHabits(name: "immediate obedience", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 6),
                                                       JobsAndHabits(name: "bedtime by 7:pm", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 7),
                                                       JobsAndHabits(name: "use toilet / dry bed", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 8),
                                                       JobsAndHabits(name: "pray", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 9),
                                                       JobsAndHabits(name: "exercise (10 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 10)]
                
                
                
                
            } else {
                JobsAndHabits.finalDailyHabitsArray = [JobsAndHabits(name: "enter your top priority habit here", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 1),
                                                       JobsAndHabits(name: "prayer & scripture study", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 2),
                                                       JobsAndHabits(name: "exercise (20 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 3),
                                                       JobsAndHabits(name: "practice talent (20 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 4),
                                                       JobsAndHabits(name: "homework done by 5:pm", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 5),
                                                       JobsAndHabits(name: "good deed / service", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 6),
                                                       JobsAndHabits(name: "peacemaking (no fighting)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 7),
                                                       JobsAndHabits(name: "helping hands", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 8),
                                                       JobsAndHabits(name: "write in journal", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 9),
                                                       JobsAndHabits(name: "bed by 8:pm", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 10)]
            }
        }
        
        // create array of default daily habits, NOTE: First habit in list is bonus habit
        JobsAndHabits.finalDailyHabitsArray = [JobsAndHabits(name: "enter your top priority habit here", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 1),
                                               JobsAndHabits(name: "personal meditation (10 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 2),
                                               JobsAndHabits(name: "daily exercise", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 3),
                                               JobsAndHabits(name: "develop talents (20 min)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 4),
                                               JobsAndHabits(name: "homework done by 5:pm", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 5),
                                               JobsAndHabits(name: "good manners", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 6),
                                               JobsAndHabits(name: "peacemaking (no fighting)", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 7),
                                               JobsAndHabits(name: "helping hands / obedience", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 8),
                                               JobsAndHabits(name: "write in journal", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 9),
                                               JobsAndHabits(name: "bed by 8:pm", description: "daily habit", assigned: User.finalUsersArray[currentMember].firstName, order: 10)]
        
        habitsTableView.reloadData()
    }
    
    func createDefaultDailyHabitsOnFirebase() {
        for user in User.finalUsersArray {
            var dailyCounter = 0
            for dailyHabit in JobsAndHabits.finalDailyHabitsArray {
                ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                         "description" : "habit description",
                                                                                         "assigned" : user.firstName,
                                                                                         "order" : dailyCounter])
                dailyCounter += 1
            }
        }
    }
    
    func loadFirstUser() {
        self.userImage.image = User.finalUsersArray[0].photo
        self.currentUserName = User.finalUsersArray[0].firstName
        self.instructionsLabel.text = "Review daily habits for \(User.finalUsersArray[0].firstName)."
        self.navigationItem.title = User.finalUsersArray[0].firstName
        self.habitsTableView.reloadData()
        self.reviewAllButton.isHidden = false
        self.nextButton.isEnabled = false
        self.selectUsersButton.isHidden = false
    }
}








