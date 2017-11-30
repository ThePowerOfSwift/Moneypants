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
    var isoArraySubtotals: [(itemName: String, itemCategory: String, itemSubtotal: Int)] = []
    var bonusAmount: Int!
    
    // two arrays created from isoArraySubtotals
    var showHideDailyView: [(index: Int, itemName: String, selected: Bool)] = []
    var dailyCodeArray: [(day: Int, code: String)] = []
    
    
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
        
        
        print("G: ",dailyCodeArray)
        print("H: ",dailyCodeArray[5])
        print("I: ",dailyCodeArray[5].code)
        
        print(Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[0].itemCategory && $0.itemName == isoArraySubtotals[0].itemName }))// && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: FamilyData.calculatePayday().previous) }))
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
            
            
            
            
            let dayLabels: [UILabel] = [cell.day1SLabel, cell.day2MLabel, cell.day3TLabel, cell.day4WLabel, cell.day5ThLabel, cell.day6FLabel, cell.day7SLabel]
            
            for n in 0...6 {
                let payPeriodDay = Calendar.current.date(byAdding: .day, value: n, to: FamilyData.calculatePayday().previous)
                let dayIsoArray = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDay!) })
                
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
            
            
//            let dayOneItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: FamilyData.calculatePayday().previous) })
//            if dayOneItem.first?.code == "C" || dayOneItem.first?.code == "S" {
//                cell.day1SLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if dayOneItem.first?.code == "X" || dayOneItem.first?.code == "F" {
//                cell.day1SLabel.backgroundColor = UIColor.red
//            } else if dayOneItem.first?.code == "E" || dayOneItem.first?.code == "N" {
//                cell.day1SLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day1SLabel.backgroundColor = UIColor.clear
//            }
//            
//            
//            let payPeriodDayTwo = Calendar.current.date(byAdding: .day, value: 1, to: FamilyData.calculatePayday().previous)
//            let dayTwoItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDayTwo!) })
//            if dayTwoItem.first?.code == "C" || dayTwoItem.first?.code == "S" {
//                cell.day2MLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if dayTwoItem.first?.code == "X" || dayTwoItem.first?.code == "F" {
//                cell.day2MLabel.backgroundColor = UIColor.red
//            } else if dayTwoItem.first?.code == "E" || dayTwoItem.first?.code == "N" {
//                cell.day2MLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day2MLabel.backgroundColor = UIColor.clear
//            }
//            
//            
//            let payPeriodDayThree = Calendar.current.date(byAdding: .day, value: 2, to: FamilyData.calculatePayday().previous)
//            let dayThreeItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDayThree!) })
//            if dayThreeItem.first?.code == "C" || dayThreeItem.first?.code == "S" {
//                cell.day3TLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if dayThreeItem.first?.code == "X" || dayThreeItem.first?.code == "F" {
//                cell.day3TLabel.backgroundColor = UIColor.red
//            } else if dayThreeItem.first?.code == "E" || dayThreeItem.first?.code == "N" {
//                cell.day3TLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day3TLabel.backgroundColor = UIColor.clear
//            }
//
//            
//            let payPeriodDayFour = Calendar.current.date(byAdding: .day, value: 3, to: FamilyData.calculatePayday().previous)
//            let dayFourItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDayFour!) })
//            if dayFourItem.first?.code == "C" || dayFourItem.first?.code == "S" {
//                cell.day4WLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if dayFourItem.first?.code == "X" || dayFourItem.first?.code == "F" {
//                cell.day4WLabel.backgroundColor = UIColor.red
//            } else if dayFourItem.first?.code == "E" || dayFourItem.first?.code == "N" {
//                cell.day4WLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day4WLabel.backgroundColor = UIColor.clear
//            }
//
//            
//            let payPeriodDayFive = Calendar.current.date(byAdding: .day, value: 4, to: FamilyData.calculatePayday().previous)
//            let dayFiveItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDayFive!) })
//            if dayFiveItem.first?.code == "C" || dayFiveItem.first?.code == "S" {
//                cell.day5ThLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if dayFiveItem.first?.code == "X" || dayFiveItem.first?.code == "F" {
//                cell.day5ThLabel.backgroundColor = UIColor.red
//            } else if dayFiveItem.first?.code == "E" || dayFiveItem.first?.code == "N" {
//                cell.day5ThLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day5ThLabel.backgroundColor = UIColor.clear
//            }
//            
//            
//            let payPeriodDaySix = Calendar.current.date(byAdding: .day, value: 5, to: FamilyData.calculatePayday().previous)
//            let daySixItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDaySix!) })
//            if daySixItem.first?.code == "C" || daySixItem.first?.code == "S" {
//                cell.day6FLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if daySixItem.first?.code == "X" || daySixItem.first?.code == "F" {
//                cell.day6FLabel.backgroundColor = UIColor.red
//            } else if daySixItem.first?.code == "E" || daySixItem.first?.code == "N" {
//                cell.day6FLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day6FLabel.backgroundColor = UIColor.clear
//            }
//            
//            
//            let payPeriodDaySeven = Calendar.current.date(byAdding: .day, value: 6, to: FamilyData.calculatePayday().previous)
//            let daySevenItem = Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == isoArraySubtotals[indexPath.row].itemCategory && $0.itemName == isoArraySubtotals[indexPath.row].itemName && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: payPeriodDaySeven!) })
//            if daySevenItem.first?.code == "C" || daySevenItem.first?.code == "S" {
//                cell.day7SLabel.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
//            } else if daySevenItem.first?.code == "X" || daySevenItem.first?.code == "F" {
//                cell.day7SLabel.backgroundColor = UIColor.red
//            } else if daySevenItem.first?.code == "E" || daySevenItem.first?.code == "N" {
//                cell.day7SLabel.backgroundColor = UIColor.lightGray
//            } else {
//                cell.day7SLabel.backgroundColor = UIColor.clear
//            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
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
            topPopupImageView.image = UIImage(named: "broom black")
            
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
            // get array of current user's substitution jobs
            let otherJobsFiltered = Points.pointsArray.filter({ $0.user == currentUserName &&
                $0.code == "S" &&
                $0.itemDate >= previousPayday &&
                $0.itemDate < currentPayday })
            
            for job in otherJobsFiltered {
                print(job.itemName)
                let isoItem = (job.itemName, categoryLabelText!, job.valuePerTap)
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
        
        // create array for current category for each job's day code
        for n in 0...6 {
            let singleDay = Calendar.current.date(byAdding: .day, value: n, to: FamilyData.calculatePayday().previous)
            
            // ... get the list of each job and the code
            for isoItem in isoArraySubtotals {
                let theMagic = Points.pointsArray.filter({ $0.user == currentUserName &&
                    $0.itemCategory == categoryLabelText &&
                    $0.itemName == isoItem.itemName &&
                    Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: singleDay!) })
                
                let happiness = (n,theMagic.first?.code ?? "")
                dailyCodeArray.append(happiness)
                
                print(n,isoItem.itemName,theMagic.first?.code ?? "no code")
            }
        }
        
        
        
        
        
        
        
        
        
        // for each day of the previous pay period...
