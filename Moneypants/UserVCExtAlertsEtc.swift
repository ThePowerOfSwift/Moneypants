import UIKit

extension UserVC {
    
    func checkIncome() {
        if Income.currentIncomeArray.filter({ $0.user == currentUserName }).isEmpty {
            // create a default array
            let newUserPoints = Income(user: currentUserName, currentPoints: 0)
            Income.currentIncomeArray.append(newUserPoints)
            incomeLabel.text = "$0.00"
        } else {
            for (index, item) in Income.currentIncomeArray.enumerated() {
                if item.user == currentUserName {
                    incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                }
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
    
    func incorrectPasscodeAlert() {
        let wrongPasscodeAlert = UIAlertController(title: "Incorrect Passcode", message: "Please try again.", preferredStyle: .alert)
        wrongPasscodeAlert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            wrongPasscodeAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(wrongPasscodeAlert, animated: true, completion: nil)
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
    
    func calculateLastPayday() -> Date {
        let today = Date()
        var lastPayday: Date!
        
        for n in 1...7 {
            let previousDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -n, to: today)
            // format previous date to show weekday in long format
            // if weekday matches payday, then count number of days since then and only subtotal values since then
            let formatterLong = DateFormatter()
            formatterLong.dateFormat = "EEEE"
            
            if formatterLong.string(from: previousDate!).contains("Saturday") {
                lastPayday = previousDate
                print("payday last was:",previousDate!)
            }
        }
//        print(lastPayday)
//        print(Date().days(from: lastPayday))
        return lastPayday
    }
}
