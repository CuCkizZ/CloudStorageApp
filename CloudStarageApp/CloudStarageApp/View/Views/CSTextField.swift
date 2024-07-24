import UIKit

final class CSTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.cornerRadius = 12
        self.backgroundColor = AppColors.customGray.withAlphaComponent(0.3)
        self.textAlignment = .left
        self.textColor = .black
        self.font = .Inter.regular.size(of: 16)
        self.clearButtonMode = .whileEditing
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
        
        let placeholderColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string: "0", 
                                                        attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
}
