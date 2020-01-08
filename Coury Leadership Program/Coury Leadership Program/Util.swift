//
//  Util.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 7/19/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

extension UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    static func instantiate(autolayout: Bool = true) -> Self {
        // generic helper function
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate() as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

protocol Named {
    var name: String { get }
}

extension CATransform3D {
    var zIsUp: Bool {return m33 > 0}
    
    func rolled(around axis: Axis, angle: CGFloat) -> CATransform3D {
        let vector: [CGFloat]
        switch axis {
        case .right:
            vector = [m11, m21, m31]
        case .up:
            vector = [m12, m22, m32]
        case .out:
            vector = [m13, m23, m33]
        }
        
        return CATransform3DRotate(self, angle, vector[0], vector[1], vector[2])
    }
    
    func rolled(around axis: Axis, clockwise: Bool) -> CATransform3D {
        let angle: CGFloat = clockwise ? +.pi/2.0 : -.pi/2.0
        return rolled(around: axis, angle: angle)
    }
    
    func rolledRandomly(around axis: [Axis]) -> CATransform3D {
        guard let axis = axis.randomElement() else {return self}
        return rolled(around: axis, clockwise: Bool.random())
    }
    
    func rolledRandomly() -> CATransform3D {
        return rolledRandomly(around: Axis.allCases)
    }
    
    mutating func roll(around axis: Axis, angle: CGFloat) {
        self = rolled(around: axis, angle: angle)
    }
    
    mutating func roll(around axis: Axis, clockwise: Bool) {
        self = rolled(around: axis, clockwise: clockwise)
    }
    
    mutating func rollRandomly(around axis: [Axis]) {
        self = rolledRandomly(around: axis)
    }
    
    mutating func rollRandomly() {
        self = rolledRandomly()
    }
}

enum Axis: CaseIterable {case right, up, out}
