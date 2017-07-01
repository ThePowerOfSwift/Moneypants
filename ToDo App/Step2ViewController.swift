//
//  Step2ViewController.swift
//  ToDo App
//
//  Created by Phontaine Judd on 6/26/17.
//  Copyright © 2017 Echessa. All rights reserved.
//

import UIKit

class Step2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tempUsers = ["Dad", "Mom", "Savannah", "Aiden", "Sophie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep table view up high when
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempUsers.count        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2CustomCell
        cell.myImage.image = UIImage(named: tempUsers[indexPath.row] + ".jpg")
        cell.myLabel.text = tempUsers[indexPath.row]
        
        cell.myImage.layer.cornerRadius = tableView.rowHeight / 6.4      // should be height / 6.4
        cell.myImage.layer.masksToBounds = true
        cell.myImage.layer.borderWidth = 0.5
        cell.myImage.layer.borderColor = UIColor.black.cgColor

        
        return cell
    }
    

    


}
