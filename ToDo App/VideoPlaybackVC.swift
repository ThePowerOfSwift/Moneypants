import UIKit

class VideoPlaybackVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: "https://player.vimeo.com/video/169805431")!))
        
        webView.mediaPlaybackRequiresUserAction = false

    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        webView.stopLoading()
        self.dismiss(animated: true, completion: nil)
    }
}
