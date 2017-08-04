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
    
    var tableViewRowCount: Int?
    var tableViewData: [String]?
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        navigationItem.title = userName
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
            cell.dollarLabel.text = "43"
            cell.envelopeLabel.text = tableViewData?[indexPath.row]
            return cell
        } else if (tableView == self.tableView2) {
            let cell = tableView2.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell2
            cell.dollarLabel.text = "43"
            cell.envelopeLabel.text = tableViewData?[indexPath.row]
            return cell
        } else if (tableView == tableView3) {
            let cell = tableView3.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell3
            cell.dollarLabel.text = "28"
            cell.envelopeLabel.text = tableViewData?[indexPath.row]
            return cell
        } else {
            let cell = tableView4.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! MoneyCell4
            cell.dollarLabel.text = "11"
            cell.envelopeLabel.text = tableViewData?[indexPath.row]
            return cell
        }
    }
    
   
    
    // -------------------
    // Button Taps - ROW 1
    // -------------------
    
    @IBAction func clothingButtonTapped(_ sender: UIButton) {
        tableViewRowCount = clothingEnvelope.count             // update table data and deselect other buttons in row
        tableViewData = clothingEnvelope
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
        tableViewRowCount = personalCareEnvelope.count             // update table data and deselect other buttons
        tableViewData = personalCareEnvelope
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
        tableViewRowCount = sportsDanceEnvelope.count             // update table data and deselect other buttons
        tableViewData = sportsDanceEnvelope
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
        tableViewRowCount = musicArtEnvelope.count             // update table data and deselect other buttons
        tableViewData = musicArtEnvelope
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
        tableViewRowCount = schoolEnvelope.count             // update table data and deselect other buttons
        tableViewData = schoolEnvelope
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
        tableViewRowCount = electronicsEnvelope.count             // update table data and deselect other buttons
        tableViewData = electronicsEnvelope
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
        tableViewRowCount = summerCampsEnvelope.count             // update table data and deselect other buttons
        tableViewData = summerCampsEnvelope
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
        tableViewRowCount = transportationEnvelope.count             // update table data and deselect other buttons
        tableViewData = transportationEnvelope
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
        tableViewRowCount = otherEnvelope.count             // update table data and deselect other buttons
        tableViewData = otherEnvelope
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
        tableViewRowCount = funMoneyEnvelope.count             // update table data and deselect other buttons
        tableViewData = funMoneyEnvelope
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
        tableViewRowCount = savingsEnvelope.count             // update table data and deselect other buttons
        tableViewData = savingsEnvelope
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
        tableViewRowCount = donationsEnvelope.count             // update table data and deselect other buttons
        tableViewData = donationsEnvelope
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

    
    
    
    
    
    
    // -----------
    // Home Button
    // -----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
