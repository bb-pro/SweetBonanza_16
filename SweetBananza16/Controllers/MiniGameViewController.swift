
import UIKit
import SnapKit

class MiniGameViewController: UIViewController {
    @IBOutlet var candyImageViews: [UIImageView]!
    @IBOutlet var cupImageViews: [UIImageView]!
    @IBOutlet weak var candyStack: UIStackView!
    @IBOutlet weak var gameCompletionMessageLabel: UILabel!
    @IBOutlet weak var coinGroupImageView: UIImageView!
    @IBOutlet weak var gameCompletionStack: UIStackView!
    @IBOutlet weak var cupStack: UIStackView!
    @IBOutlet var cupTappedButtons: [UIButton]!
    
    var index = Int.random(in: 0...2)
    var gameStage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    @IBAction func cupClicked(_ sender: UIButton) {
        for btn in cupTappedButtons {
            btn.isUserInteractionEnabled = false
        }
        for img in candyImageViews {
            if img.tag == index {
                img.image = UIImage(named: "candyImage")
            } else {
                img.image = nil
            }
        }
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut) {
            for img in self.cupImageViews {
                if img.tag == sender.tag {
                    img.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().inset(20)
                        make.top.equalToSuperview().inset(-20)
                    }
                }
            }
            self.view.layoutIfNeeded()
        } completion: { [self]_ in
            candyStack.alpha = 1.0
            UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut) {
                self.candyStack.snp.updateConstraints{ make in
                    make.bottom.equalTo(self.cupStack.snp.top).offset(-15)
                }
                self.view.layoutIfNeeded()
            } completion: { [self]_ in
                if sender.tag == index {
                    gameCompletionMessageLabel.text = "Nice!"
                    coinGroupImageView.image = UIImage(named: "winMiniGameGroupCoin")
                    let coins = UserHavePowersManager.shared.fetchCoin()
                    UserHavePowersManager.shared.updateComponents(coin: coins + 15, misteryBox: nil, timeFreezer: nil)
                } else {
                    gameCompletionMessageLabel.text = "Badly!"
                    coinGroupImageView.image = UIImage(named: "loseMiniGameGroupCoin")
                }
                UIView.animate(withDuration: 1.5) {
                    self.candyStack.alpha = 0.0
                    self.gameCompletionStack.alpha = 1.0
                } completion: { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func setupAnimation() {
        for img in candyImageViews {
            if img.tag == index {
                img.image = UIImage(named: "candyImage")
            }
        }
        for btn in cupTappedButtons {
            btn.isUserInteractionEnabled = false
        }
        let candyStackWidth = candyStack.frame.height + 30
        UIView.animate(withDuration: 2.5, delay: 0, options: .curveEaseIn) {
            self.candyStack.snp.updateConstraints{ make in
                make.bottom.equalTo(self.cupStack.snp.top).offset(candyStackWidth)
            }
            self.view.layoutIfNeeded()
        } completion: { [self]_ in
            candyStack.alpha = 0.0
            UIView.animate(withDuration: 1.5) {
                self.cupStack.alpha = 0.0
            } completion: { _ in
                UIView.animate(withDuration: 1.5) {
                    self.cupStack.alpha = 1.0
                } completion: { [self]_ in
                    index = Int.random(in: 0...2)
                    for btn in cupTappedButtons {
                        btn.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}
