import UIKit

extension UserVC {
    
    func createNewItemForDailyHabit(indexPath: IndexPath) {
        var valuePerTap = 0
        
        if indexPath.row == 0 {
            valuePerTap = priorityHabitPointValue!
        } else {
            valuePerTap = regularHabitPointValue!
        }
        
        let pointThingy = Points(user: currentUserName,
                                 itemName: (usersDailyHabits?[indexPath.row].name)!,
                                 itemCategory: "daily habits",
                                 code: "C",
                                 valuePerTap: valuePerTap,
                                 itemDate: Date().timeIntervalSince1970)
        
        Points.pointsArray.append(pointThingy)
        
        // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += valuePerTap
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                updateProgressMeterHeights()
            }
        }
    }
    
    func createZeroValueItemForDailyHabit(indexPath: IndexPath) {
        let undoneHabit = Points(user: self.currentUserName,
                                 itemName: self.usersDailyHabits[indexPath.row].name,
                                 itemCategory: "daily habits",
                                 code: "N",
                                 valuePerTap: 0,
                                 itemDate: Date().timeIntervalSince1970)
        
        Points.pointsArray.append(undoneHabit)
        tableView.setEditing(false, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func getParentalPasscodeThenResetItemToZero(isoArray: [Points], indexPath: IndexPath) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to override a habit that has been marked 'not done'.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, no kids
            let parentalArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                
                // if array is not empty, delete the item from the array
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily habits" && pointsItem.itemName == isoArray.first?.itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: (isoArray.first?.itemDate)!)) {
                        
                        // remove item from points array (no need to do anything else: value was already zero)
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // update tableview
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            } else {
                self.incorrectPasscodeAlert()
            }
        }))
        // Button TWO: "cancel", reset table to normal
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
            self.tableView.setEditing(false, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
