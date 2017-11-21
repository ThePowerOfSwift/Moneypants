import UIKit

class PaydayDetailsPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainPopupBG: UIView!
    @IBOutlet weak var topPopupBG: UIView!
    @IBOutlet weak var topPopupWhiteBG: UIView!
    @IBOutlet weak var topPopupImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    
    var categoryLabelText: String!
    var currentUserName: String!
    var jobsHabitsIsoArray: [JobsAndHabits]!
    var code: String!
    var isoArraySubtotals: [(jobName: String, jobSubtotal: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.tableFooterView = UIView()
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        
        // all I need is the category and I can calculate everything else I need
        // I don't even need current user b/c it's global and I can just call currentUser
        categoryLabel.text = categoryLabelText
        
        switch categoryLabelText {
        case "daily jobs":
            topPopupImageView.image = UIImage(named: "broom black")
            // 1. get array of current user's assigned jobs (there may be more than one)
            jobsHabitsIsoArray = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            code = "C"
            
        case "daily habits":
            topPopupImageView.image = UIImage(named: "music white")
            topPopupImageView.tintColor = UIColor.black
            jobsHabitsIsoArray = JobsAndHabits.finalDailyHabitsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            code = "C"
            
        case "weekly jobs":
            topPopupImageView.image = UIImage(named: "lawnmower black")
            jobsHabitsIsoArray = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            code = "C"
            
        case "other jobs":
            topPopupImageView.image = UIImage(named: "broom plus white")
            topPopupImageView.tintColor = UIColor.black
            jobsHabitsIsoArray = JobsAndHabits.finalDailyJobsArray.sorted(by: { $0.order < $1.order }) + JobsAndHabits.finalWeeklyJobsArray.sorted(by: { $0.order < $1.order })
            code = "S"
            
        case "fees":
            topPopupImageView.image = UIImage(named: "dollar minus black")
            
            
        case "withdrawals":
            topPopupImageView.image = UIImage(named: "shopping cart black")
            
        case "unpaid":
            topPopupImageView.image = UIImage(named: "dollar black")
            
        default:
            topPopupImageView.image = UIImage(named: "broom black")
        }
        
        
        // 2. then iterate over that array and get subtotal for each job
        // this is pretty complex, but here goes: first, isolate the job in the points array by soloing the current user, code "C", the current category, the name of the job (from the jobs array), and the items since last payday...
        // ...then, use the reduce function to sum it all up and then append that value to an array for use in a minute
        
        for job in jobsHabitsIsoArray {
            let pointsIsoArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == code && $0.itemCategory == categoryLabelText && $0.itemName == job.name && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().last }).reduce(0, { $0 + $1.valuePerTap })
            let magicFunTimeItem = (job.name, pointsIsoArray)
            isoArraySubtotals.append(magicFunTimeItem)
        }

        // to calculate fees, withdrawals, and unpaid items, create another 'for...in' loop iterating over the Points array. Append that to the isoArraySubtotals.
        
        subtotalLabel.text = "$\(String(format: "%.2f", Double(isoArraySubtotals.reduce(0, { $0 + $1.jobSubtotal })) / 100))"
        
        customizeBackground()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func customizeBackground() {
        mainPopupBG.layer.cornerRadius = 15
        mainPopupBG.layer.masksToBounds = true
        topPopupBG.layer.cornerRadius = 50
        topPopupWhiteBG.layer.cornerRadius = 40
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isoArraySubtotals.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailsCell")
        if indexPath.section == 0 {
            cell?.textLabel?.text = isoArraySubtotals[indexPath.row].jobName
            cell?.detailTextLabel?.text = "\(isoArraySubtotals[indexPath.row].jobSubtotal)"
        } else {
            cell?.textLabel?.text = "bonus"
            cell?.detailTextLabel?.text = "$5.00"
        }
        return cell!
    }
}
