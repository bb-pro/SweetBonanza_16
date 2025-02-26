
import UIKit

class CustomBlurredAlertViewController: UIViewController {
    @IBOutlet weak var contectNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    var contextName: String?
    var imageName: String?
    var info: String?
    var buttonTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearances()
    }
    
    @IBAction func bottomButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
private extension CustomBlurredAlertViewController {
    private func setupAppearances() {
        if let contextName = contextName,
           let imageName = imageName,
           let info = info,
           let buttonTitle = buttonTitle {
            contectNameLabel.text = contextName
            itemImageView.image = UIImage(named: imageName)
            itemDescriptionLabel.text = info
            bottomButton.setTitle(buttonTitle, for: .normal)
        }
    }
}
