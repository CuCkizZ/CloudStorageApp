import UIKit
import SnapKit


final class ViewController: UIViewController {
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.storagePink
        testSetup()
    }

    func testSetup() {
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        label.text = "Hello World!"
        label.font = .Inter.bold.size(of: 40)
        label.textColor = .black
    }

}

