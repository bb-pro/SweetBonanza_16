
import UIKit

class ComponentsSelectionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func userPressedSettingsButton(_ sender: UIButton) {
        if let pass = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            pass.modalPresentationStyle = .overFullScreen
            present(pass, animated: true)
        }
    }
    
    @IBAction func userClickedToStartGame(_ sender: UIButton) {
        if let gameNavigation = storyboard?.instantiateViewController(withIdentifier: "GameStageSelectionViewController") as? GameStageSelectionViewController {
            navigationController?.pushViewController(gameNavigation, animated: true)
        }
    }
    
    @IBAction func marketBtnGotClicked(_ sender: UIButton) {
        if let marketPass = storyboard?.instantiateViewController(withIdentifier: "ShopRootViewController") as? ShopRootViewController {
            navigationController?.pushViewController(marketPass, animated: true)
        }
    }
    
    @IBAction func trophiesBtnGotPressed(_ sender: UIButton) {
        if let pass = storyboard?.instantiateViewController(withIdentifier: "TrophiesAndFactsViewController") as? TrophiesAndFactsViewController {
            pass.isTrophy = true
            navigationController?.pushViewController(pass, animated: true)
        }
    }
    
    @IBAction func userWantsGoFacts(_ sender: UIButton) {
        if let pass = storyboard?.instantiateViewController(withIdentifier: "TrophiesAndFactsViewController") as? TrophiesAndFactsViewController {
            pass.isTrophy = false
            navigationController?.pushViewController(pass, animated: true)
        }
    }
}
