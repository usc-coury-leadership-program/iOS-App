//
//  HeaderView.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 12/30/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var title: UILabel!
    
    public var delegate: HeaderViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //https://theswiftdev.com/2017/10/11/uikit-init-patterns/
    private func setup() {
        let name = String(describing: Self.self)
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    @IBAction func onLeftButtonTap(_ sender: UIButton) {
        delegate?.onLeftButtonTap()
    }
    @IBAction func onRightButtonTap(_ sender: UIButton) {
        delegate?.onRightButtonTap()
    }
}

public protocol HeaderViewDelegate {
    func onLeftButtonTap()
    func onRightButtonTap()
}
