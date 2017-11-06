import UIKit
import AVKit

class VideosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    // refresh table view after user taps, so cells don't stay selected
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    // ----------------
    // Setup Table View
    // ----------------

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return trainingVideos.count
        } else if section == 1 {
            return setupVideos.count
        } else {
            return miscVideos.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "training videos"
        } else if section == 1 {
            return "setup videos"
        } else {
            return "miscellaneous"
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
        
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! VideosCell
        if indexPath.section == 0 {
            cell.videoLabel.text = trainingVideos[indexPath.row]
        } else if indexPath.section == 1 {
            cell.videoLabel.text = setupVideos[indexPath.row]
        } else {
            let (videoName, videoLocation) = miscVideos[indexPath.row]
            cell.videoLabel.text = videoName
            print(videoLocation)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let videoName = trainingVideos[indexPath.row]
            print(videoName)
        }
    }
}
