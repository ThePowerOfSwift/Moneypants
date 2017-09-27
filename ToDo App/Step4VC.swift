import UIKit
import Firebase

class Step4VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var dailyJobs = [JobsAndHabits]()
    var weeklyJobs = [JobsAndHabits]()
    var selectedArray = [IndexPath]()       // for storing user selected cells
    
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
    
    // get user selected rows -- WORKS!
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print(selectedArray)
        for index in selectedArray {
            if index.section == 0 {
                print(dailyJobs[index.row].name)
            } else {
                print(weeklyJobs[index.row].name)
            }
        }
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
        tableView.deselectRow(at: indexPath, animated: true)            // not sure what this does
        
        if (!selectedArray.contains(indexPath)) {           // only add to array if it doesn't already exist
            selectedArray.append(indexPath)
            print("Item Added",selectedArray)
        } else {
            let index = selectedArray.index(of: indexPath)
            selectedArray.remove(at: index!)
            print("Item Removed",selectedArray)
        }
        tableView.reloadData()      // reloads table so checkmark will show up
    }
    
    
    // ---------
    // Functions
    // ---------
    
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






