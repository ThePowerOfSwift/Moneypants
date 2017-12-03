import UIKit

class PaydayDetailsPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainPopupBG: UIView!
    @IBOutlet weak var topPopupBG: UIView!
    @IBOutlet weak var topPopupWhiteBG: UIView!
    @IBOutlet weak var topPopupImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mainPopupBGWidth: NSLayoutConstraint!
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var detailsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subtotalLabel: UILabel!
    
    var categoryLabelText: String!      // passed from PaydayDetailVC
    var currentUserName: String!
    var jobsHabitsIsoArray: [JobsAndHabits]!
    var feesUnpaidIsoArray: [Points]!
    var withdrawalIsoArray: [Withdrawal]!
    var isoArraySubtotals: [(itemName: String, itemCategory: String, itemSubtotal: Int)] = []
    var bonusAmount: Int!
    
    // two arrays created from isoArraySubtotals
    var showHideDailyView: [(index: Int, itemName: String, selected: Bool)] = []
    
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
        changePopupWidthDependingOnScreenSize()
    }
    
    func changePopupWidthDependingOnScreenSize() {
        if UIScreen.main.bounds.width > 700 {
            mainPopupBGWidth.constant = 560
        }
    }
    
    // ----------
    // navigation
    // ----------
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
            
            cell.dailyView.layer.cornerRadius = cell.dailyView.bounds.height / 6.4
            cell.dailyView.layer.masksToBounds = true
            cell.dailyView.layer.borderColor = UIColor.lightGray.cgColor
            cell.dailyView.layer.borderWidth = 0.5
            cell.dailyView.backgroundColor = UIColor.white
            
            // format day label text to be single letter of weekday (S, M, T, W, T, F, S)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEEEE"
            
            let dayLabels: [UILabel] = [cell.day1SLabel, cell.day2MLabel, cell.day3TLabel, cell.day4WLabel, cell.day5ThLabel, cell.day6FLabel, cell.day7SLabel]
            for n in 0...6 {
                let payPeriodDay = Calendar.current.date(byAdding: .day, value: n, to: FamilyData.calculatePayday().previous)
                
                // show day label text according to day of week (starting on the family's payday)
                dayLabels[n].text = formatter.string(from: payPeriodDay!)
                
                // show day label color according to the job code for that day (C, E, X, S, F, N)
                let dayIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory &&
                    $0.itemName == isoArraySubtotals[indexPath.row].itemName &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDay!) })
                
                if dayIsoArray.first?.code == "C" || dayIsoArray.first?.code == "S" {
                    dayLabels[n].backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
                } else if dayIsoArray.first?.code == "X" || dayIsoArray.first?.code == "F" {
                    dayLabels[n].backgroundColor = UIColor.red
                } else if dayIsoArray.first?.code == "E" || dayIsoArray.first?.code == "N" {
                    dayLabels[n].backgroundColor = UIColor.lightGray
                } else {
                    dayLabels[n].backgroundColor = UIColor.clear
                }
            }
            
            // need to make an array of rows for selection
            if showHideDailyView[indexPath.row].selected == true {
                cell.dailyView.isHidden = false
            } else {
                cell.dailyView.isHidden = true
            }
            
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
        if showHideDailyView[indexPath.row].selected == true {
            showHideDailyView[indexPath.row].selected = false
        } else {
            showHideDailyView[indexPath.row].selected = true
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
        let previousPayday = FamilyData.calculatePayday().previous.timeIntervalSince1970
        let currentPayday = FamilyData.calculatePayday().current.timeIntervalSince1970
        
        switch categoryLabelText {
            
        case "daily jobs":
            topPopupImageView.image = UIImage(named: "broom")
            topPopupImageView.tintColor = UIColor.black
            // need all daily jobs: C, X, and E (not just C)
            // 1. get array of current user's assigned jobs (there may be more than one)
            // 2. then iterate over that array and get subtotal for each job
            let isoArray = JobsAndHabits.finalDailyJobsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            for job in isoArray {
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    ($0.code == "C" || $0.code == "X" || $0.code == "E") &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == job.name && $0.itemDate >= previousPayday &&
                    $0.itemDate < currentPayday }).reduce(0, { $0 + $1.valuePerTap })
                
                let isoItem = (job.name, categoryLabelText!, pointsSubtotal)
                isoArraySubtotals.append(isoItem)
            }
            
            // get job bonus subtotal if it exists
            bonusAmount = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "daily jobs" &&
                $0.code == "B" && $0.itemDate >= previousPayday &&
                $0.itemDate < currentPayday }).reduce(0, { $0 + $1.valuePerTap })
            
        case "daily habits":
            // 1. get array of current user's assigned habits (there will be ten)
            // 2. then iterate over that array and get subtotal for each habit
            topPopupImageView.image = UIImage(named: "workout")
            topPopupImageView.tintColor = UIColor.black
            let isoArray = JobsAndHabits.finalDailyHabitsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            for habit in isoArray {
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "C" &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == habit.name && $0.itemDate >= previousPayday &&
                    $0.itemDate < currentPayday }).reduce(0, { $0 + $1.valuePerTap })
                
                let isoItem = (habit.name, categoryLabelText!, pointsSubtotal)
                isoArraySubtotals.append(isoItem)
            }
            
            // get habit bonus subtotal if it exists
            bonusAmount = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.code == "B" &&
                $0.itemDate >= previousPayday &&
                $0.itemDate < currentPayday }).reduce(0, { $0 + $1.valuePerTap })
            
        case "weekly jobs":
            topPopupImageView.image = UIImage(named: "lawnmower black")
            let isoArray = JobsAndHabits.finalWeeklyJobsArray.filter({ $0.assigned == currentUserName }).sorted(by: { $0.order < $1.order })
            for job in isoArray {
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "C" &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == job.name && $0.itemDate >= previousPayday &&
                    $0.itemDate < currentPayday }).reduce(0, { $0 + $1.valuePerTap })
                
                let isoItem = (job.name, categoryLabelText!, pointsSubtotal)
                isoArraySubtotals.append(isoItem)
            }
            
        case "other jobs":
            topPopupImageView.image = UIImage(named: "broom plus white")
            topPopupImageView.tintColor = UIColor.black
            
            let isoArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.code == "S" && $0.itemDate >= previousPayday && $0.itemDate < currentPayday })
            for otherJob in isoArray {
                let pointsSubtotal = isoArray.filter({ $0.itemName == otherJob.itemName }).reduce(0, { $0 + $1.valuePerTap })
                let isoItem = (otherJob.itemName, categoryLabelText!, pointsSubtotal)
                
                // only append item if array doesn't already have a substitution job with that name
                if !isoArraySubtotals.contains(where: { $0.itemName == otherJob.itemName }) {
                    isoArraySubtotals.append(isoItem)
                }
            }
            
            // OLD CODE (WORKS! but shows each job in its own line rather than combining all similar jobs together)
            // get array of current user's substitution jobs
