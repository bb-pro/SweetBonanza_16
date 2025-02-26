
import UIKit

class ShopRootViewController: UIViewController {
    @IBOutlet weak var userHasMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userHasMoneyLabel.text = "\(UserHavePowersManager.shared.fetchCoin())"
    }
    
    @IBAction func bostersTapped(_ sender: UIButton) {
        if let shop = storyboard?.instantiateViewController(withIdentifier: "ItemsShopViewController") as? ItemsShopViewController {
            shop.isPower = true
            navigationController?.pushViewController(shop, animated: true)
        }
    }
    
    @IBAction func skinsClicked(_ sender: UIButton) {
        if let shop = storyboard?.instantiateViewController(withIdentifier: "ItemsShopViewController") as? ItemsShopViewController {
            shop.isPower = false
            navigationController?.pushViewController(shop, animated: true)
        }
    }
    
    @IBAction func returnToBack(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
