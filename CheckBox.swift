//
//  CheckBox.swift
//  Friend List
//
//  Created by phi.thai on 3/16/23.
//

import UIKit

@IBDesignable
class CheckBox: UIControl {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    private weak var imageView: UIImageView!
    
    @IBInspectable
    public var check: Bool = false {
        didSet{
            imageView.image = image
        }
    }
    
    private var image: UIImage {
        return check ?  UIImage(systemName: "checkmark.square.fill")! : UIImage(systemName: "square")!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0 ).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0 ).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0 ).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0 ).isActive = true
        
        self.imageView = imageView
        backgroundColor = UIColor.clear
        
        addTarget(self, action: #selector(touchHandler), for: .touchUpInside)
        
    }
    
    @objc func touchHandler() {
        check = !check
        sendActions(for: .valueChanged)
    }
    
    
}
