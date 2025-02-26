
import UIKit
import SnapKit

class FirstLoaderViewController: UIViewController {

    lazy var viewToEmbedComponents = UIView()
    lazy var loaderProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.progressImage = UIImage(named: "progressViewProgressImage")
        progressView.trackTintColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 0.7)
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 15
        progressView.layer.borderWidth = 2.0
        progressView.layer.borderColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 0.7).cgColor
        return progressView
    }()
    
    lazy var userActivateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Ranchers-Regular", size: 15)
        label.text = "loading"
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 2, height: 2)
        return label
    }()
    
    lazy var percentageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Ranchers-Regular", size: 15)
        lbl.text = "0%"
        lbl.textColor = .white
        lbl.shadowColor = .black
        lbl.shadowOffset = CGSize(width: 2, height: 2)
        return lbl
    }()
    var loadingTimer: Timer?
    var progressAmount: Float = 0.0
    let storyboardInitialization = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUIAppearance()
        beginAnimatingProgressView()
    }
    
    private func beginAnimatingProgressView() {
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.progressAmount += 0.004
            percentageLabel.text = "\(Int(progressAmount * 100))%"
            if progressAmount >= 0.75 {
                userActivateLabel.text = "you ready?"
            } else {
                userActivateLabel.text = "loading..."
            }
            self.loaderProgressView.setProgress(self.progressAmount, animated: true)
            if self.progressAmount >= 1.0 {
                self.loadingTimer?.invalidate()
                let vc = self.storyboardInitialization.instantiateViewController(withIdentifier: "DeepNavController")
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        }
    }
}
private extension FirstLoaderViewController {
    private func setupInitialUIAppearance() {
        view.addSubview(viewToEmbedComponents)
        viewToEmbedComponents.backgroundColor = .clear
        viewToEmbedComponents.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(30)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        viewToEmbedComponents.addSubview(loaderProgressView)
        loaderProgressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewToEmbedComponents.addSubview(userActivateLabel)
        userActivateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
        
        viewToEmbedComponents.addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
    }
}

