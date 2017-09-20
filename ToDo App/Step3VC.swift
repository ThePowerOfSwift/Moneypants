import UIKit

class Step3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var jobsTableView: UITableView!
    
    var dailyJobs = [JobsAndHabits]()
    var weeklyJobs = [JobsAndHabits]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        
        // add + symbol in navbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJobButtonTapped))
                
        loadDefaultJobsAndHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        jobsTableView.reloadData()
    }
    
    
    // ATTEMPT #2

    // ----------------
    // Setup Table View
    // ----------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyJobs.count
        } else {
            return weeklyJobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = jobsTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step3CustomCell
        if indexPath.section == 0 {
            cell.jobLabel.text = dailyJobs[indexPath.row].name
        } else {
            cell.jobLabel.text = weeklyJobs[indexPath.row].name
        }
        return cell
    }
    
    //Give each table section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else {
            return "weekly jobs"
        }
    }
    
    // Customize header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "EditJob", sender: dailyJobs[indexPath.row])
        } else {
            performSegue(withIdentifier: "EditJob", sender: weeklyJobs[indexPath.row])
        }
    }

    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditJob" {
            let nextController = segue.destination as! Step3AddJobVC
            // 'sender' is retrieved from 'didSelectRow' function above
            print("sender is: \(sender!)")
            nextController.job = sender as! JobsAndHabits?
            nextController.navBarTitle = "edit job"
        } else if segue.identifier == "AddJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "add job"
            print("add job segue initiated")
        } else {
            print("another segue initiated")
        }
    }
    
    @IBAction func unwindToStep3VC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! Step3AddJobVC
        let updatedJob = sourceVC.job
        if let selectedIndexPathSection = jobsTableView.indexPathForSelectedRow?.section {      // if tableview cell was selected to begin with
            
            // Update existing job
            if selectedIndexPathSection == 0 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                dailyJobs[(selectedIndexPathRow?.row)!] = updatedJob!
                jobsTableView.reloadData()
            } else if selectedIndexPathSection == 1 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                weeklyJobs[(selectedIndexPathRow?.row)!] = updatedJob!
                jobsTableView.reloadData()
            }
        } else {
            
            // Add a new daily job in the daily jobs array
            let newIndexPath = IndexPath(row: dailyJobs.count, section: 0)
            dailyJobs.append(updatedJob!)
            jobsTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        // save to Firebase here
        print("time to update Firebase with ", updatedJob!.name)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /* =====================================================================================
    // THIS WORKS TO SEND SELECTED CELL TO ADDJOBVC, but doesn't allow for saving changes
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "EditJob", sender: dailyJobs[indexPath.row].name)
        } else {
            performSegue(withIdentifier: "EditJob", sender: weeklyJobs[indexPath.row].name)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditJob" {
            let nextController = segue.destination as! Step3AddJobVC
            // 'sender' is retrieved from 'didSelectRow' function above
            nextController.jobDescription = sender as! String
            nextController.navBarTitle = "edit job"
        } else if segue.identifier == "AddJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "add job"
            print("add job segue initiated")
        } else {
            print("another segue initiated")
        }
    }
    
    @IBAction func unwindToStep3VC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as? Step3AddJobVC
        let updatedJob = sourceVC?.job?.name
        print(updatedJob)
        let selectedIndexPath = jobsTableView.indexPathForSelectedRow
        print("unwind segue successful")
    }
    
    // ===================================================================================== */
    
    
    
    
    
    
    
    
    
    
    
    
    
    // ---------
    // Functions
    // ---------
    
    func addJobButtonTapped() {
        performSegue(withIdentifier: "AddJob", sender: self)
    }
    
    
    func loadDefaultJobsAndHabits() {
        
        // create array of default jobs and habits
        dailyJobs = [JobsAndHabits(jobName: "bedroom", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "bathrooms", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "laundry", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "living room", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "sweep & vacuum", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "wipe table", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "counters", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "dishes", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "meal prep", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "feed pet / garbage", jobMultiplier: 1, jobClass: "dailyJob")]
        weeklyJobs = [JobsAndHabits(jobName: "sweep porch", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "weed garden", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "wash windows", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "dusting & cobwebs", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "mop floors", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "clean cabinets", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "clean fridge", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "wash car", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "mow lawn", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "babysit (per hour)", jobMultiplier: 1, jobClass: "weeklyJob")]
        //        dailyHabits = [JobsAndHabits(jobName: "get ready for day by 10:am", jobMultiplier: 5, jobClass: "dailyHabit"),      // This is bonus habit **
        //                       JobsAndHabits(jobName: "personal meditation (10 min)", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "daily exercise", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "develop talents (20 min)", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "homework done by 5:pm", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "good manners", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "peacemaking (no fighting)", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "helping hands / obedience", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "write in journal", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "bed by 8:pm", jobMultiplier: 1, jobClass: "dailyHabit")]

    }
}





