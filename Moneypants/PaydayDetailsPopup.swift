import UIKit

class PaydayDetailsPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainPopupBG: UIView!
    @IBOutlet weak var topPopupBG: UIView!
    @IBOutlet weak var topPopupWhiteBG: UIView!
    @IBOutlet weak var topPopupImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var detailsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subtotalLabel: UILabel!
    
    var categoryLabelText: String!      // passed from PaydayDetailVC
    var currentUserName: String!
    var jobsHabitsIsoArray: [JobsAndHabits]!
    var feesUnpaidIsoArray: [Points]!
    var withdrawalIsoArray: [Withdrawal]!
    var isoArraySubtotals: [(itemName: String, itemSubtotal: Int)] = []
    var bonusAmount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.layer.cornerRadius = 5
        detailsTableView.layer.masksToBounds = true
        detailsTableView.tableFooterView = UIView()
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        
        // all I need is the category and I can calculate everything else I need
        // I don't even need current user b/c it's global and I can just call currentUser
        categoryLabel.text = categoryLabelText
        bonusAmount = 0
        
        createIsoArrayForCurrentCategory()
    }
    
    // ----------
    // navigation
    // ----------
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        print(bonusAmount)
    }
    
    // table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isoArraySubtotals.count
        } else {
            // for bonus section
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailsCell") as! PaydayDetailsPopupCell

            cell.itemDescriptionLabel.text = isoArraySubtotals[indexPath.row].itemName
            
            if isoArraySubtotals[indexPath.row].itemSubtotal == 0 {
                cell.itemWeeklySubtotalLabel.text = "-"
                cell.itemWeeklySubtotalLabel.textColor = .lightGray
                cell.itemDescriptionLabel.textColor = .lightGray
            } else if isoArraySubtotals[indexPath.row].itemSubtotal < 0 {
                cell.itemWeeklySubtotalLabel.text = "-$\(String(format: "%.2f", Double(abs(isoArraySubtotals[indexPath.row].itemSubtotal)) / 100))"
                cell.itemWeeklySubtotalLabel.textColor = .black
                cell.itemDescriptionLabel.textColor = .black
            } else {
                cell.itemWeeklySubtotalLabel.text = "$\(String(format: "%.2f", Double(isoArraySubtotals[indexPath.row].itemSubtotal) / 100))"
                cell.itemWeeklySubtotalLabel.textColor = .black
                cell.itemDescriptionLabel.textColor = .black
            }
            return cell
        } else {
            let cell = detailsTableView.dequeueReusableCell(withIdentifier: "bonusCell") as! PaydayDetailsPopupCell
            
            cell.itemDescriptionLabel.text = "bonus"
            cell.itemWeeklySubtotalLabel.text = "$\(String(format: "%.2f", Double(bonusAmount) / 100))"
            
            if bonusAmount == 0 {
                cell.trophyImageView.tintColor = .lightGray
                cell.itemDescriptionLabel.textColor = .lightGray
                cell.itemWeeklySubtotalLabel.textColor = .lightGray
            } else {
                cell.trophyImageView.tintColor = .black
                cell.itemDescriptionLabel.textColor = .black
                cell.itemWeeklySubtotalLabel.textColor = .black
            }
            return cell
        }
    }
    
    // only show 'bonus' row for 'daily jobs' and 'daily habits'
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            // only show bonus row if the category is 'daily jobs' or 'daily habits'
            if categoryLabelText == "daily habits" || categoryLabelText == "daily jobs" {
                return 50
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ---------
    // functions
    // ---------
    
    func customizeBackground() {
        mainPopupBG.layer.cornerRadius = 15
        mainPopupBG.layer.masksToBounds = true
        topPopupBG.layer.cornerRadius = 50
        topPopupWhiteBG.layer.cornerRadius = 40
    }
    
    func createIsoArrayForCurrentCategory() {
        switch categoryLabelText {
            
        case "daily jobs":
            topPopupImageView.image = UIImage(named: "broom black")
            
            // need all daily jobs: C, X, and E (not just C)
            // 1. get array of current user's assigned jobs (there may be more than one)
            // 2. then iterate over that array and get subtotal for each job
            let isoArray = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            for job in isoArray {
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    ($0.code == "C" || $0.code == "X" || $0.code == "E") &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == job.name && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
                let isoItem = (job.name, pointsSubtotal)
                isoArraySubtotals.append(isoItem)
            }
            
            // get job bonus subtotal if it exists
            bonusAmount = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily jobs" && $0.code == "B" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
            
        case "daily habits":
            // 1. get array of current user's assigned habits (there will be ten)
            // 2. then iterate over that array and get subtotal for each habit
            topPopupImageView.image = UIImage(named: "music white")
            topPopupImageView.tintColor = UIColor.black
            let isoArray = JobsAndHabits.finalDailyHabitsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            for habit in isoArray {
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "C" &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == habit.name && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
                let isoItem = (habit.name, pointsSubtotal)
                isoArraySubtotals.append(isoItem)
            }
            
            // get habit bonus subtotal if it exists
            bonusAmount = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == "daily habits" && $0.code == "B" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
            
        case "weekly jobs":
            topPopupImageView.image = UIImage(named: "lawnmower black")
            let isoArray = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            for job in isoArray {
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "C" &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == job.name && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
                let isoItem = (job.name, pointsSubtotal)
                isoArraySubtotals.append(isoItem)
            }
            
        case "other jobs":
            topPopupImageView.image = UIImage(named: "broom plus white")
            topPopupImageView.tintColor = UIColor.black
            // get array of current user's substitution jobs
            let otherJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "S" && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous })
            for job in otherJobsFiltered {
                print(job.itemName)
                let isoItem = (job.itemName, job.valuePerTap)
                isoArraySubtotals.append(isoItem)
            }
            
        case "fees":
            topPopupImageView.image = UIImage(named: "dollar minus black")
            // get array of user's fees for the week
            // fees are different than other items because user can get more than one per day...
            // so, how to calculate fees and display them?
            // iterate over fees array ("fighting", "language", "disobedience", etc.) and see if user has any fees in that category?
            // if so, sum up all those fees and then append them to the array?
            // to calculate fees, withdrawals, and unpaid items, create another 'for...in' loop iterating over the Points array. Append that to the isoArraySubtotals.
            
            for fee in FamilyData.fees {
                // get subtotal for each fee, then append that to array
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "F" && $0.itemName == fee && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
                // only append to array if user actually has a fee in that category. Otherwise, leave it out.
                if pointsSubtotal != 0 {
                    let isoItem = (fee, pointsSubtotal)
                    isoArraySubtotals.append(isoItem)
                }
            }
            
        case "withdrawals":
            topPopupImageView.image = UIImage(named: "shopping cart black")
            
        case "unpaid":
            topPopupImageView.image = UIImage(named: "dollar black")
            let unpaidAmountsFiltered = Points.pointsArray.filter({ $0.user == currentUserName && $0.code != "P" && Date(timeIntervalSince1970: $0.itemDate) <= FamilyData.calculatePayday().previous })
            print(unpaidAmountsFiltered)
            
        default:
            topPopupImageView.image = UIImage(named: "broom black")
        }
        
        
        // format bottom subtotal (depending on if it's negative or not)
        let subtotalAmount = Double(abs(isoArraySubtotals.reduce(0, { $0 + $1.itemSubtotal })) + bonusAmount)
        if isoArraySubtotals.reduce(0, { $0 + $1.itemSubtotal }) < 0 {
            subtotalLabel.text = "-$\(String(format: "%.2f", subtotalAmount / 100))"
        } else {
            subtotalLabel.text = "$\(String(format: "%.2f", subtotalAmount / 100))"
        }
        
        customizeBackground()
        detailsTableView.reloadData()
        detailsTableViewHeight.constant = detailsTableView.contentSize.height
        view.layoutIfNeeded()
    }
    
    // unused function
    func iterateOverIsoArrayForSubtotals(inputArray: [JobsAndHabits]) {
        // this is pretty complex, but here goes: first, isolate the job in the points array that matches the current user, the current category, the name of the job (from the jobs array), and the items since previous payday...
        // ...then, use the reduce function to sum it all up and then append that value to an array for use in a minute
        let isoArray = inputArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
        for job in isoArray {
            let pointsIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                //                $0.code == code &&
                $0.itemCategory == categoryLabelText &&
                $0.itemName == job.name && Date(timeIntervalSince1970: $0.itemDate) >= FamilyData.calculatePayday().previous }).reduce(0, { $0 + $1.valuePerTap })
            let isoItem = (job.name, pointsIsoArray)
            isoArraySubtotals.append(isoItem)
        }
    }
}



