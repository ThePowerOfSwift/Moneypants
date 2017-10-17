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
    
    var currentMember = 0           // used for cycling through users when 'next' button is tapped
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
        
        checkSetupNumber()
    }
    
    // ---------------
    // Setup TableView
    // ---------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyHabits.count
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
    
    // what are contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step4HabitCell", for: indexPath) as! Step4HabitCell
        let (dailyHabitName, _, _, _) = dailyHabits[indexPath.row]
        cell.habitLabel.text = dailyHabitName
        return cell
    }
    
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
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
        if JobsAndHabits.finalDailyHabitsArray.count == 0 {
            loadDefaultDailyHabits()
            createDefaultDailyHabitsOnFirebase()
        }
    }
    
    func loadDefaultDailyHabits() {
        // create array of default daily habits, NOTE: First habit in list is bonus habit
        JobsAndHabits.finalDailyHabitsArray = [JobsAndHabits(name: "get ready for day by 10:am", description: "daily habit", assigned: "true", order: 1),
                                               JobsAndHabits(name: "personal meditation (10 min)", description: "daily habit", assigned: "true", order: 2),
                                               JobsAndHabits(name: "daily exercise", description: "daily habit", assigned: "true", order: 3),
                                               JobsAndHabits(name: "develop talents (20 min)", description: "daily habit", assigned: "true", order: 4),
                                               JobsAndHabits(name: "homework done by 5:pm", description: "daily habit", assigned: "true", order: 5),
                                               JobsAndHabits(name: "good manners", description: "daily habit", assigned: "true", order: 6),
                                               JobsAndHabits(name: "peacemaking (no fighting)", description: "daily habit", assigned: "true", order: 7),
                                               JobsAndHabits(name: "helping hands / obedience", description: "daily habit", assigned: "true", order: 8),
                                               JobsAndHabits(name: "write in journal", description: "daily habit", assigned: "true", order: 9),
                                               JobsAndHabits(name: "bed by 8:pm", description: "daily habit", assigned: "true", order: 10)]
        habitsTableView.reloadData()
    }
    
    func createDefaultDailyHabitsOnFirebase() {
        for user in User.finalUsersArray {
            var dailyCounter = 0
            for dailyHabit in JobsAndHabits.finalDailyHabitsArray {
                ref.child("dailyHabits").child(user.firstName).childByAutoId().setValue(["name" : dailyHabit.name,
                                                                                         "description" : "habit description",
                                                                                         "assigned" : "true",
                                                                                         "order" : dailyCounter])
                dailyCounter += 1
            }
        }
        
    }
    
    func checkSetupNumber() {
        if FamilyData.setupProgress >= 43 {
            // first view will be of youngest family member
            self.userImage.image = User.finalUsersArray[0].photo
            self.currentUserName = User.finalUsersArray[0].firstName
            self.instructionsLabel.text = "Review daily habits for \(User.finalUsersArray[0].firstName)."
            self.navigationItem.title = User.finalUsersArray[0].firstName
            self.habitsTableView.reloadData()
            self.reviewAllButton.isHidden = false
            self.nextButton.isEnabled = false
            self.selectUsersButton.isHidden = false
            
        } else {
            
            // if user hasn't done setup yet, show the overlay
            self.performSegue(withIdentifier: "UserIntroPopup", sender: self)
            self.userImage.image = User.finalUsersArray[0].photo
            self.currentUserName = User.finalUsersArray[0].firstName
            self.instructionsLabel.text = "Review daily habits for \(User.finalUsersArray[0].firstName)."
            self.navigationItem.title = User.finalUsersArray[0].firstName
            self.habitsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserIntroPopup" {
            let nextViewController = segue.destination as! Step4HabitIntroVC
            nextViewController.popupImage = User.finalUsersArray[currentMember].photo
            nextViewController.mainLabelText = User.finalUsersArray[currentMember].firstName
        }
    }
}








