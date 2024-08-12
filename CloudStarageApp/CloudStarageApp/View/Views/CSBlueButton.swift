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
        self.setTitle("Далее", for: .normal)
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.titleLabel?.font = .Inter.light.size(of: 16)
        self.setTitleColor(.white, for: .application)
        self.backgroundColor = AppColors.standartBlue
        self.layer.cornerRadius = 12
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
