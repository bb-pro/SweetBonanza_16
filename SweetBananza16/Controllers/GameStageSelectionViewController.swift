
import UIKit

class GameStageSelectionViewController: UIViewController {
    @IBOutlet var usageStatusImageViews: [UIImageView]!
    var maxStage = 2
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialUserAppearance()
    }
    
    @IBAction func kickOffGameButtonTapped(_ sender: UIButton) {
        if sender.tag <= maxStage {
            if let pass = storyboard?.instantiateViewController(withIdentifier: "GameLevelSelectionViewController") as? GameLevelSelectionViewController {
                pass.stage = sender.tag
                navigationController?.pushViewController(pass, animated: true)
            }
        }
    }
    
    @IBAction func returnToRootClicked(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
extension GameStageSelectionViewController {
    func setupInitialUserAppearance() {
        for usageStatusImage in usageStatusImageViews {
            if usageStatusImage.tag <= maxStage {
                usageStatusImage.image = UIImage(named: "gameStagePauseButton")
            } else {
                usageStatusImage.image = UIImage(named: "gameStageXButton")
            }
        }
    }
}
