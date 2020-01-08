//
//  CubeView.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 1/6/20.
//  Copyright © 2020 USC Marshall School of Business. All rights reserved.
//

import UIKit
import CoreMotion

class CubeView: UIView {
    @IBOutlet var contentView: UIView!
    
    internal var transformLayer: CATransformLayer = CATransformLayer()
    internal var transformPrimary: CATransform3D = CATransform3D()
    
    public var topFaceIndex: Int {
        if abs(transformPrimary.m13) > 0.5 {
            return transformPrimary.m13 > 0.0 ? 0 : 3
        }else if abs(transformPrimary.m23) > 0.5 {
            return transformPrimary.m23 > 0.0 ? 1 : 4
        }else {
            return transformPrimary.m33 > 0.0 ? 2 : 5
        }
    }
    
    internal var tareAttitude: CMAttitude = CMAttitude()
    public var needsTaring: Bool = true
    
    internal var motionManager: CMMotionManager?
    
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
    
    public func createFaces<T: UIView>(in bounds: CGRect) -> [T] {
        let size = min(bounds.width, bounds.height)
        let views = Self.createCubeTransforms(side: size/2.0).map { transform -> T in
            
            let t = T()
            t.layer.frame = CGRect(x: -size/2.0, y: -size/2.0, width: size, height: size)
            t.layer.transform = transform
            
            contentView.addSubview(t)
            transformLayer.addSublayer(t.layer)
            
            return t
        }
        
        return views
    }
    
    public func situate(in bounds: CGRect) {
        transformLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        transformPrimary = transformLayer.transform// general set up, has nothing to do with situate
        contentView.layer.addSublayer(transformLayer)
    }
    
    public func roll(randomness: Int = 1) {
        CATransaction.begin()
        
        let anim = CABasicAnimation(keyPath: "transform")
        anim.duration = 0.2
        anim.fromValue = transformLayer.transform
        
        for _ in 0..<randomness {transformPrimary.rollRandomly(around: [.right, .up])}
        transformLayer.transform = transformPrimary
        
        anim.toValue = transformPrimary
        transformLayer.add(anim, forKey: "transform")
        
        CATransaction.commit()
    }
    
    public func enableMotion() {
        motionManager = CMMotionManager()
    }
    
    internal func tareMotion(attitude: CMAttitude) {
        tareAttitude = attitude
        needsTaring = false
    }
    
    public func trackMotion(_ enabled: Bool) {
        if enabled {
            motionManager?.deviceMotionUpdateInterval = 0.1
            motionManager?.startDeviceMotionUpdates(to: .main) { motion, error in
                if let a = motion?.attitude {
                    if self.needsTaring {self.tareMotion(attitude: a)}
                    
                    let scale: CGFloat = 0.25
                    let pitch = scale*CGFloat(a.pitch - self.tareAttitude.pitch)
                    let roll = scale*CGFloat(a.roll - self.tareAttitude.roll)
                    
                    var transformTilted: CATransform3D = self.transformPrimary
                    transformTilted.roll(around: .right, angle: -pitch)
                    transformTilted.roll(around: .up, angle: roll)
                    self.transformLayer.transform = transformTilted
                }
            }
        }else {
            motionManager?.stopDeviceMotionUpdates()
        }
    }
    
    //https://www.hackingwithswift.com/articles/135/how-to-render-uiviews-in-3d-using-catransformlayer
    internal static func createCubeTransforms(side d: CGFloat) -> [CATransform3D] {
        // Cube is centered at (0, 0, 0)
        var transforms: [CATransform3D] = [
            CATransform3DMakeTranslation(+d, 0, 0),
            CATransform3DMakeTranslation(0, +d, 0),
            CATransform3DMakeTranslation(0, 0, +d),
            CATransform3DMakeTranslation(-d, 0, 0),
            CATransform3DMakeTranslation(0, -d, 0),
            CATransform3DMakeTranslation(0, 0, -d)
        ]
        transforms[0] = CATransform3DRotate(transforms[0], +.pi/2, 0, 1, 0)
        transforms[1] = CATransform3DRotate(transforms[1], -.pi/2, 1, 0, 0)
        // not necessary for transforms[2]
        transforms[3] = CATransform3DRotate(transforms[3], -.pi/2, 0, 1, 0)
        transforms[4] = CATransform3DRotate(transforms[4], +.pi/2, 1, 0, 0)
        transforms[5] = CATransform3DRotate(transforms[5], +.pi/1, 0, 1, 0)
        
        // Cube is centered at (0, 0, d)
//        var transforms: [CATransform3D] = [
//            CATransform3DMakeTranslation(+d, 0, +d),
//            CATransform3DMakeTranslation(0, +d, +d),
//            CATransform3DMakeTranslation(0, 0, 2*d),
//            CATransform3DMakeTranslation(-d, 0, +d),
//            CATransform3DMakeTranslation(0, -d, +d),
//            CATransform3DMakeTranslation(0, 0, 0)
//        ]
//        transforms[0] = CATransform3DRotate(transforms[0], +.pi/2, 0, 1, 0)
//        transforms[1] = CATransform3DRotate(transforms[1], -.pi/2, 1, 0, 0)
//        // not necessary for transforms[2]
//        transforms[3] = CATransform3DRotate(transforms[3], -.pi/2, 0, 1, 0)
//        transforms[4] = CATransform3DRotate(transforms[4], +.pi/2, 1, 0, 0)
//        transforms[5] = CATransform3DRotate(transforms[5], +.pi/1, 0, 1, 0)
        
        return transforms
    }
}
