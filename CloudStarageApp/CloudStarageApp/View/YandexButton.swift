import UIKit.UIButton

final class YandexButton: UIButton {
    
    private let title = String(localized:  "Login with Yandex ID", table: "ButtonsLocalizable")
    var action: (() -> Void)?
    
    init() {
        super .init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private Setup Methods

private extension YandexButton {
    
    func setupButton() {
        var yandexConfig = UIButton.Configuration.filled()
        let font = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.Inter.bold.size(of: 16)
            return outgoing
        }
        
        yandexConfig.title = title
        yandexConfig.image = UIImage(resource: .yandexId)
        yandexConfig.baseBackgroundColor = .black
        yandexConfig.baseForegroundColor = .white
        yandexConfig.titleTextAttributesTransformer = font
        yandexConfig.imagePlacement = .leading
        yandexConfig.imagePadding = 8
        yandexConfig.background.cornerRadius = 12
        configuration = yandexConfig
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
