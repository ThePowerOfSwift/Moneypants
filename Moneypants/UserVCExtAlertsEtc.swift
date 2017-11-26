import UIKit

extension UserVC {
    
    func checkIncome() {
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
    }
    
    func alertE(indexPath: IndexPath, deselectRow: Bool) {
        let alertE = UIAlertController(title: "Excused", message: "This job is currently excused. In order to change it, tap the 'reset' button.", preferredStyle: .alert)
        alertE.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alertE.dismiss(animated: true, completion: nil)
            
            // to determine whether to perform tableview animation upon alert dismissal
            if deselectRow == true {
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else {
                //                self.tableView.setEditing(false, animated: true)
            }
        }))
        present(alertE, animated: true, completion: nil)
    }
    
    func alertX(indexPath: IndexPath, deselectRow: Bool) {
        let alertX = UIAlertController(title: "Unexcused", message: "This job is currently unexcused. In order to change it, tap the 'reset' button.", preferredStyle: .alert)
        alertX.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alertX.dismiss(animated: true, completion: nil)
            
            // to determine whether to perform tableview animation upon alert dismissal
            if deselectRow == true {
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else {
                //                self.tableView.setEditing(false, animated: true)
            }
        }))
        self.present(alertX, animated: true, completion: nil)
    }
    
    func alertN(indexPath: IndexPath, deselectRow: Bool, jobOrHabit: String) {
        let alertN = UIAlertController(title: "Not Done", message: "This \(jobOrHabit) is currently marked as 'not done'. In order to change it, tap the 'reset' button.", preferredStyle: .alert)
        alertN.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alertN.dismiss(animated: true, completion: nil)
            // to determine whether to perform tableview animation upon alert dismissal
            if deselectRow == true {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }))
        present(alertN, animated: true, completion: nil)
    }
    
    func tooManyStrikesAlert() {
        let alert = UIAlertController(title: "3 Strikes", message: "\(currentUserName!) has reached the maximum daily fee amount. It's been a rough day.\n\n\(currentUserName!) should just go to \(MPUser.gender(user: MPUser.currentUser).his_her.lowercased()) room for the remainder of the day and try again tomorrow.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func incorrectPasscodeAlert() {
        let wrongPasscodeAlert = UIAlertController(title: "Incorrect Passcode", message: "Please try again.", preferredStyle: .alert)
        wrongPasscodeAlert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            wrongPasscodeAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(wrongPasscodeAlert, animated: true, completion: nil)
    }
    
    func customizeImages() {
        userImage.layer.cornerRadius = topView.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        // flyover view
        habitBonusView.layer.borderWidth = 4
        habitBonusView.layer.borderColor = UIColor.lightGray.cgColor
        habitBonusView.alpha = 0
        
        // static progress view button
        habitTotalProgressView.layer.cornerRadius = habitTotalProgressView.layer.bounds.height / 6.4
        habitTotalProgressView.layer.masksToBounds = true
        habitTotalProgressView.layer.borderWidth = 0.5
        habitTotalProgressView.layer.borderColor = UIColor.black.cgColor
    }
    
    func displayHabitBonusFlyover() {
        habitBonusAmountLabel.text = "$\(String(format: "%.2f", Double(jobAndHabitBonusValue!) / 100))"
        trophyView.image = UIImage(named: "trophy black")
        trophyView.tintColor = .white
        habitBonusCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.habitBonusView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        habitBonusSound.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.habitBonusCenterConstraint.constant = 300
                self.habitBonusView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func updateFormattedDate() {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(selectedDate) {
            formatter.dateFormat = "'today'"
        } else if Calendar.current.isDateInYesterday(selectedDate) {
            formatter.dateFormat = "'yesterday'"
        } else {
            formatter.dateFormat = "EEEE"
        }
        dateLower.text = "\(formatter.string(from: selectedDate))"
    }
    
    // ---------------
    // Date calculator
    // ---------------
    
    func dayDifference(from interval : TimeInterval) -> String {
        
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
}
