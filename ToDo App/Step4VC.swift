import UIKit
import Firebase

class Step4VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var dailyJobs = [JobsAndHabits]()
    var weeklyJobs = [JobsAndHabits]()
    var selectedArray = [IndexPath]()       // for storing user selected cells
    var maxDailyNumber = 3                  // max number of daily chores allowed
    var maxWeeklyNumber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        jobsTableView.tableFooterView = UIView()
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        fetchJobs()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
//        ref.child("TESTING").removeValue()
        for index in selectedArray {
            if index.section == 0 {
                ref.child("TESTING").child("dailyJob\(index.row)").updateChildValues(["assignment" : dailyJobs[index.row].name])
                print(dailyJobs[index.row].name)
            } else {
                ref.child("TESTING").child("weeklyJob\(index.row)").setValue(["assignment" : weeklyJobs[index.row].name])
                print(weeklyJobs[index.row].name)
            }
        }
        
        
        
        
        
        
        
        
        
        // OLD
        
        // ================================
//        get user selected rows -- WORKS!
//        print(selectedArray)
//        for index in selectedArray {
//            if index.section == 0 {
//                print(dailyJobs[index.row].name)
//            } else {
//                print(weeklyJobs[index.row].name)
//            }
//        }
//        print("Current Totals:",countJobs().dailyCount,countJobs().weeklyCount)

        // ================================
        
        
        
        /*
        for selection in selectedArray {
            if selection.section == 0 {
                for row in selection {
                    print(dailyJobs[selection.row].name)
                }
                
                
//                for dailyJob in dailyJobs {
//                    print(dailyJob)
//                    ref.child("TESTING").child("\(selection.row)").setValue(["name" : dailyJob.name])
//                }
                //                print(selection.row)
                //                print(dailyJobs[index.row].name)        // gives names of daily jobs
            } else {
                for weeklyJob in weeklyJobs {
//                    ref.child("TESTING").child("\(selection.row)").setValue(["name" : weeklyJob.name])
                }
                //                print(selection.row)                      // gives indexes of weekly jobs
            }
        }
        print(dailyJobs[section.row].name)
        print(weeklyJobs[section.row].name)       // gives names of weekly jobs
        */
    }
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    //set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyJobs.count
        } else {
            return weeklyJobs.count
        }
    }
    
    //Give each table section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else {
            return "weekly jobs"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    
    // what are the contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step4CustomCell", for: indexPath) as! Step4CustomCell
        // popluate 2 sections with daily and weekly job names
        if indexPath.section == 0 {
            cell.jobLabel.text = dailyJobs[indexPath.row].name
        } else {
            cell.jobLabel.text = weeklyJobs[indexPath.row].name
        }
        // change selection box if user taps on cell
        if (selectedArray.contains(indexPath)) {
            cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
        } else {
            cell.selectionBoxImageView.image = UIImage(named: "blank")
        }
        return cell
    }
    
    // determine which cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // push value to Firebase
            ref.child("Test")
                .child("dailyJob\(indexPath.row)")
                .updateChildValues(["assigned" : dailyJobs[indexPath.row].name])
        } else {
            // push value to Firebase
            ref.child("Test")
                .child("weeklyJob\(indexPath.row)")
                .updateChildValues(["assigned" : weeklyJobs[indexPath.row].name])
        }
        
       
        
        if (!selectedArray.contains(indexPath)) {           // only add to array if it doesn't already exist
            selectedArray.append(indexPath)
            // print("Item Added",selectedArray)
            
            let dailyJobsCount = countJobs().dailyCount
            let weeklyJobsCount = countJobs().weeklyCount
            
            // ----------
            // DAILY JOBS
            // ----------
            
            // check if daily jobs is more than 3
            if dailyJobsCount > maxDailyNumber {
                let alert = UIAlertController(title: "Daily Jobs", message: "You have chosen \(dailyJobsCount) daily jobs. It is recommended that each individual only have three daily jobs max. Are you sure you want to assign 'USER' \(dailyJobsCount) daily jobs?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    let index = self.selectedArray.index(of: indexPath)
                    
                    // update Firebase with 'none' in 'assigned' category...
                    self.ref.child("Test")
                        .child("dailyJob\(indexPath.row)")
                        .updateChildValues(["assigned" : "none"])
                    
                    // ... then remove value from array
                    self.selectedArray.remove(at: index!)
                    tableView.reloadData()
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                    self.maxDailyNumber = self.maxDailyNumber + 1
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                
                // -----------
                // WEEKLY JOBS
                // -----------
                
                // check if weekly jobs is more than 2
                if weeklyJobsCount > maxWeeklyNumber {
                    let alert = UIAlertController(title: "Weekly Jobs", message: "You have chosen \(weeklyJobsCount) daily jobs. It is recommended that each individual only have 2 weekly jobs max. Are you sure you want to assign 'USER' \(weeklyJobsCount) daily jobs?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                        let index = self.selectedArray.index(of: indexPath)
                        
                        // update Firebase with 'none' in 'assigned' category...
                        self.ref.child("Test")
                            .child("weeklyJob\(indexPath.row)")
                            .updateChildValues(["assigned" : "none"])
                        
                        // ... then remove value from array
                        self.selectedArray.remove(at: index!)
                        tableView.reloadData()
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                        self.maxWeeklyNumber = self.maxWeeklyNumber + 1
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            
            // if user taps cell that's already been selected, remove the values
            let index = selectedArray.index(of: indexPath)
            
            if indexPath.section == 0 {
                // update Firebase with 'none' in 'assigned' category...
                self.ref.child("Test")
                    .child("dailyJob\(indexPath.row)")
                    .updateChildValues(["assigned" : "none"])
            } else {
                // update Firebase with 'none' in 'assigned' category...
                self.ref.child("Test")
                    .child("weeklyJob\(indexPath.row)")
                    .updateChildValues(["assigned" : "none"])
            }
            
            
            
            // ... then remove value from array
            selectedArray.remove(at: index!)
            // print("Item Removed",selectedArray)
        }
        
        print(countJobs().dailyCount,"daily jobs chosen")
        print(countJobs().weeklyCount,"weekly jobs chosen")
        
        tableView.reloadData()      // reloads table so checkmark will show up
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func countJobs() -> (dailyCount: Int, weeklyCount: Int) {
        var dailyJobsCount = 0
        var weeklyJobsCount = 0
        for index in selectedArray {
            if index.section == 0 {
                dailyJobsCount += 1                     // count number of daily jobs
                //                print(dailyJobs[index.row].name)        // give names of daily jobs
            } else {
                weeklyJobsCount += 1                    // count number of weekly jobs
                //                print(weeklyJobs[index.row].name)       // give names of weekly jobs
            }
        }
        return (dailyJobsCount, weeklyJobsCount)
    }
    
    func fetchJobs() {
        ref.child("dailyJobs").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let multiplier = dictionary["multiplier"] as! Double
                let name = dictionary["name"] as! String
                let classification = dictionary["classification"] as! String
                let order = dictionary["order"] as! Int
                
                let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobClass: classification, jobOrder: order)
                self.dailyJobs.append(dailyJob)
                self.dailyJobs.sort(by: {$0.order < $1.order})
                
                self.jobsTableView.reloadData()
            }
        })
        
        ref.child("weeklyJobs").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let multiplier = dictionary["multiplier"] as! Double
                let name = dictionary["name"] as! String
                let classification = dictionary["classification"] as! String
                let order = dictionary["order"] as! Int
                
                let weeklyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobClass: classification, jobOrder: order)
                self.weeklyJobs.append(weeklyJob)
                self.weeklyJobs.sort(by: {$0.order < $1.order})
                
                self.jobsTableView.reloadData()
            }
        })
    }
}






