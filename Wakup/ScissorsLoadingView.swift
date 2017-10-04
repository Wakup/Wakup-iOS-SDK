//
//  ScissorsLoadingView.swift
//
//  Code generated using QuartzCode on 20/01/15.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable class ScissorsLoadingView: UIView {
	
	var layerWithAnims : [CALayer]!
	var animationAdded : Bool = false
	var group : CALayer!
	var circle : CAShapeLayer!
	var scissors : CALayer!
	var down : CAShapeLayer!
	var up : CAShapeLayer!
    
    @IBInspectable var fillColor: UIColor = UIColor.gray {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable var autoStartAnimation: Bool = true
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    override var frame: CGRect {
        didSet{
            setupLayerFrames()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if (autoStartAnimation) {
            startAllAnimations(nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayerFrames()
    }
    
    func setupColors() {
        circle.fillColor = fillColor.cgColor
        up.fillColor   = fillColor.cgColor
        down.fillColor   = fillColor.cgColor
    }
    
    func setupLayers(){
        group = CALayer()
        self.layer.addSublayer(group)
        
        
        circle = CAShapeLayer()
        group.addSublayer(circle)
        circle.lineWidth = 0
        
        scissors = CALayer()
        group.addSublayer(scissors)
        
        down = CAShapeLayer()
        scissors.addSublayer(down)
        down.anchorPoint = CGPoint(x: 0.45, y: 0.25)
        down.lineWidth   = 0
        
        up = CAShapeLayer()
        scissors.addSublayer(up)
        up.anchorPoint = CGPoint(x: 0.45, y: 0.75)
        up.lineWidth   = 0
        
        setupColors()
        setupLayerFrames()
        
        self.layerWithAnims = [group, circle, scissors, down, up]
    }
    
    
    func setupLayerFrames(){
        if let group = group {
            group.frame = CGRect(x: 0, y: 0, width: group.superlayer!.bounds.width, height: group.superlayer!.bounds.height)
        }
        if let circle = circle {
            circle.frame = CGRect(x: 0, y: 0,  width: circle.superlayer!.bounds.width,  height: circle.superlayer!.bounds.height)
            circle.path  = CirclePathWithBounds(circle.bounds).cgPath;
        }
        if let scissors = scissors {
            scissors.frame = CGRect(x: 0.11218 * scissors.superlayer!.bounds.width, y: 0.33423 * scissors.superlayer!.bounds.height, width: 0.81066 * scissors.superlayer!.bounds.width, height: 0.3216 * scissors.superlayer!.bounds.height)
        }
        if let down = down {
            down.frame = CGRect(x: 0, y: 0.33129 * down.superlayer!.bounds.height, width: 0.99906 * down.superlayer!.bounds.width, height: 0.66871 * down.superlayer!.bounds.height)
            down.path  = DownPathWithBounds(down.bounds).cgPath;
        }
        if let up = up {
            up.frame = CGRect(x: 0.00094 * up.superlayer!.bounds.width, y: 0, width: 0.99906 * up.superlayer!.bounds.width, height: 0.66871 * up.superlayer!.bounds.height)
            up.path  = UpPathWithBounds(up.bounds).cgPath;
        }
    }
    
    
    @IBAction func startAllAnimations(_ sender: AnyObject!){
        self.animationAdded = false
        for layer in self.layerWithAnims{
            layer.speed = 1
        }
        
        circle?.add(CircleAnimation(), forKey:"CircleAnimation")
        scissors?.add(ScissorsAnimation(), forKey:"ScissorsAnimation")
        down?.add(DownAnimation(), forKey:"DownAnimation")
        up?.add(UpAnimation(), forKey:"UpAnimation")
    }
    
    var progress: CGFloat = 0 {
        didSet{
            if(!self.animationAdded){
                startAllAnimations(nil)
                self.animationAdded = true
                for layer in self.layerWithAnims{
                    layer.speed = 0
                    layer.timeOffset = 0
                }
            }
            else{
                let totalDuration : CGFloat = 1000
                let offset = progress * totalDuration
                for layer in self.layerWithAnims{
                    layer.timeOffset = CFTimeInterval(offset)
                }
            }
        }
    }
    
    func CircleAnimation() -> CABasicAnimation{
        let transformAnim         = CABasicAnimation(keyPath:"transform.rotation")
        transformAnim.fromValue   = 0;
        transformAnim.toValue     = 360 * CGFloat.pi/180;
        transformAnim.duration    = 6
        transformAnim.repeatCount = Float.infinity
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.isRemovedOnCompletion = false
        
        return transformAnim;
    }
    
    func ScissorsAnimation() -> CAKeyframeAnimation{
        let transformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        let radian                = CGFloat.pi/180
        transformAnim.values = [0,
            0,
            90 * radian,
            90 * radian,
            180 * radian,
            180 * radian,
            270 * radian,
            270 * radian,
            360 * radian]
        transformAnim.keyTimes    = [0, 0.2, 0.25, 0.45, 0.5, 0.7, 0.75, 0.95, 1]
        transformAnim.duration    = 6
        transformAnim.repeatCount = Float.infinity
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.isRemovedOnCompletion = false
        
        return transformAnim;
    }
    
    func DownAnimation() -> CAKeyframeAnimation{
        let transformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        let radian                = CGFloat.pi/180
        transformAnim.values = [-25 * radian,
            -25 * radian,
            0,
            -25 * radian,
            0,
            -25 * radian,
            -25 * radian,
            0,
            -25 * radian,
            0,
            -25 * radian,
            -25 * radian,
            0,
            -25 * radian,
            0,
            -25 * radian,
            -25 * radian,
            0,
            -25 * radian,
            0,
            -25 * radian,
            -25 * radian]
        transformAnim.keyTimes    = [0, 0.0333, 0.0667, 0.1, 0.133, 0.167, 0.283, 0.317, 0.35, 0.383, 0.417, 0.533, 0.567, 0.6, 0.633, 0.667, 0.783, 0.817, 0.85, 0.883, 0.917, 1]
        transformAnim.duration    = 6
        transformAnim.repeatCount = Float.infinity
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.isRemovedOnCompletion = false
        
        return transformAnim;
    }
    
    func UpAnimation() -> CAKeyframeAnimation{
        let transformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        let radian                = CGFloat.pi/180
        transformAnim.values = [25 * radian,
            25 * radian,
            0,
            25 * radian,
            0,
            25 * radian,
            25 * radian,
            0,
            25 * radian,
            0,
            25 * radian,
            25 * radian,
            0,
            25 * radian,
            0,
            25 * radian,
            25 * radian,
            0,
            25 * radian,
            0,
            25 * radian,
            25 * radian]
        transformAnim.keyTimes    = [0, 0.0333, 0.0667, 0.1, 0.133, 0.167, 0.283, 0.317, 0.35, 0.383, 0.417, 0.533, 0.567, 0.6, 0.633, 0.667, 0.783, 0.817, 0.85, 0.883, 0.917, 1]
        transformAnim.duration    = 6
        transformAnim.repeatCount = Float.infinity
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.isRemovedOnCompletion = false
        
        return transformAnim;
    }
    
    //MARK: - Bezier Path
    
    func CirclePathWithBounds(_ bound: CGRect) -> UIBezierPath{
        let CirclePath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        CirclePath.move(to: CGPoint(x: minX + 0.50014 * w, y: minY + h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.44431 * w, y: minY + 0.99694 * h), controlPoint1:CGPoint(x: minX + 0.48141 * w, y: minY + 1 * h), controlPoint2:CGPoint(x: minX + 0.46267 * w, y: minY + 0.99897 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.43466 * w, y: minY + 0.98488 * h), controlPoint1:CGPoint(x: minX + 0.43831 * w, y: minY + 0.99627 * h), controlPoint2:CGPoint(x: minX + 0.434 * w, y: minY + 0.99087 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.44671 * w, y: minY + 0.97523 * h), controlPoint1:CGPoint(x: minX + 0.43532 * w, y: minY + 0.97889 * h), controlPoint2:CGPoint(x: minX + 0.44071 * w, y: minY + 0.97458 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.5 * w, y: minY + 0.97817 * h), controlPoint1:CGPoint(x: minX + 0.46428 * w, y: minY + 0.97718 * h), controlPoint2:CGPoint(x: minX + 0.48221 * w, y: minY + 0.97817 * h))
        CirclePath.addLine(to: CGPoint(x: minX + 0.50026 * w, y: minY + 0.97817 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.51117 * w, y: minY + 0.98909 * h), controlPoint1:CGPoint(x: minX + 0.50629 * w, y: minY + 0.97817 * h), controlPoint2:CGPoint(x: minX + 0.51117 * w, y: minY + 0.98306 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.50026 * w, y: minY + h), controlPoint1:CGPoint(x: minX + 0.51117 * w, y: minY + 0.99512 * h), controlPoint2:CGPoint(x: minX + 0.50629 * w, y: minY + h))
        CirclePath.addLine(to: CGPoint(x: minX + 0.50014 * w, y: minY + h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.55499 * w, y: minY + 0.99694 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.54415 * w, y: minY + 0.98724 * h), controlPoint1:CGPoint(x: minX + 0.5495 * w, y: minY + 0.99694 * h), controlPoint2:CGPoint(x: minX + 0.54477 * w, y: minY + 0.99282 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.55378 * w, y: minY + 0.97517 * h), controlPoint1:CGPoint(x: minX + 0.54348 * w, y: minY + 0.98125 * h), controlPoint2:CGPoint(x: minX + 0.54779 * w, y: minY + 0.97585 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.60663 * w, y: minY + 0.96623 * h), controlPoint1:CGPoint(x: minX + 0.57151 * w, y: minY + 0.97319 * h), controlPoint2:CGPoint(x: minX + 0.58929 * w, y: minY + 0.97018 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.6197 * w, y: minY + 0.97445 * h), controlPoint1:CGPoint(x: minX + 0.61251 * w, y: minY + 0.96488 * h), controlPoint2:CGPoint(x: minX + 0.61836 * w, y: minY + 0.96857 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.61149 * w, y: minY + 0.98752 * h), controlPoint1:CGPoint(x: minX + 0.62104 * w, y: minY + 0.98033 * h), controlPoint2:CGPoint(x: minX + 0.61736 * w, y: minY + 0.98618 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.55621 * w, y: minY + 0.99687 * h), controlPoint1:CGPoint(x: minX + 0.59335 * w, y: minY + 0.99165 * h), controlPoint2:CGPoint(x: minX + 0.57475 * w, y: minY + 0.9948 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.55499 * w, y: minY + 0.99694 * h), controlPoint1:CGPoint(x: minX + 0.5558 * w, y: minY + 0.99692 * h), controlPoint2:CGPoint(x: minX + 0.55539 * w, y: minY + 0.99694 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.39145 * w, y: minY + 0.98791 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.38902 * w, y: minY + 0.98764 * h), controlPoint1:CGPoint(x: minX + 0.39065 * w, y: minY + 0.98791 * h), controlPoint2:CGPoint(x: minX + 0.38984 * w, y: minY + 0.98782 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.33511 * w, y: minY + 0.97217 * h), controlPoint1:CGPoint(x: minX + 0.37084 * w, y: minY + 0.98352 * h), controlPoint2:CGPoint(x: minX + 0.3527 * w, y: minY + 0.97832 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.3284 * w, y: minY + 0.95827 * h), controlPoint1:CGPoint(x: minX + 0.32941 * w, y: minY + 0.97019 * h), controlPoint2:CGPoint(x: minX + 0.32641 * w, y: minY + 0.96396 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.3423 * w, y: minY + 0.95156 * h), controlPoint1:CGPoint(x: minX + 0.33039 * w, y: minY + 0.95257 * h), controlPoint2:CGPoint(x: minX + 0.33661 * w, y: minY + 0.94957 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.39385 * w, y: minY + 0.96635 * h), controlPoint1:CGPoint(x: minX + 0.35913 * w, y: minY + 0.95743 * h), controlPoint2:CGPoint(x: minX + 0.37647 * w, y: minY + 0.96241 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.40209 * w, y: minY + 0.97941 * h), controlPoint1:CGPoint(x: minX + 0.39973 * w, y: minY + 0.96768 * h), controlPoint2:CGPoint(x: minX + 0.40342 * w, y: minY + 0.97353 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.39145 * w, y: minY + 0.98791 * h), controlPoint1:CGPoint(x: minX + 0.40094 * w, y: minY + 0.98447 * h), controlPoint2:CGPoint(x: minX + 0.39643 * w, y: minY + 0.98791 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.66175 * w, y: minY + 0.97263 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.65145 * w, y: minY + 0.96531 * h), controlPoint1:CGPoint(x: minX + 0.65724 * w, y: minY + 0.97263 * h), controlPoint2:CGPoint(x: minX + 0.65302 * w, y: minY + 0.96981 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.65814 * w, y: minY + 0.9514 * h), controlPoint1:CGPoint(x: minX + 0.64946 * w, y: minY + 0.95963 * h), controlPoint2:CGPoint(x: minX + 0.65245 * w, y: minY + 0.9534 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.70765 * w, y: minY + 0.93085 * h), controlPoint1:CGPoint(x: minX + 0.67494 * w, y: minY + 0.94552 * h), controlPoint2:CGPoint(x: minX + 0.6916 * w, y: minY + 0.9386 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.72223 * w, y: minY + 0.93594 * h), controlPoint1:CGPoint(x: minX + 0.71308 * w, y: minY + 0.92823 * h), controlPoint2:CGPoint(x: minX + 0.71961 * w, y: minY + 0.93051 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.71714 * w, y: minY + 0.95052 * h), controlPoint1:CGPoint(x: minX + 0.72485 * w, y: minY + 0.94137 * h), controlPoint2:CGPoint(x: minX + 0.72257 * w, y: minY + 0.9479 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.66536 * w, y: minY + 0.97201 * h), controlPoint1:CGPoint(x: minX + 0.70036 * w, y: minY + 0.95862 * h), controlPoint2:CGPoint(x: minX + 0.68294 * w, y: minY + 0.96585 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.66175 * w, y: minY + 0.97263 * h), controlPoint1:CGPoint(x: minX + 0.66417 * w, y: minY + 0.97243 * h), controlPoint2:CGPoint(x: minX + 0.66295 * w, y: minY + 0.97263 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.28802 * w, y: minY + 0.9518 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.28328 * w, y: minY + 0.95072 * h), controlPoint1:CGPoint(x: minX + 0.28643 * w, y: minY + 0.9518 * h), controlPoint2:CGPoint(x: minX + 0.28481 * w, y: minY + 0.95146 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.23421 * w, y: minY + 0.92358 * h), controlPoint1:CGPoint(x: minX + 0.26651 * w, y: minY + 0.94264 * h), controlPoint2:CGPoint(x: minX + 0.25 * w, y: minY + 0.93351 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.23078 * w, y: minY + 0.90853 * h), controlPoint1:CGPoint(x: minX + 0.22911 * w, y: minY + 0.92037 * h), controlPoint2:CGPoint(x: minX + 0.22757 * w, y: minY + 0.91364 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.24583 * w, y: minY + 0.9051 * h), controlPoint1:CGPoint(x: minX + 0.23399 * w, y: minY + 0.90342 * h), controlPoint2:CGPoint(x: minX + 0.24072 * w, y: minY + 0.90189 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.29276 * w, y: minY + 0.93105 * h), controlPoint1:CGPoint(x: minX + 0.26093 * w, y: minY + 0.91459 * h), controlPoint2:CGPoint(x: minX + 0.27672 * w, y: minY + 0.92332 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.29786 * w, y: minY + 0.94562 * h), controlPoint1:CGPoint(x: minX + 0.29819 * w, y: minY + 0.93367 * h), controlPoint2:CGPoint(x: minX + 0.30048 * w, y: minY + 0.94019 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.28802 * w, y: minY + 0.9518 * h), controlPoint1:CGPoint(x: minX + 0.29598 * w, y: minY + 0.94953 * h), controlPoint2:CGPoint(x: minX + 0.29208 * w, y: minY + 0.9518 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.76035 * w, y: minY + 0.92503 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.7511 * w, y: minY + 0.91993 * h), controlPoint1:CGPoint(x: minX + 0.75673 * w, y: minY + 0.92503 * h), controlPoint2:CGPoint(x: minX + 0.75318 * w, y: minY + 0.92323 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.75452 * w, y: minY + 0.90487 * h), controlPoint1:CGPoint(x: minX + 0.74789 * w, y: minY + 0.91483 * h), controlPoint2:CGPoint(x: minX + 0.74942 * w, y: minY + 0.90809 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.79821 * w, y: minY + 0.87381 * h), controlPoint1:CGPoint(x: minX + 0.76958 * w, y: minY + 0.89539 * h), controlPoint2:CGPoint(x: minX + 0.78428 * w, y: minY + 0.88494 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.81355 * w, y: minY + 0.87553 * h), controlPoint1:CGPoint(x: minX + 0.80292 * w, y: minY + 0.87005 * h), controlPoint2:CGPoint(x: minX + 0.80979 * w, y: minY + 0.87082 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.81183 * w, y: minY + 0.89087 * h), controlPoint1:CGPoint(x: minX + 0.81731 * w, y: minY + 0.88024 * h), controlPoint2:CGPoint(x: minX + 0.81654 * w, y: minY + 0.88711 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.76616 * w, y: minY + 0.92335 * h), controlPoint1:CGPoint(x: minX + 0.79727 * w, y: minY + 0.9025 * h), controlPoint2:CGPoint(x: minX + 0.78191 * w, y: minY + 0.91343 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.76035 * w, y: minY + 0.92503 * h), controlPoint1:CGPoint(x: minX + 0.76435 * w, y: minY + 0.92449 * h), controlPoint2:CGPoint(x: minX + 0.76234 * w, y: minY + 0.92503 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.19529 * w, y: minY + 0.89351 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.18849 * w, y: minY + 0.89113 * h), controlPoint1:CGPoint(x: minX + 0.19291 * w, y: minY + 0.89351 * h), controlPoint2:CGPoint(x: minX + 0.19051 * w, y: minY + 0.89273 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.14668 * w, y: minY + 0.85379 * h), controlPoint1:CGPoint(x: minX + 0.17394 * w, y: minY + 0.87952 * h), controlPoint2:CGPoint(x: minX + 0.15987 * w, y: minY + 0.86696 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.14667 * w, y: minY + 0.83835 * h), controlPoint1:CGPoint(x: minX + 0.14242 * w, y: minY + 0.84953 * h), controlPoint2:CGPoint(x: minX + 0.14241 * w, y: minY + 0.84262 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.16211 * w, y: minY + 0.83834 * h), controlPoint1:CGPoint(x: minX + 0.15093 * w, y: minY + 0.83409 * h), controlPoint2:CGPoint(x: minX + 0.15784 * w, y: minY + 0.83408 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.2021 * w, y: minY + 0.87406 * h), controlPoint1:CGPoint(x: minX + 0.17472 * w, y: minY + 0.85094 * h), controlPoint2:CGPoint(x: minX + 0.18818 * w, y: minY + 0.86296 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.20383 * w, y: minY + 0.8894 * h), controlPoint1:CGPoint(x: minX + 0.20682 * w, y: minY + 0.87782 * h), controlPoint2:CGPoint(x: minX + 0.20759 * w, y: minY + 0.88469 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.19529 * w, y: minY + 0.89351 * h), controlPoint1:CGPoint(x: minX + 0.20168 * w, y: minY + 0.89211 * h), controlPoint2:CGPoint(x: minX + 0.1985 * w, y: minY + 0.89351 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.84589 * w, y: minY + 0.8567 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.83817 * w, y: minY + 0.8535 * h), controlPoint1:CGPoint(x: minX + 0.8431 * w, y: minY + 0.8567 * h), controlPoint2:CGPoint(x: minX + 0.8403 * w, y: minY + 0.85563 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.83817 * w, y: minY + 0.83806 * h), controlPoint1:CGPoint(x: minX + 0.83391 * w, y: minY + 0.84924 * h), controlPoint2:CGPoint(x: minX + 0.83391 * w, y: minY + 0.84233 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.87391 * w, y: minY + 0.79809 * h), controlPoint1:CGPoint(x: minX + 0.85077 * w, y: minY + 0.82546 * h), controlPoint2:CGPoint(x: minX + 0.86279 * w, y: minY + 0.81201 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.88925 * w, y: minY + 0.79637 * h), controlPoint1:CGPoint(x: minX + 0.87767 * w, y: minY + 0.79337 * h), controlPoint2:CGPoint(x: minX + 0.88454 * w, y: minY + 0.79261 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.89097 * w, y: minY + 0.81171 * h), controlPoint1:CGPoint(x: minX + 0.89396 * w, y: minY + 0.80013 * h), controlPoint2:CGPoint(x: minX + 0.89473 * w, y: minY + 0.807 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.85361 * w, y: minY + 0.8535 * h), controlPoint1:CGPoint(x: minX + 0.87935 * w, y: minY + 0.82627 * h), controlPoint2:CGPoint(x: minX + 0.86678 * w, y: minY + 0.84033 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.84589 * w, y: minY + 0.8567 * h), controlPoint1:CGPoint(x: minX + 0.85148 * w, y: minY + 0.85563 * h), controlPoint2:CGPoint(x: minX + 0.84868 * w, y: minY + 0.8567 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.11782 * w, y: minY + 0.81613 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.10929 * w, y: minY + 0.81203 * h), controlPoint1:CGPoint(x: minX + 0.11462 * w, y: minY + 0.81613 * h), controlPoint2:CGPoint(x: minX + 0.11145 * w, y: minY + 0.81473 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.07679 * w, y: minY + 0.76638 * h), controlPoint1:CGPoint(x: minX + 0.09765 * w, y: minY + 0.79748 * h), controlPoint2:CGPoint(x: minX + 0.08672 * w, y: minY + 0.78212 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.0802 * w, y: minY + 0.75132 * h), controlPoint1:CGPoint(x: minX + 0.07357 * w, y: minY + 0.76128 * h), controlPoint2:CGPoint(x: minX + 0.0751 * w, y: minY + 0.75453 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.09525 * w, y: minY + 0.75473 * h), controlPoint1:CGPoint(x: minX + 0.0853 * w, y: minY + 0.7481 * h), controlPoint2:CGPoint(x: minX + 0.09204 * w, y: minY + 0.74963 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.12634 * w, y: minY + 0.7984 * h), controlPoint1:CGPoint(x: minX + 0.10476 * w, y: minY + 0.76979 * h), controlPoint2:CGPoint(x: minX + 0.11521 * w, y: minY + 0.78448 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.12463 * w, y: minY + 0.81374 * h), controlPoint1:CGPoint(x: minX + 0.13011 * w, y: minY + 0.80311 * h), controlPoint2:CGPoint(x: minX + 0.12934 * w, y: minY + 0.80998 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.11782 * w, y: minY + 0.81613 * h), controlPoint1:CGPoint(x: minX + 0.12263 * w, y: minY + 0.81535 * h), controlPoint2:CGPoint(x: minX + 0.12021 * w, y: minY + 0.81613 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.9142 * w, y: minY + 0.77111 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.90839 * w, y: minY + 0.76943 * h), controlPoint1:CGPoint(x: minX + 0.91221 * w, y: minY + 0.77111 * h), controlPoint2:CGPoint(x: minX + 0.9102 * w, y: minY + 0.77057 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.90497 * w, y: minY + 0.75437 * h), controlPoint1:CGPoint(x: minX + 0.90329 * w, y: minY + 0.76622 * h), controlPoint2:CGPoint(x: minX + 0.90176 * w, y: minY + 0.75948 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.93094 * w, y: minY + 0.70746 * h), controlPoint1:CGPoint(x: minX + 0.91447 * w, y: minY + 0.73929 * h), controlPoint2:CGPoint(x: minX + 0.92321 * w, y: minY + 0.7235 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.94552 * w, y: minY + 0.70237 * h), controlPoint1:CGPoint(x: minX + 0.93357 * w, y: minY + 0.70204 * h), controlPoint2:CGPoint(x: minX + 0.94009 * w, y: minY + 0.69976 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.95061 * w, y: minY + 0.71695 * h), controlPoint1:CGPoint(x: minX + 0.95095 * w, y: minY + 0.70499 * h), controlPoint2:CGPoint(x: minX + 0.95323 * w, y: minY + 0.71152 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.92345 * w, y: minY + 0.76601 * h), controlPoint1:CGPoint(x: minX + 0.94252 * w, y: minY + 0.73372 * h), controlPoint2:CGPoint(x: minX + 0.93338 * w, y: minY + 0.75023 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.9142 * w, y: minY + 0.77111 * h), controlPoint1:CGPoint(x: minX + 0.92137 * w, y: minY + 0.7693 * h), controlPoint2:CGPoint(x: minX + 0.91782 * w, y: minY + 0.77111 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.05943 * w, y: minY + 0.72354 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.0496 * w, y: minY + 0.71738 * h), controlPoint1:CGPoint(x: minX + 0.05538 * w, y: minY + 0.72354 * h), controlPoint2:CGPoint(x: minX + 0.05148 * w, y: minY + 0.72127 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02808 * w, y: minY + 0.6656 * h), controlPoint1:CGPoint(x: minX + 0.04149 * w, y: minY + 0.70059 * h), controlPoint2:CGPoint(x: minX + 0.03425 * w, y: minY + 0.68318 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.03477 * w, y: minY + 0.65169 * h), controlPoint1:CGPoint(x: minX + 0.02608 * w, y: minY + 0.65991 * h), controlPoint2:CGPoint(x: minX + 0.02907 * w, y: minY + 0.65368 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.04868 * w, y: minY + 0.65837 * h), controlPoint1:CGPoint(x: minX + 0.04046 * w, y: minY + 0.64969 * h), controlPoint2:CGPoint(x: minX + 0.04669 * w, y: minY + 0.65268 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.06925 * w, y: minY + 0.70787 * h), controlPoint1:CGPoint(x: minX + 0.05458 * w, y: minY + 0.67517 * h), controlPoint2:CGPoint(x: minX + 0.0615 * w, y: minY + 0.69183 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.06418 * w, y: minY + 0.72245 * h), controlPoint1:CGPoint(x: minX + 0.07188 * w, y: minY + 0.7133 * h), controlPoint2:CGPoint(x: minX + 0.06961 * w, y: minY + 0.71983 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.05943 * w, y: minY + 0.72354 * h), controlPoint1:CGPoint(x: minX + 0.06265 * w, y: minY + 0.72319 * h), controlPoint2:CGPoint(x: minX + 0.06103 * w, y: minY + 0.72354 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.96178 * w, y: minY + 0.67245 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.95818 * w, y: minY + 0.67184 * h), controlPoint1:CGPoint(x: minX + 0.96059 * w, y: minY + 0.67245 * h), controlPoint2:CGPoint(x: minX + 0.95937 * w, y: minY + 0.67225 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.95148 * w, y: minY + 0.65793 * h), controlPoint1:CGPoint(x: minX + 0.95249 * w, y: minY + 0.66985 * h), controlPoint2:CGPoint(x: minX + 0.94949 * w, y: minY + 0.66362 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.96629 * w, y: minY + 0.60639 * h), controlPoint1:CGPoint(x: minX + 0.95736 * w, y: minY + 0.64111 * h), controlPoint2:CGPoint(x: minX + 0.96235 * w, y: minY + 0.62377 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.97936 * w, y: minY + 0.59817 * h), controlPoint1:CGPoint(x: minX + 0.96763 * w, y: minY + 0.60051 * h), controlPoint2:CGPoint(x: minX + 0.97349 * w, y: minY + 0.59683 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98759 * w, y: minY + 0.61123 * h), controlPoint1:CGPoint(x: minX + 0.98524 * w, y: minY + 0.5995 * h), controlPoint2:CGPoint(x: minX + 0.98892 * w, y: minY + 0.60535 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.97209 * w, y: minY + 0.66514 * h), controlPoint1:CGPoint(x: minX + 0.98345 * w, y: minY + 0.62941 * h), controlPoint2:CGPoint(x: minX + 0.97824 * w, y: minY + 0.64754 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.96178 * w, y: minY + 0.67245 * h), controlPoint1:CGPoint(x: minX + 0.97051 * w, y: minY + 0.66963 * h), controlPoint2:CGPoint(x: minX + 0.9663 * w, y: minY + 0.67245 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.02317 * w, y: minY + 0.62022 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.01253 * w, y: minY + 0.61173 * h), controlPoint1:CGPoint(x: minX + 0.01818 * w, y: minY + 0.62022 * h), controlPoint2:CGPoint(x: minX + 0.01369 * w, y: minY + 0.61679 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.00315 * w, y: minY + 0.55646 * h), controlPoint1:CGPoint(x: minX + 0.00839 * w, y: minY + 0.5936 * h), controlPoint2:CGPoint(x: minX + 0.00524 * w, y: minY + 0.57501 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.01278 * w, y: minY + 0.5444 * h), controlPoint1:CGPoint(x: minX + 0.00248 * w, y: minY + 0.55047 * h), controlPoint2:CGPoint(x: minX + 0.00679 * w, y: minY + 0.54507 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02485 * w, y: minY + 0.55402 * h), controlPoint1:CGPoint(x: minX + 0.01876 * w, y: minY + 0.54372 * h), controlPoint2:CGPoint(x: minX + 0.02418 * w, y: minY + 0.54803 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.03382 * w, y: minY + 0.60687 * h), controlPoint1:CGPoint(x: minX + 0.02684 * w, y: minY + 0.57175 * h), controlPoint2:CGPoint(x: minX + 0.02986 * w, y: minY + 0.58953 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.0256 * w, y: minY + 0.61994 * h), controlPoint1:CGPoint(x: minX + 0.03516 * w, y: minY + 0.61275 * h), controlPoint2:CGPoint(x: minX + 0.03148 * w, y: minY + 0.6186 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02317 * w, y: minY + 0.62022 * h), controlPoint1:CGPoint(x: minX + 0.02479 * w, y: minY + 0.62013 * h), controlPoint2:CGPoint(x: minX + 0.02397 * w, y: minY + 0.62022 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.98607 * w, y: minY + 0.56566 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98485 * w, y: minY + 0.56559 * h), controlPoint1:CGPoint(x: minX + 0.98566 * w, y: minY + 0.56566 * h), controlPoint2:CGPoint(x: minX + 0.98526 * w, y: minY + 0.56564 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.97521 * w, y: minY + 0.55353 * h), controlPoint1:CGPoint(x: minX + 0.97886 * w, y: minY + 0.56493 * h), controlPoint2:CGPoint(x: minX + 0.97454 * w, y: minY + 0.55953 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.97817 * w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.97717 * w, y: minY + 0.53589 * h), controlPoint2:CGPoint(x: minX + 0.97817 * w, y: minY + 0.51788 * h))
        CirclePath.addLine(to: CGPoint(x: minX + 0.97817 * w, y: minY + 0.49899 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98908 * w, y: minY + 0.48807 * h), controlPoint1:CGPoint(x: minX + 0.97817 * w, y: minY + 0.49296 * h), controlPoint2:CGPoint(x: minX + 0.98306 * w, y: minY + 0.48807 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.49899 * h), controlPoint1:CGPoint(x: minX + 0.99511 * w, y: minY + 0.48807 * h), controlPoint2:CGPoint(x: minX + w, y: minY + 0.49296 * h))
        CirclePath.addLine(to: CGPoint(x: minX + w, y: minY + 0.5 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.9969 * w, y: minY + 0.55595 * h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.51868 * h), controlPoint2:CGPoint(x: minX + 0.99896 * w, y: minY + 0.53751 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98607 * w, y: minY + 0.56566 * h), controlPoint1:CGPoint(x: minX + 0.99628 * w, y: minY + 0.56153 * h), controlPoint2:CGPoint(x: minX + 0.99156 * w, y: minY + 0.56566 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.01092 * w, y: minY + 0.51142 * h))
        CirclePath.addCurve(to: CGPoint(x: minX, y: minY + 0.5005 * h), controlPoint1:CGPoint(x: minX + 0.00489 * w, y: minY + 0.51142 * h), controlPoint2:CGPoint(x: minX, y: minY + 0.50654 * h))
        CirclePath.addLine(to: CGPoint(x: minX, y: minY + 0.5 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.00304 * w, y: minY + 0.44456 * h), controlPoint1:CGPoint(x: minX, y: minY + 0.48149 * h), controlPoint2:CGPoint(x: minX + 0.00102 * w, y: minY + 0.46284 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.01509 * w, y: minY + 0.43491 * h), controlPoint1:CGPoint(x: minX + 0.0037 * w, y: minY + 0.43857 * h), controlPoint2:CGPoint(x: minX + 0.00909 * w, y: minY + 0.43426 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02474 * w, y: minY + 0.44696 * h), controlPoint1:CGPoint(x: minX + 0.02108 * w, y: minY + 0.43557 * h), controlPoint2:CGPoint(x: minX + 0.0254 * w, y: minY + 0.44096 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02183 * w, y: minY + 0.5 * h), controlPoint1:CGPoint(x: minX + 0.02281 * w, y: minY + 0.46445 * h), controlPoint2:CGPoint(x: minX + 0.02183 * w, y: minY + 0.48229 * h))
        CirclePath.addLine(to: CGPoint(x: minX + 0.02183 * w, y: minY + 0.5005 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.01092 * w, y: minY + 0.51142 * h), controlPoint1:CGPoint(x: minX + 0.02183 * w, y: minY + 0.50653 * h), controlPoint2:CGPoint(x: minX + 0.01695 * w, y: minY + 0.51142 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.98593 * w, y: minY + 0.45517 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.9751 * w, y: minY + 0.44548 * h), controlPoint1:CGPoint(x: minX + 0.98045 * w, y: minY + 0.45517 * h), controlPoint2:CGPoint(x: minX + 0.97573 * w, y: minY + 0.45105 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.96607 * w, y: minY + 0.39264 * h), controlPoint1:CGPoint(x: minX + 0.97309 * w, y: minY + 0.42776 * h), controlPoint2:CGPoint(x: minX + 0.97005 * w, y: minY + 0.40998 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.97427 * w, y: minY + 0.37956 * h), controlPoint1:CGPoint(x: minX + 0.96473 * w, y: minY + 0.38677 * h), controlPoint2:CGPoint(x: minX + 0.9684 * w, y: minY + 0.38091 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98736 * w, y: minY + 0.38776 * h), controlPoint1:CGPoint(x: minX + 0.98015 * w, y: minY + 0.37822 * h), controlPoint2:CGPoint(x: minX + 0.98601 * w, y: minY + 0.38189 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.99679 * w, y: minY + 0.44302 * h), controlPoint1:CGPoint(x: minX + 0.99151 * w, y: minY + 0.40589 * h), controlPoint2:CGPoint(x: minX + 0.99469 * w, y: minY + 0.42448 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98718 * w, y: minY + 0.4551 * h), controlPoint1:CGPoint(x: minX + 0.99747 * w, y: minY + 0.44901 * h), controlPoint2:CGPoint(x: minX + 0.99317 * w, y: minY + 0.45442 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.98593 * w, y: minY + 0.45517 * h), controlPoint1:CGPoint(x: minX + 0.98676 * w, y: minY + 0.45515 * h), controlPoint2:CGPoint(x: minX + 0.98634 * w, y: minY + 0.45517 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.02296 * w, y: minY + 0.4026 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02054 * w, y: minY + 0.40233 * h), controlPoint1:CGPoint(x: minX + 0.02216 * w, y: minY + 0.4026 * h), controlPoint2:CGPoint(x: minX + 0.02136 * w, y: minY + 0.40251 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.0123 * w, y: minY + 0.38928 * h), controlPoint1:CGPoint(x: minX + 0.01466 * w, y: minY + 0.401 * h), controlPoint2:CGPoint(x: minX + 0.01097 * w, y: minY + 0.39516 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02775 * w, y: minY + 0.33535 * h), controlPoint1:CGPoint(x: minX + 0.01641 * w, y: minY + 0.3711 * h), controlPoint2:CGPoint(x: minX + 0.02161 * w, y: minY + 0.35296 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.04165 * w, y: minY + 0.32864 * h), controlPoint1:CGPoint(x: minX + 0.02973 * w, y: minY + 0.32966 * h), controlPoint2:CGPoint(x: minX + 0.03595 * w, y: minY + 0.32666 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.04836 * w, y: minY + 0.34254 * h), controlPoint1:CGPoint(x: minX + 0.04734 * w, y: minY + 0.33062 * h), controlPoint2:CGPoint(x: minX + 0.05035 * w, y: minY + 0.33685 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.0336 * w, y: minY + 0.39409 * h), controlPoint1:CGPoint(x: minX + 0.04249 * w, y: minY + 0.35937 * h), controlPoint2:CGPoint(x: minX + 0.03753 * w, y: minY + 0.37671 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.02296 * w, y: minY + 0.4026 * h), controlPoint1:CGPoint(x: minX + 0.03246 * w, y: minY + 0.39916 * h), controlPoint2:CGPoint(x: minX + 0.02795 * w, y: minY + 0.4026 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.96146 * w, y: minY + 0.34845 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.95116 * w, y: minY + 0.34116 * h), controlPoint1:CGPoint(x: minX + 0.95696 * w, y: minY + 0.34845 * h), controlPoint2:CGPoint(x: minX + 0.95274 * w, y: minY + 0.34565 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.93054 * w, y: minY + 0.29168 * h), controlPoint1:CGPoint(x: minX + 0.94524 * w, y: minY + 0.32436 * h), controlPoint2:CGPoint(x: minX + 0.93831 * w, y: minY + 0.30771 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.93559 * w, y: minY + 0.2771 * h), controlPoint1:CGPoint(x: minX + 0.9279 * w, y: minY + 0.28626 * h), controlPoint2:CGPoint(x: minX + 0.93017 * w, y: minY + 0.27973 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.95018 * w, y: minY + 0.28216 * h), controlPoint1:CGPoint(x: minX + 0.94103 * w, y: minY + 0.27447 * h), controlPoint2:CGPoint(x: minX + 0.94755 * w, y: minY + 0.27673 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.97176 * w, y: minY + 0.33391 * h), controlPoint1:CGPoint(x: minX + 0.95831 * w, y: minY + 0.29892 * h), controlPoint2:CGPoint(x: minX + 0.96557 * w, y: minY + 0.31633 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.96509 * w, y: minY + 0.34783 * h), controlPoint1:CGPoint(x: minX + 0.97376 * w, y: minY + 0.33959 * h), controlPoint2:CGPoint(x: minX + 0.97077 * w, y: minY + 0.34583 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.96146 * w, y: minY + 0.34845 * h), controlPoint1:CGPoint(x: minX + 0.96389 * w, y: minY + 0.34825 * h), controlPoint2:CGPoint(x: minX + 0.96266 * w, y: minY + 0.34845 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.059 * w, y: minY + 0.29917 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.05427 * w, y: minY + 0.29809 * h), controlPoint1:CGPoint(x: minX + 0.05741 * w, y: minY + 0.29917 * h), controlPoint2:CGPoint(x: minX + 0.0558 * w, y: minY + 0.29882 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.04917 * w, y: minY + 0.28352 * h), controlPoint1:CGPoint(x: minX + 0.04884 * w, y: minY + 0.29547 * h), controlPoint2:CGPoint(x: minX + 0.04656 * w, y: minY + 0.28895 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.07628 * w, y: minY + 0.23443 * h), controlPoint1:CGPoint(x: minX + 0.05724 * w, y: minY + 0.26673 * h), controlPoint2:CGPoint(x: minX + 0.06637 * w, y: minY + 0.25022 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.09133 * w, y: minY + 0.23099 * h), controlPoint1:CGPoint(x: minX + 0.07949 * w, y: minY + 0.22932 * h), controlPoint2:CGPoint(x: minX + 0.08623 * w, y: minY + 0.22778 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.09477 * w, y: minY + 0.24604 * h), controlPoint1:CGPoint(x: minX + 0.09644 * w, y: minY + 0.2342 * h), controlPoint2:CGPoint(x: minX + 0.09798 * w, y: minY + 0.24094 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.06885 * w, y: minY + 0.29298 * h), controlPoint1:CGPoint(x: minX + 0.08529 * w, y: minY + 0.26114 * h), controlPoint2:CGPoint(x: minX + 0.07657 * w, y: minY + 0.27694 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.059 * w, y: minY + 0.29917 * h), controlPoint1:CGPoint(x: minX + 0.06697 * w, y: minY + 0.29689 * h), controlPoint2:CGPoint(x: minX + 0.06306 * w, y: minY + 0.29917 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.91372 * w, y: minY + 0.24994 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.90448 * w, y: minY + 0.24485 * h), controlPoint1:CGPoint(x: minX + 0.9101 * w, y: minY + 0.24994 * h), controlPoint2:CGPoint(x: minX + 0.90656 * w, y: minY + 0.24814 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.87335 * w, y: minY + 0.20122 * h), controlPoint1:CGPoint(x: minX + 0.89497 * w, y: minY + 0.2298 * h), controlPoint2:CGPoint(x: minX + 0.88449 * w, y: minY + 0.21512 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.87504 * w, y: minY + 0.18587 * h), controlPoint1:CGPoint(x: minX + 0.86958 * w, y: minY + 0.19651 * h), controlPoint2:CGPoint(x: minX + 0.87034 * w, y: minY + 0.18964 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.89039 * w, y: minY + 0.18756 * h), controlPoint1:CGPoint(x: minX + 0.87974 * w, y: minY + 0.1821 * h), controlPoint2:CGPoint(x: minX + 0.88661 * w, y: minY + 0.18285 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.92294 * w, y: minY + 0.23318 * h), controlPoint1:CGPoint(x: minX + 0.90204 * w, y: minY + 0.2021 * h), controlPoint2:CGPoint(x: minX + 0.91299 * w, y: minY + 0.21745 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.91954 * w, y: minY + 0.24825 * h), controlPoint1:CGPoint(x: minX + 0.92616 * w, y: minY + 0.23828 * h), controlPoint2:CGPoint(x: minX + 0.92464 * w, y: minY + 0.24502 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.91372 * w, y: minY + 0.24994 * h), controlPoint1:CGPoint(x: minX + 0.91774 * w, y: minY + 0.24939 * h), controlPoint2:CGPoint(x: minX + 0.91572 * w, y: minY + 0.24994 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.11724 * w, y: minY + 0.20641 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.11045 * w, y: minY + 0.20403 * h), controlPoint1:CGPoint(x: minX + 0.11486 * w, y: minY + 0.20641 * h), controlPoint2:CGPoint(x: minX + 0.11246 * w, y: minY + 0.20563 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.10871 * w, y: minY + 0.18869 * h), controlPoint1:CGPoint(x: minX + 0.10573 * w, y: minY + 0.20028 * h), controlPoint2:CGPoint(x: minX + 0.10495 * w, y: minY + 0.19341 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.14603 * w, y: minY + 0.14686 * h), controlPoint1:CGPoint(x: minX + 0.12031 * w, y: minY + 0.17413 * h), controlPoint2:CGPoint(x: minX + 0.13287 * w, y: minY + 0.16005 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.16146 * w, y: minY + 0.14684 * h), controlPoint1:CGPoint(x: minX + 0.15028 * w, y: minY + 0.14259 * h), controlPoint2:CGPoint(x: minX + 0.1572 * w, y: minY + 0.14259 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.16148 * w, y: minY + 0.16228 * h), controlPoint1:CGPoint(x: minX + 0.16573 * w, y: minY + 0.1511 * h), controlPoint2:CGPoint(x: minX + 0.16574 * w, y: minY + 0.15802 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.12579 * w, y: minY + 0.2023 * h), controlPoint1:CGPoint(x: minX + 0.14889 * w, y: minY + 0.1749 * h), controlPoint2:CGPoint(x: minX + 0.13688 * w, y: minY + 0.18837 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.11724 * w, y: minY + 0.20641 * h), controlPoint1:CGPoint(x: minX + 0.12363 * w, y: minY + 0.205 * h), controlPoint2:CGPoint(x: minX + 0.12045 * w, y: minY + 0.20641 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.84525 * w, y: minY + 0.16449 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.83754 * w, y: minY + 0.16131 * h), controlPoint1:CGPoint(x: minX + 0.84246 * w, y: minY + 0.16449 * h), controlPoint2:CGPoint(x: minX + 0.83967 * w, y: minY + 0.16343 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.79751 * w, y: minY + 0.12563 * h), controlPoint1:CGPoint(x: minX + 0.82492 * w, y: minY + 0.14873 * h), controlPoint2:CGPoint(x: minX + 0.81145 * w, y: minY + 0.13672 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.79577 * w, y: minY + 0.11029 * h), controlPoint1:CGPoint(x: minX + 0.79279 * w, y: minY + 0.12188 * h), controlPoint2:CGPoint(x: minX + 0.79201 * w, y: minY + 0.11501 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.81111 * w, y: minY + 0.10855 * h), controlPoint1:CGPoint(x: minX + 0.79952 * w, y: minY + 0.10557 * h), controlPoint2:CGPoint(x: minX + 0.80639 * w, y: minY + 0.10479 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.85296 * w, y: minY + 0.14585 * h), controlPoint1:CGPoint(x: minX + 0.82568 * w, y: minY + 0.12014 * h), controlPoint2:CGPoint(x: minX + 0.83976 * w, y: minY + 0.13269 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.85298 * w, y: minY + 0.16128 * h), controlPoint1:CGPoint(x: minX + 0.85723 * w, y: minY + 0.1501 * h), controlPoint2:CGPoint(x: minX + 0.85724 * w, y: minY + 0.15701 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.84525 * w, y: minY + 0.16449 * h), controlPoint1:CGPoint(x: minX + 0.85085 * w, y: minY + 0.16343 * h), controlPoint2:CGPoint(x: minX + 0.84805 * w, y: minY + 0.16449 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.19459 * w, y: minY + 0.12889 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.18606 * w, y: minY + 0.1248 * h), controlPoint1:CGPoint(x: minX + 0.19139 * w, y: minY + 0.12889 * h), controlPoint2:CGPoint(x: minX + 0.18822 * w, y: minY + 0.12749 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.18776 * w, y: minY + 0.10945 * h), controlPoint1:CGPoint(x: minX + 0.1823 * w, y: minY + 0.12009 * h), controlPoint2:CGPoint(x: minX + 0.18306 * w, y: minY + 0.11322 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.2334 * w, y: minY + 0.07693 * h), controlPoint1:CGPoint(x: minX + 0.20231 * w, y: minY + 0.09781 * h), controlPoint2:CGPoint(x: minX + 0.21766 * w, y: minY + 0.08687 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.24846 * w, y: minY + 0.08033 * h), controlPoint1:CGPoint(x: minX + 0.2385 * w, y: minY + 0.07371 * h), controlPoint2:CGPoint(x: minX + 0.24524 * w, y: minY + 0.07523 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.24506 * w, y: minY + 0.09539 * h), controlPoint1:CGPoint(x: minX + 0.25168 * w, y: minY + 0.08543 * h), controlPoint2:CGPoint(x: minX + 0.25016 * w, y: minY + 0.09217 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.20141 * w, y: minY + 0.1265 * h), controlPoint1:CGPoint(x: minX + 0.23 * w, y: minY + 0.1049 * h), controlPoint2:CGPoint(x: minX + 0.21532 * w, y: minY + 0.11537 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.19459 * w, y: minY + 0.12889 * h), controlPoint1:CGPoint(x: minX + 0.1994 * w, y: minY + 0.12811 * h), controlPoint2:CGPoint(x: minX + 0.19699 * w, y: minY + 0.12889 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.75954 * w, y: minY + 0.09631 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.75375 * w, y: minY + 0.09464 * h), controlPoint1:CGPoint(x: minX + 0.75756 * w, y: minY + 0.09631 * h), controlPoint2:CGPoint(x: minX + 0.75555 * w, y: minY + 0.09577 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.7068 * w, y: minY + 0.06873 * h), controlPoint1:CGPoint(x: minX + 0.73864 * w, y: minY + 0.08516 * h), controlPoint2:CGPoint(x: minX + 0.72284 * w, y: minY + 0.07644 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.70168 * w, y: minY + 0.05417 * h), controlPoint1:CGPoint(x: minX + 0.70136 * w, y: minY + 0.06612 * h), controlPoint2:CGPoint(x: minX + 0.69907 * w, y: minY + 0.0596 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.71625 * w, y: minY + 0.04905 * h), controlPoint1:CGPoint(x: minX + 0.7043 * w, y: minY + 0.04873 * h), controlPoint2:CGPoint(x: minX + 0.71082 * w, y: minY + 0.04644 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.76536 * w, y: minY + 0.07614 * h), controlPoint1:CGPoint(x: minX + 0.73303 * w, y: minY + 0.05711 * h), controlPoint2:CGPoint(x: minX + 0.74955 * w, y: minY + 0.06623 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.7688 * w, y: minY + 0.09119 * h), controlPoint1:CGPoint(x: minX + 0.77046 * w, y: minY + 0.07934 * h), controlPoint2:CGPoint(x: minX + 0.772 * w, y: minY + 0.08608 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.75954 * w, y: minY + 0.09631 * h), controlPoint1:CGPoint(x: minX + 0.76673 * w, y: minY + 0.09449 * h), controlPoint2:CGPoint(x: minX + 0.76318 * w, y: minY + 0.09631 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.28716 * w, y: minY + 0.07046 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.27733 * w, y: minY + 0.06429 * h), controlPoint1:CGPoint(x: minX + 0.2831 * w, y: minY + 0.07046 * h), controlPoint2:CGPoint(x: minX + 0.27921 * w, y: minY + 0.06819 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.2824 * w, y: minY + 0.04971 * h), controlPoint1:CGPoint(x: minX + 0.2747 * w, y: minY + 0.05887 * h), controlPoint2:CGPoint(x: minX + 0.27697 * w, y: minY + 0.05234 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.33416 * w, y: minY + 0.02816 * h), controlPoint1:CGPoint(x: minX + 0.29918 * w, y: minY + 0.04159 * h), controlPoint2:CGPoint(x: minX + 0.31659 * w, y: minY + 0.03434 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.34808 * w, y: minY + 0.03484 * h), controlPoint1:CGPoint(x: minX + 0.33985 * w, y: minY + 0.02617 * h), controlPoint2:CGPoint(x: minX + 0.34608 * w, y: minY + 0.02916 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.3414 * w, y: minY + 0.04876 * h), controlPoint1:CGPoint(x: minX + 0.35007 * w, y: minY + 0.04053 * h), controlPoint2:CGPoint(x: minX + 0.34708 * w, y: minY + 0.04676 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.29191 * w, y: minY + 0.06936 * h), controlPoint1:CGPoint(x: minX + 0.3246 * w, y: minY + 0.05466 * h), controlPoint2:CGPoint(x: minX + 0.30796 * w, y: minY + 0.06159 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.28716 * w, y: minY + 0.07046 * h), controlPoint1:CGPoint(x: minX + 0.29038 * w, y: minY + 0.07011 * h), controlPoint2:CGPoint(x: minX + 0.28875 * w, y: minY + 0.07046 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.66082 * w, y: minY + 0.04889 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.65723 * w, y: minY + 0.04828 * h), controlPoint1:CGPoint(x: minX + 0.65963 * w, y: minY + 0.04889 * h), controlPoint2:CGPoint(x: minX + 0.65842 * w, y: minY + 0.04869 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.60567 * w, y: minY + 0.03354 * h), controlPoint1:CGPoint(x: minX + 0.6404 * w, y: minY + 0.04242 * h), controlPoint2:CGPoint(x: minX + 0.62306 * w, y: minY + 0.03746 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.59742 * w, y: minY + 0.02049 * h), controlPoint1:CGPoint(x: minX + 0.59979 * w, y: minY + 0.03222 * h), controlPoint2:CGPoint(x: minX + 0.59609 * w, y: minY + 0.02637 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.61047 * w, y: minY + 0.01225 * h), controlPoint1:CGPoint(x: minX + 0.59875 * w, y: minY + 0.01461 * h), controlPoint2:CGPoint(x: minX + 0.60458 * w, y: minY + 0.01091 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.6644 * w, y: minY + 0.02766 * h), controlPoint1:CGPoint(x: minX + 0.62866 * w, y: minY + 0.01634 * h), controlPoint2:CGPoint(x: minX + 0.6468 * w, y: minY + 0.02153 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.67113 * w, y: minY + 0.04156 * h), controlPoint1:CGPoint(x: minX + 0.6701 * w, y: minY + 0.02964 * h), controlPoint2:CGPoint(x: minX + 0.67311 * w, y: minY + 0.03586 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.66082 * w, y: minY + 0.04889 * h), controlPoint1:CGPoint(x: minX + 0.66956 * w, y: minY + 0.04606 * h), controlPoint2:CGPoint(x: minX + 0.66534 * w, y: minY + 0.04889 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.39044 * w, y: minY + 0.03415 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.37981 * w, y: minY + 0.02567 * h), controlPoint1:CGPoint(x: minX + 0.38546 * w, y: minY + 0.03415 * h), controlPoint2:CGPoint(x: minX + 0.38097 * w, y: minY + 0.03073 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.38802 * w, y: minY + 0.01259 * h), controlPoint1:CGPoint(x: minX + 0.37846 * w, y: minY + 0.01979 * h), controlPoint2:CGPoint(x: minX + 0.38214 * w, y: minY + 0.01393 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.44328 * w, y: minY + 0.00318 * h), controlPoint1:CGPoint(x: minX + 0.40615 * w, y: minY + 0.00844 * h), controlPoint2:CGPoint(x: minX + 0.42474 * w, y: minY + 0.00528 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.45535 * w, y: minY + 0.0128 * h), controlPoint1:CGPoint(x: minX + 0.44927 * w, y: minY + 0.00251 * h), controlPoint2:CGPoint(x: minX + 0.45468 * w, y: minY + 0.00681 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.44573 * w, y: minY + 0.02488 * h), controlPoint1:CGPoint(x: minX + 0.45603 * w, y: minY + 0.01879 * h), controlPoint2:CGPoint(x: minX + 0.45172 * w, y: minY + 0.0242 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.39289 * w, y: minY + 0.03387 * h), controlPoint1:CGPoint(x: minX + 0.42801 * w, y: minY + 0.02688 * h), controlPoint2:CGPoint(x: minX + 0.41023 * w, y: minY + 0.02991 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.39044 * w, y: minY + 0.03415 * h), controlPoint1:CGPoint(x: minX + 0.39207 * w, y: minY + 0.03406 * h), controlPoint2:CGPoint(x: minX + 0.39125 * w, y: minY + 0.03415 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.554 * w, y: minY + 0.02478 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.5528 * w, y: minY + 0.02471 * h), controlPoint1:CGPoint(x: minX + 0.55361 * w, y: minY + 0.02478 * h), controlPoint2:CGPoint(x: minX + 0.5532 * w, y: minY + 0.02476 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.5 * w, y: minY + 0.02183 * h), controlPoint1:CGPoint(x: minX + 0.53539 * w, y: minY + 0.0228 * h), controlPoint2:CGPoint(x: minX + 0.51763 * w, y: minY + 0.02183 * h))
        CirclePath.addLine(to: CGPoint(x: minX + 0.49924 * w, y: minY + 0.02183 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.48833 * w, y: minY + 0.01092 * h), controlPoint1:CGPoint(x: minX + 0.49321 * w, y: minY + 0.02183 * h), controlPoint2:CGPoint(x: minX + 0.48833 * w, y: minY + 0.01694 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.49924 * w, y: minY), controlPoint1:CGPoint(x: minX + 0.48833 * w, y: minY + 0.00489 * h), controlPoint2:CGPoint(x: minX + 0.49321 * w, y: minY))
        CirclePath.addLine(to: CGPoint(x: minX + 0.5 * w, y: minY))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.55518 * w, y: minY + 0.00301 * h), controlPoint1:CGPoint(x: minX + 0.51842 * w, y: minY), controlPoint2:CGPoint(x: minX + 0.53699 * w, y: minY + 0.00101 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.56484 * w, y: minY + 0.01505 * h), controlPoint1:CGPoint(x: minX + 0.56117 * w, y: minY + 0.00367 * h), controlPoint2:CGPoint(x: minX + 0.5655 * w, y: minY + 0.00906 * h))
        CirclePath.addCurve(to: CGPoint(x: minX + 0.554 * w, y: minY + 0.02478 * h), controlPoint1:CGPoint(x: minX + 0.56423 * w, y: minY + 0.02064 * h), controlPoint2:CGPoint(x: minX + 0.5595 * w, y: minY + 0.02478 * h))
        CirclePath.close()
        CirclePath.move(to: CGPoint(x: minX + 0.554 * w, y: minY + 0.02478 * h))
        
        return CirclePath;
    }
    
    func DownPathWithBounds(_ bound: CGRect) -> UIBezierPath{
        let DownPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        DownPath.move(to: CGPoint(x: minX + 0.30519 * w, y: minY + 0.41006 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.52151 * w, y: minY + 0.2496 * h), controlPoint1:CGPoint(x: minX + 0.38876 * w, y: minY + 0.41006 * h), controlPoint2:CGPoint(x: minX + 0.4602 * w, y: minY + 0.2496 * h))
        DownPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.2496 * h), controlPoint1:CGPoint(x: minX + 0.64153 * w, y: minY + 0.2496 * h), controlPoint2:CGPoint(x: minX + w, y: minY + 0.2496 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.54987 * w, y: minY + 0.05847 * h), controlPoint1:CGPoint(x: minX + 0.92995 * w, y: minY + 0.10411 * h), controlPoint2:CGPoint(x: minX + 0.70775 * w, y: minY + -0.10231 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.28801 * w, y: minY + 0.28459 * h), controlPoint1:CGPoint(x: minX + 0.38477 * w, y: minY + 0.22658 * h), controlPoint2:CGPoint(x: minX + 0.34936 * w, y: minY + 0.28739 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.05114 * w, y: minY + 0.34832 * h), controlPoint1:CGPoint(x: minX + 0.23537 * w, y: minY + 0.28217 * h), controlPoint2:CGPoint(x: minX + 0.1234 * w, y: minY + 0.18434 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.04061 * w, y: minY + 0.90508 * h), controlPoint1:CGPoint(x: minX + 0.01303 * w, y: minY + 0.43481 * h), controlPoint2:CGPoint(x: minX + -0.03646 * w, y: minY + 0.71025 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.22518 * w, y: minY + 0.86724 * h), controlPoint1:CGPoint(x: minX + 0.12078 * w, y: minY + 1.10775 * h), controlPoint2:CGPoint(x: minX + 0.20091 * w, y: minY + 0.93278 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.26344 * w, y: minY + 0.50094 * h), controlPoint1:CGPoint(x: minX + 0.27326 * w, y: minY + 0.73748 * h), controlPoint2:CGPoint(x: minX + 0.26721 * w, y: minY + 0.5738 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.30519 * w, y: minY + 0.41006 * h), controlPoint1:CGPoint(x: minX + 0.25967 * w, y: minY + 0.4281 * h), controlPoint2:CGPoint(x: minX + 0.2819 * w, y: minY + 0.41006 * h))
        DownPath.close()
        DownPath.move(to: CGPoint(x: minX + 0.15878 * w, y: minY + 0.87377 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.03745 * w, y: minY + 0.61932 * h), controlPoint1:CGPoint(x: minX + 0.09988 * w, y: minY + 0.95027 * h), controlPoint2:CGPoint(x: minX + 0.02894 * w, y: minY + 0.82161 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.15402 * w, y: minY + 0.35801 * h), controlPoint1:CGPoint(x: minX + 0.04565 * w, y: minY + 0.42423 * h), controlPoint2:CGPoint(x: minX + 0.12527 * w, y: minY + 0.35666 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.23528 * w, y: minY + 0.57534 * h), controlPoint1:CGPoint(x: minX + 0.18514 * w, y: minY + 0.35949 * h), controlPoint2:CGPoint(x: minX + 0.23283 * w, y: minY + 0.41638 * h))
        DownPath.addCurve(to: CGPoint(x: minX + 0.15878 * w, y: minY + 0.87377 * h), controlPoint1:CGPoint(x: minX + 0.23685 * w, y: minY + 0.67758 * h), controlPoint2:CGPoint(x: minX + 0.21557 * w, y: minY + 0.79999 * h))
        DownPath.close()
        DownPath.move(to: CGPoint(x: minX + 0.15878 * w, y: minY + 0.87377 * h))
        
        return DownPath;
    }
    
    func UpPathWithBounds(_ bound: CGRect) -> UIBezierPath{
        let UpPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        UpPath.move(to: CGPoint(x: minX + 0.26344 * w, y: minY + 0.49907 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.22519 * w, y: minY + 0.13276 * h), controlPoint1:CGPoint(x: minX + 0.26721 * w, y: minY + 0.4262 * h), controlPoint2:CGPoint(x: minX + 0.27326 * w, y: minY + 0.26252 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.04061 * w, y: minY + 0.09492 * h), controlPoint1:CGPoint(x: minX + 0.20091 * w, y: minY + 0.06722 * h), controlPoint2:CGPoint(x: minX + 0.12078 * w, y: minY + -0.10775 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.05114 * w, y: minY + 0.65168 * h), controlPoint1:CGPoint(x: minX + -0.03646 * w, y: minY + 0.28975 * h), controlPoint2:CGPoint(x: minX + 0.01303 * w, y: minY + 0.5652 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.28801 * w, y: minY + 0.71542 * h), controlPoint1:CGPoint(x: minX + 0.12341 * w, y: minY + 0.81567 * h), controlPoint2:CGPoint(x: minX + 0.23537 * w, y: minY + 0.71782 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.54987 * w, y: minY + 0.94153 * h), controlPoint1:CGPoint(x: minX + 0.34936 * w, y: minY + 0.7126 * h), controlPoint2:CGPoint(x: minX + 0.38478 * w, y: minY + 0.77341 * h))
        UpPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.7504 * h), controlPoint1:CGPoint(x: minX + 0.70775 * w, y: minY + 1.10231 * h), controlPoint2:CGPoint(x: minX + 0.92995 * w, y: minY + 0.89588 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.52151 * w, y: minY + 0.7504 * h), controlPoint1:CGPoint(x: minX + w, y: minY + 0.7504 * h), controlPoint2:CGPoint(x: minX + 0.64153 * w, y: minY + 0.7504 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.30519 * w, y: minY + 0.58994 * h), controlPoint1:CGPoint(x: minX + 0.4602 * w, y: minY + 0.7504 * h), controlPoint2:CGPoint(x: minX + 0.38876 * w, y: minY + 0.58994 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.26344 * w, y: minY + 0.49907 * h), controlPoint1:CGPoint(x: minX + 0.2819 * w, y: minY + 0.58996 * h), controlPoint2:CGPoint(x: minX + 0.25967 * w, y: minY + 0.57192 * h))
        UpPath.close()
        UpPath.move(to: CGPoint(x: minX + 0.23528 * w, y: minY + 0.42467 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.15402 * w, y: minY + 0.642 * h), controlPoint1:CGPoint(x: minX + 0.23283 * w, y: minY + 0.58363 * h), controlPoint2:CGPoint(x: minX + 0.18515 * w, y: minY + 0.64053 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.03745 * w, y: minY + 0.38069 * h), controlPoint1:CGPoint(x: minX + 0.12528 * w, y: minY + 0.64337 * h), controlPoint2:CGPoint(x: minX + 0.04566 * w, y: minY + 0.5758 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.15878 * w, y: minY + 0.12624 * h), controlPoint1:CGPoint(x: minX + 0.02894 * w, y: minY + 0.17841 * h), controlPoint2:CGPoint(x: minX + 0.09988 * w, y: minY + 0.04974 * h))
        UpPath.addCurve(to: CGPoint(x: minX + 0.23528 * w, y: minY + 0.42467 * h), controlPoint1:CGPoint(x: minX + 0.21557 * w, y: minY + 0.20002 * h), controlPoint2:CGPoint(x: minX + 0.23685 * w, y: minY + 0.32243 * h))
        UpPath.close()
        UpPath.move(to: CGPoint(x: minX + 0.23528 * w, y: minY + 0.42467 * h))
        
        return UpPath;
    }
    
}
