import UIKit.UILabel

final class TitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        self.font = .Inter.bold.size(of: 10)
        self.backgroundColor = .white
        self.textColor = .black
    }
    
}
