import UIKit

class MoneyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView1Top: NSLayoutConstraint!
    @IBOutlet weak var tableView1Height: NSLayoutConstraint!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView2Top: NSLayoutConstraint!
    @IBOutlet weak var tableView2Height: NSLayoutConstraint!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var tableView3Top: NSLayoutConstraint!
    @IBOutlet weak var tableView3Height: NSLayoutConstraint!
    @IBOutlet weak var tableView4: UITableView!
    @IBOutlet weak var tableView4Top: NSLayoutConstraint!
    @IBOutlet weak var tableView4Height: NSLayoutConstraint!
    
    @IBOutlet weak var clothingButton: UIButton!
    @IBOutlet weak var personalCareButton: UIButton!
    @IBOutlet weak var sportsDanceButton: UIButton!
    @IBOutlet weak var musicArtButton: UIButton!
    @IBOutlet weak var schoolButton: UIButton!
    @IBOutlet weak var electronicsButton: UIButton!
    @IBOutlet weak var summerCampsButton: UIButton!
    @IBOutlet weak var transportationButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var funMoneyButton: UIButton!
    @IBOutlet weak var savingsButton: UIButton!
    @IBOutlet weak var donationsButton: UIButton!
    
    // For Modal Presentation (from 'withdrawal' or 'spending' VC's)
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var navBarTop: NSLayoutConstraint!
    var navTop: Int = -44
    var withdrawalAmount: Int?
    // end modal presentation from 'withdrawal'
    
    var currentUserName: String!
    
    var tableViewRowCount: Int?
    var tableViewBudgetItemNames: [Budget]?
    var tableViewBudgetItemNumbers: [Budget]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        // for modal presentation only (so we can hide it when not modally presented)
        navBarTop.constant = CGFloat(navTop)
        navBar.title = currentUserName
        print(withdrawalAmount ?? "no withdrawal amount")
        
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView3.delegate = self
        tableView3.dataSource = self
        tableView4.delegate = self
        tableView4.dataSource = self
        
        // Default view: table is hidden, buttons aren't selected
        tableView1.isHidden = true
        tableView1Top.constant = -(tableView1.bounds.height)
        tableView2.isHidden = true
        tableView2Top.constant = -(tableView2.bounds.height)
        tableView3.isHidden = true
        tableView3Top.constant = -(tableView3.bounds.height)
        tableView4.isHidden = true
        tableView4Top.constant = -(tableView4.bounds.height)

        clothingButton.isSelected = false
        personalCareButton.isSelected = false
        sportsDanceButton.isSelected = false
        musicArtButton.isSelected = false
        schoolButton.isSelected = false
        electronicsButton.isSelected = false
        summerCampsButton.isSelected = false
        transportationButton.isSelected = false
        otherButton.isSelected = false
        funMoneyButton.isSelected = false
        savingsButton.isSelected = false
        donationsButton.isSelected = false
    }
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowCount ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.tableView1) {
            let cell = tableView1.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell1
            cell.dollarLabel.text = "\(tableViewBudgetItemNumbers?[indexPath.row].amount)"
            cell.envelopeLabel.text = tableViewBudgetItemNames?[indexPath.row].expenseName
            return cell
        } else if (tableView == self.tableView2) {
            let cell = tableView2.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell2
            cell.dollarLabel.text = "\(tableViewBudgetItemNumbers?[indexPath.row].amount)"
            cell.envelopeLabel.text = tableViewBudgetItemNames?[indexPath.row].expenseName
            return cell
        } else if (tableView == tableView3) {
            let cell = tableView3.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell3
            cell.dollarLabel.text = "\(tableViewBudgetItemNumbers?[indexPath.row].amount)"
            cell.envelopeLabel.text = tableViewBudgetItemNames?[indexPath.row].expenseName
            return cell
        } else {
            let cell = tableView4.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell4
            cell.dollarLabel.text = "\(tableViewBudgetItemNumbers?[indexPath.row].amount)"
            cell.envelopeLabel.text = tableViewBudgetItemNames?[indexPath.row].expenseName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // iterate over the piggy banks and find which one is pink. That'll be the category, and then I can find the item from the row
        print(Budget.budgetsArray)
        
        
        
        print(indexPath)
    }
    
    // -------------------
    // Button Taps - ROW 1
    // -------------------
    
    @IBAction func clothingButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let clothingArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "clothing" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = clothingArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = clothingArray
        tableViewBudgetItemNames = clothingArray
        
        personalCareButton.isSelected = false
        sportsDanceButton.isSelected = false
        
        if tableView1.isHidden && !clothingButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            clothingButton.isSelected = true                    // select button, hide current table, update to new table, and then show table
            collapseAllRows()
            tableView1.isHidden = false
            tableView1Top.constant = 0
            tableView1.reloadData()
            tableView1Height.constant = tableView1.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView1.isHidden && !clothingButton.isSelected {  // if table is shown and button isn't selected
            clothingButton.isSelected = true                            // select button and update table
            tableView1Top.constant = 0
            tableView1.reloadData()
            tableView1Height.constant = tableView1.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView1Top.constant = -(tableView1.bounds.height)        // hide button AND hide table
            clothingButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView1.isHidden = true
            }
        }
    }
    
    @IBAction func personalCareButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let personalCareArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "personal care" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = personalCareArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = personalCareArray
        tableViewBudgetItemNames = personalCareArray
        
        clothingButton.isSelected = false
        sportsDanceButton.isSelected = false
        
        if tableView1.isHidden && !personalCareButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            personalCareButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView1.isHidden = false
            tableView1Top.constant = 0
            tableView1.reloadData()
            tableView1Height.constant = tableView1.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView1.isHidden && !personalCareButton.isSelected {  // if table is shown and button isn't selected
            personalCareButton.isSelected = true                            // select button
            tableView1Top.constant = 0
            tableView1.reloadData()
            tableView1Height.constant = tableView1.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView1Top.constant = -(tableView1.bounds.height)        // hide button AND hide table
            personalCareButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView1.isHidden = true
            }
        }
    }
    
    @IBAction func sportsDanceButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let sportsDanceArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "sports & dance" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = sportsDanceArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = sportsDanceArray
        tableViewBudgetItemNames = sportsDanceArray
        
        clothingButton.isSelected = false
        personalCareButton.isSelected = false
        
        if tableView1.isHidden && !sportsDanceButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            sportsDanceButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView1.isHidden = false
            tableView1Top.constant = 0
            tableView1.reloadData()
            tableView1Height.constant = tableView1.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView1.isHidden && !sportsDanceButton.isSelected {  // if table is shown and button isn't selected
            sportsDanceButton.isSelected = true                            // select button
            tableView1Top.constant = 0
            tableView1.reloadData()
            tableView1Height.constant = tableView1.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView1Top.constant = -(tableView1.bounds.height)        // hide button AND hide table
            sportsDanceButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView1.isHidden = true
            }
        }
    }
    
    // -------------------
    // Button Taps - ROW 2
    // -------------------
    
    @IBAction func musicArtButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let musicArtArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "music & art" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = musicArtArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = musicArtArray
        tableViewBudgetItemNames = musicArtArray
        
        schoolButton.isSelected = false
        electronicsButton.isSelected = false
        
        if tableView2.isHidden && !musicArtButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            musicArtButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView2.isHidden = false
            tableView2Top.constant = 0
            tableView2.reloadData()
            tableView2Height.constant = tableView2.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView2.isHidden && !musicArtButton.isSelected {  // if table is shown and button isn't selected
            musicArtButton.isSelected = true                            // select button
            tableView2Top.constant = 0
            tableView2.reloadData()
            tableView2Height.constant = tableView2.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView2Top.constant = -(tableView2.bounds.height)        // hide button AND hide table
            musicArtButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView2.isHidden = true
            }
        }
    }

    @IBAction func schoolButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let schoolArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "school" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = schoolArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = schoolArray
        tableViewBudgetItemNames = schoolArray
        
        musicArtButton.isSelected = false
        electronicsButton.isSelected = false
        
        if tableView2.isHidden && !schoolButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            schoolButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView2.isHidden = false
            tableView2Top.constant = 0
            tableView2.reloadData()
            tableView2Height.constant = tableView2.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView2.isHidden && !schoolButton.isSelected {  // if table is shown and button isn't selected
            schoolButton.isSelected = true                            // select button
            tableView2Top.constant = 0
            tableView2.reloadData()
            tableView2Height.constant = tableView2.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView2Top.constant = -(tableView2.bounds.height)        // hide button AND hide table
            schoolButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView2.isHidden = true
            }
        }
    }
    
    @IBAction func electronicsButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let electronicsArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "electronics" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = electronicsArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = electronicsArray
        tableViewBudgetItemNames = electronicsArray
        
        musicArtButton.isSelected = false
        schoolButton.isSelected = false
        
        if tableView2.isHidden && !electronicsButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            electronicsButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView2.isHidden = false
            tableView2Top.constant = 0
            tableView2.reloadData()
            tableView2Height.constant = tableView2.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView2.isHidden && !electronicsButton.isSelected {  // if table is shown and button isn't selected
            electronicsButton.isSelected = true                            // select button
            tableView2Top.constant = 0
            tableView2.reloadData()
            tableView2Height.constant = tableView2.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView2Top.constant = -(tableView2.bounds.height)        // hide button AND hide table
            electronicsButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView2.isHidden = true
            }
        }
    }
    
    // -------------------
    // Button Taps - ROW 3
    // -------------------
    
    @IBAction func summerCampButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let summerCampsArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "summer camps" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = summerCampsArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = summerCampsArray
        tableViewBudgetItemNames = summerCampsArray
        
        transportationButton.isSelected = false
        otherButton.isSelected = false
        
        if tableView3.isHidden && !summerCampsButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            summerCampsButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView3.isHidden = false
            tableView3Top.constant = 0
            tableView3.reloadData()
            tableView3Height.constant = tableView3.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView3.isHidden && !summerCampsButton.isSelected {  // if table is shown and button isn't selected
            summerCampsButton.isSelected = true                            // select button
            tableView3Top.constant = 0
            tableView3.reloadData()
            tableView3Height.constant = tableView3.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView3Top.constant = -(tableView3.bounds.height)        // hide button AND hide table
            summerCampsButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView3.isHidden = true
            }
        }
    }
    
    @IBAction func transportationButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let transportationArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "transportation" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = transportationArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = transportationArray
        tableViewBudgetItemNames = transportationArray
        
        summerCampsButton.isSelected = false
        otherButton.isSelected = false
        
        if tableView3.isHidden && !transportationButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            transportationButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView3.isHidden = false
            tableView3Top.constant = 0
            tableView3.reloadData()
            tableView3Height.constant = tableView3.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView3.isHidden && !transportationButton.isSelected {  // if table is shown and button isn't selected
            transportationButton.isSelected = true                            // select button
            tableView3Top.constant = 0
            tableView3.reloadData()
            tableView3Height.constant = tableView3.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView3Top.constant = -(tableView3.bounds.height)        // hide button AND hide table
            transportationButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView3.isHidden = true
            }
        }
    }
    
    @IBAction func otherButtonTapper(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let otherArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "other" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = otherArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = otherArray
        tableViewBudgetItemNames = otherArray
        
        summerCampsButton.isSelected = false
        transportationButton.isSelected = false
        
        if tableView3.isHidden && !otherButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            otherButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView3.isHidden = false
            tableView3Top.constant = 0
            tableView3.reloadData()
            tableView3Height.constant = tableView3.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView3.isHidden && !otherButton.isSelected {  // if table is shown and button isn't selected
            otherButton.isSelected = true                            // select button
            tableView3.isHidden = false
            tableView3Top.constant = 0
            tableView3.reloadData()
            tableView3Height.constant = tableView3.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView3Top.constant = -(tableView3.bounds.height)        // hide button AND hide table
            otherButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView3.isHidden = true
            }
        }
    }
    
    // -------------------
    // Button Taps - ROW 4
    // -------------------
    
    @IBAction func funMoneyButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let funMoneyArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "fun money" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = funMoneyArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = funMoneyArray
        tableViewBudgetItemNames = funMoneyArray
        
        savingsButton.isSelected = false
        donationsButton.isSelected = false
        
        if tableView4.isHidden && !funMoneyButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            funMoneyButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView4.isHidden = false
            tableView4Top.constant = 0
            tableView4.reloadData()
            tableView4Height.constant = tableView4.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView4.isHidden && !funMoneyButton.isSelected {  // if table is shown and button isn't selected
            funMoneyButton.isSelected = true                            // select button
            tableView4Top.constant = 0
            tableView4.reloadData()
            tableView4Height.constant = tableView4.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView4Top.constant = -(tableView4.bounds.height)        // hide button AND hide table
            funMoneyButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView4.isHidden = true
            }
        }
    }
    
    @IBAction func savingsButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let savingsArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "savings" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = savingsArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = savingsArray
        tableViewBudgetItemNames = savingsArray
        
        funMoneyButton.isSelected = false
        donationsButton.isSelected = false
        
        if tableView4.isHidden && !savingsButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            savingsButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView4.isHidden = false
            tableView4Top.constant = 0
            tableView4.reloadData()
            tableView4Height.constant = tableView4.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView4.isHidden && !savingsButton.isSelected {  // if table is shown and button isn't selected
            savingsButton.isSelected = true                            // select button
            tableView4.isHidden = false
            tableView4Top.constant = 0
            tableView4.reloadData()
            tableView4Height.constant = tableView4.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView4Top.constant = -(tableView4.bounds.height)        // hide button AND hide table
            savingsButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView4.isHidden = true
            }
        }
    }
    
    @IBAction func donationsButtonTapped(_ sender: UIButton) {
        // filter expense array by current user, current category, and for all values more than zero
        let donationsArray = Budget.budgetsArray.filter({ $0.ownerName == MPUser.usersArray[MPUser.currentUser].firstName && $0.category == "donations" && $0.amount != 0 }).sorted(by: { $0.order < $1.order })
        tableViewRowCount = donationsArray.count             // update table data and deselect other buttons in row
        tableViewBudgetItemNumbers = donationsArray
        tableViewBudgetItemNames = donationsArray
        
        funMoneyButton.isSelected = false
        savingsButton.isSelected = false
        
        if tableView4.isHidden && !donationsButton.isSelected {  // if table is hidden and button isn't selected
            deselectAllButtons()
            donationsButton.isSelected = true                    // select button and show table
            collapseAllRows()
            tableView4.isHidden = false
            tableView4Top.constant = 0
            tableView4.reloadData()
            tableView4Height.constant = tableView4.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else if !tableView4.isHidden && !donationsButton.isSelected {  // if table is shown and button isn't selected
            donationsButton.isSelected = true                            // select button
            tableView4Top.constant = 0
            tableView4.reloadData()
            tableView4Height.constant = tableView4.contentSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {                                                        // if table is shown AND button is selected
            tableView4Top.constant = -(tableView4.bounds.height)        // hide button AND hide table
            donationsButton.isSelected = false
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.tableView4.isHidden = true
            }
        }
    }
    
    func deselectAllButtons () {
        clothingButton.isSelected = false
        personalCareButton.isSelected = false
        sportsDanceButton.isSelected = false
        musicArtButton.isSelected = false
        schoolButton.isSelected = false
        electronicsButton.isSelected = false
        summerCampsButton.isSelected = false
        transportationButton.isSelected = false
        otherButton.isSelected = false
        funMoneyButton.isSelected = false
        savingsButton.isSelected = false
        donationsButton.isSelected = false
    }
    
    func collapseAllRows () {
        tableView1.isHidden = true
        tableView1Top.constant = -(tableView1.bounds.height)
        tableView2.isHidden = true
        tableView2Top.constant = -(tableView2.bounds.height)
        tableView3.isHidden = true
        tableView3Top.constant = -(tableView3.bounds.height)
        tableView4.isHidden = true
        tableView4Top.constant = -(tableView4.bounds.height)
    }

    
    // Cancel Button
    
    @IBAction func cancelButtonForModalTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

   
    // -----------
    // Home Button
    // -----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
