import UIKit

class Step3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var jobsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJobButtonTapped))
        
        // Keep table view up high when nav controller loads
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        jobsTableView.reloadData()
    }

   
    // ----------------
    // Setup Table View
    // ----------------
    
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
    
    // Customize header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }    
    
    // Populate cells with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step3CustomCell
        
        if indexPath.section == 0 {
            let (dailyJobName, _, _, _) = dailyJobs[indexPath.row]
            cell.jobLabel.text = dailyJobName
        } else {
            let (weeklyChoreName, _, _, _) = weeklyJobs[indexPath.row]
            cell.jobLabel.text = weeklyChoreName
        }
        return cell
    }
    
    // When user taps cell, perform segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let (dailyJobName, _, _, _) = dailyJobs[indexPath.row]
            performSegue(withIdentifier: "EditJobSegue", sender: dailyJobName)
        } else {
            let (weeklyJobName, _, _, _) = weeklyJobs[indexPath.row]
            performSegue(withIdentifier: "EditJobSegue", sender: weeklyJobName)
        }
    }
    
    
    // -----------------
    // Navigation Segues
    // -----------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddJobSegue" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "new job"
        } else if segue.identifier == "EditJobSegue" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "edit job"
            nextController.jobTextField = sender as! String
            print(sender!)
        } else {
            print("new view controller, coming up!")
        }
    }
    
    func addJobButtonTapped() {
        performSegue(withIdentifier: "AddJobSegue", sender: self)
    }
}





