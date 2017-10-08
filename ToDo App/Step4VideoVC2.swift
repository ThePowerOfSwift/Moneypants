import UIKit

class Step4VideoVC2: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: "https://player.vimeo.com/video/169805436")!))
        webView.mediaPlaybackRequiresUserAction = false     // begin playing automatically
        webView.mediaPlaybackAllowsAirPlay = true
        webView.allowsInlineMediaPlayback = false // only go full screen, not in place
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