//            let otherJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
//                $0.code == "S" &&
//                $0.itemDate >= previousPayday &&
//                $0.itemDate < currentPayday })
//            
//            for job in otherJobsFiltered {
//                let isoItem = (job.itemName, categoryLabelText!, job.valuePerTap)
//                isoArraySubtotals.append(isoItem)
//                print(isoItem)
//            }
            // END OLD CODE (WORKS)
            
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
                let pointsSubtotal = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.code == "F" &&
                    $0.itemName == fee &&
                    $0.itemDate >= previousPayday &&
                    $0.itemDate < currentPayday }).reduce(0, { $0 + $1.valuePerTap })
                
                // only append to array if user actually has a fee in that category. Otherwise, leave it out.
                if pointsSubtotal != 0 {
                    let isoItem = (fee, categoryLabelText!, pointsSubtotal)
                    isoArraySubtotals.append(isoItem)
                }
            }
            
        case "withdrawals":
            topPopupImageView.image = UIImage(named: "shopping cart black")
            
        case "unpaid":
            topPopupImageView.image = UIImage(named: "dollar black")
            let unpaidAmountsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.code != "P" &&
                $0.itemDate <= previousPayday })
            
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
        
        // create array from isoArray for showing daily details
        var count = 0
        for item in isoArraySubtotals {
            let newItem = (count, item.itemName, false)
            showHideDailyView.append(newItem)
            count += 1
        }

        customizeBackground()
        detailsTableView.reloadData()
        detailsTableViewHeight.constant = detailsTableView.contentSize.height
        view.layoutIfNeeded()
    }
}