//        let dayArray = []
//        for n in 0...6 {
//            let singleDay = Calendar.current.date(byAdding: .day, value: n, to: FamilyData.calculatePayday().previous)
//            var tempArray: [(Date, String, String)] = []
//            
//            // ... get the list of each job and the code
//            for item in Points.pointsArray.filter({ $0.user == currentUserName &&
//                $0.itemCategory == categoryLabelText &&
//                Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: singleDay!) }) {
//                    let tempItem = (singleDay!,item.itemName,item.code)
//                    tempArray.append(tempItem)
//                    print("B: ",singleDay!,item.itemName,item.code)
//            }
//            let dayItem = (n)
//        }
        
        
        
        
        
//        for n in 0...6 {
//            let singleDay = Calendar.current.date(byAdding: .day, value: n, to: FamilyData.calculatePayday().previous)
//            
//            // ... get the list of each job and the code
//            for isoItem in Points.pointsArray.filter({ $0.user == currentUserName && $0.itemCategory == categoryLabelText && Calendar.current.isDate(Date(timeIntervalSince1970: $0.itemDate), inSameDayAs: singleDay!) }) {
//                    print("E: ",n,isoItem.itemName,isoItem.code)
//            }
//            
////            print("D: ",itemIsoArray.first?.code ?? "blank")
//        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

        
        
        
        
        
        
        customizeBackground()
        detailsTableView.reloadData()
        detailsTableViewHeight.constant = detailsTableView.contentSize.height
        view.layoutIfNeeded()
    }
}



