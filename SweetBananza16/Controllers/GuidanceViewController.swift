
import UIKit

class GuidanceViewController: UIViewController {
    @IBOutlet weak var topTimerShownImageView: UIImageView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var messageShownLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomComponentsImgView: UIImageView!
    
    var index = 0
    let messages = ["Hi I'm Jessica and I'll be your mentor in our beautiful game!", "You control the character, your task is to pass the level within a certain time limit", "There will be obstacles in the game, to pass them sometimes you will need artifacts,", "Also use the amps you can buy at the shop", "Win, open new and interesting locations", "And most importantly enjoy the game!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        declareUserAppearanceThroughIndex()
    }
    
    @IBAction func userPressedStartButton(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "CrucialGameViewController") as? CrucialGameViewController {
            viewController.stage = 0
            viewController.level = 0
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func previousPageOpenedButtonTapped(_ sender: UIButton) {
        if index > 0 {
            index -= 1
            declareUserAppearanceThroughIndex()
        }
    }
    
    @IBAction func nextPageOpenedButtonGotClicked(_ sender: UIButton) {
        if index < 5 {
            index += 1
            declareUserAppearanceThroughIndex()
        }
    }
}
extension GuidanceViewController {
    private func declareUserAppearanceThroughIndex() {
        messageShownLabel.text = messages[index]
        bottomComponentsImgView.image = UIImage(named: "guidanceBottom\(index)")
        pageLabel.text = "pg \(index + 1)"
        switch index {
        case 0:
            prevButton.isUserInteractionEnabled = false
            prevButton.setBackgroundImage(UIImage(named: "guidancePrevDisabled"), for: .normal)
            topTimerShownImageView.isHidden = true
        case 1:
            prevButton.isUserInteractionEnabled = true
            prevButton.setBackgroundImage(UIImage(named: "guidePrevButton"), for: .normal)
            topTimerShownImageView.isHidden = false
        case 2:
            topTimerShownImageView.isHidden = false
        case 3:
            topTimerShownImageView.isHidden = true
        case 4:
            nextButton.isUserInteractionEnabled = true
            nextButton.setBackgroundImage(UIImage(named: "guideNextButton"), for: .normal)
            startButton.isHidden = true
        case 5:
            nextButton.isUserInteractionEnabled = false
            nextButton.setBackgroundImage(UIImage(named: "guidanceNextDisabled"), for: .normal)
            startButton.isHidden = false
        default:
            break
        }
    }
}
