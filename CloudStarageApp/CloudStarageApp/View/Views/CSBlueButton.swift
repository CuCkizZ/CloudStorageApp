import UIKit.UIButton

final class CSBlueButton: UIButton {
    
    var action: (() -> Void)?
    
    init() {
        super .init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String?) {
        self.setTitle(title, for: .normal)
    }
}

// MARK: Private Setup Methods

private extension CSBlueButton {
    
    func setupButton() {
        var config = UIButton.Configuration.filled()
        let font = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Inter.light.size(of: 16)
            return outgoing
        }
        config.title = "Далее"
        config.baseBackgroundColor = AppColors.standartBlue
        config.baseForegroundColor = .white
        config.titleTextAttributesTransformer = font
        config.background.cornerRadius = 12
        self.configuration = config
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
