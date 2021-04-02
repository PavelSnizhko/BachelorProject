//
//  CircleAnimationView.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import UIKit


class CircleAnimationView: UIView {
    
    private var isAnimating = false
    private var shapeLayers: [CAShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        generateShapeLayers(count: 3)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isHidden = true
        generateShapeLayers(count: 3)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
   
    
    func updateAnimation() {
        isHidden = false
        guard !isAnimating else { return }
        shapeLayers.enumerated().forEach({ (index, shapeLayer) in
            let timeInterval = Double(index) * 0.2
            shapeLayer.frame = bounds
            shapeLayer.isHidden = false
            let groupAnimation = makeGroupAnimation(time: timeInterval)
            shapeLayer.add(groupAnimation, forKey: nil)
        })
        isAnimating.toggle()
    }
    
    func stopAnimationView() {
        isHidden = true
        guard self.isAnimating else { return }
        self.shapeLayers.forEach( { $0.removeAllAnimations() } )
        isAnimating.toggle()
    }
    
    
   private func createTransitionAnimation() -> CABasicAnimation{
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 1.0
        scaleAnimation.repeatCount = .infinity

        return scaleAnimation
    }
    
    
    
   private func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityKeyframeAnimation.values = [0.8, 0.6, 0.4, 0.2, 0]
        opacityKeyframeAnimation.repeatCount = .infinity
    
        return opacityKeyframeAnimation
    }
    
    
   private func makeGroupAnimation(time: Double) -> CAAnimationGroup {
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [createTransitionAnimation(), createOpacityAnimation()]
        animationGroup.beginTime = CACurrentMediaTime() + time
        animationGroup.duration = 1.3
        animationGroup.repeatCount = .greatestFiniteMagnitude
        
        return animationGroup
    }

}


private extension CircleAnimationView {
    private func generateShapeLayers(count: Int)  {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.width * 0.5,
                                                   y: bounds.height * 0.5),
                        radius: bounds.width * 0.5,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi * 2),
                        clockwise: false).cgPath

        for _ in 1...count {
            let circle: CAShapeLayer = .init()
            circle.path = circlePath
            circle.fillColor = UIColor(named: "customBlue")?.cgColor
            circle.opacity = 0
            self.shapeLayers.append(circle)
            layer.addSublayer(circle)
         }
     }
}
