//
//  Layout.swift
//  VideoDownloader
//
//  Created by ちゅーたつ on 2018/12/19.
//  Copyright © 2018年 churabou. All rights reserved.
//

import UIKit

extension UIView {
    
    var chura: ChuraLayout {
        return ChuraLayout(self)
    }
}


final class ChuraLayout {
    
    private var target: UIView
    
    init (_ target: UIView) {
        self.target = target
    }
    
    var layout: LayoutMaker {
        return LayoutMaker(target)
    }
}


// left, right, centerX
protocol HorizontalConstraints {}
extension Int: HorizontalConstraints {}
extension CGFloat: HorizontalConstraints {}
extension UIView: HorizontalConstraints {}
extension NSLayoutXAxisAnchor: HorizontalConstraints {}
extension AnchorCalculable: HorizontalConstraints where T == NSLayoutXAxisAnchor {}


// top, bottom, centerY
protocol VerticalConstraints {}
extension Int: VerticalConstraints {}
extension CGFloat: VerticalConstraints {}
extension UIView: VerticalConstraints {}
extension NSLayoutYAxisAnchor: VerticalConstraints {}
extension AnchorCalculable: VerticalConstraints where T == NSLayoutYAxisAnchor {}


// width, height
protocol DimensionalConstraints {}
extension Int: DimensionalConstraints {}
extension CGFloat: DimensionalConstraints {}
extension UIView: DimensionalConstraints {}
extension NSLayoutDimension: DimensionalConstraints {}
extension AnchorCalculable: DimensionalConstraints where T == NSLayoutDimension {}


//LayoutAnchor + 10
class AnchorCalculable<T> {
    
    var target: T
    var constant: CGFloat
    var multiplier: CGFloat
    
    init(target: T, constant: CGFloat = 0, multiplier: CGFloat = 1) {
        self.target = target
        self.constant = constant
        self.multiplier = multiplier
    }
}


extension NSLayoutXAxisAnchor {
    
    static func +(lhd: NSLayoutXAxisAnchor, rhd: CGFloat) -> AnchorCalculable<NSLayoutXAxisAnchor> {
        return AnchorCalculable(target: lhd, constant: rhd)
    }
    
    static func -(lhd: NSLayoutXAxisAnchor, rhd: CGFloat) -> AnchorCalculable<NSLayoutXAxisAnchor> {
        return AnchorCalculable(target: lhd, constant: -rhd)
    }
}

extension NSLayoutYAxisAnchor {
    
    static func +(lhd: NSLayoutYAxisAnchor, rhd: CGFloat) -> AnchorCalculable<NSLayoutYAxisAnchor> {
        return AnchorCalculable(target: lhd, constant: rhd)
    }
    
    static func -(lhd: NSLayoutYAxisAnchor, rhd: CGFloat) -> AnchorCalculable<NSLayoutYAxisAnchor> {
        return AnchorCalculable(target: lhd, constant: -rhd)
    }
}

extension NSLayoutDimension {
    
    static func +(lhd: NSLayoutDimension, rhd: CGFloat) -> AnchorCalculable<NSLayoutDimension> {
        return AnchorCalculable(target: lhd, constant: rhd)
    }
    
    static func -(lhd: NSLayoutDimension, rhd: CGFloat) -> AnchorCalculable<NSLayoutDimension> {
        return AnchorCalculable(target: lhd, constant: -rhd)
    }
    
    static func *(lhd: NSLayoutDimension, rhd: CGFloat) -> AnchorCalculable<NSLayoutDimension> {
        return AnchorCalculable(target: lhd, multiplier: rhd)
    }
    
    static func /(lhd: NSLayoutDimension, rhd: CGFloat) -> AnchorCalculable<NSLayoutDimension> {
        return AnchorCalculable(target: lhd, multiplier: 1/rhd)
    }
}


fileprivate extension NSLayoutConstraint {
    
    func activate() {
        isActive = true
    }
}


enum LayoutTarget {
    
    enum XAxis {
        case left, right, centerX
    }
    
    enum YAxis {
        case top, bottom, centerY
    }
    
    enum Dimension {
        case width, height
    }
}

extension UIView {
    
    func layoutAnchor(_ target: LayoutTarget.XAxis) -> NSLayoutXAxisAnchor {
        switch target {
        case .left: return leftAnchor
        case .right: return rightAnchor
        case .centerX: return centerXAnchor
        }
    }
    
    func layoutAnchor(_ target: LayoutTarget.YAxis) -> NSLayoutYAxisAnchor {
        switch target {
        case .top: return topAnchor
        case .bottom: return bottomAnchor
        case .centerY: return centerYAnchor
        }
    }
    
    func layoutAnchor(_ target: LayoutTarget.Dimension) -> NSLayoutDimension {
        switch target {
        case .width: return widthAnchor
        case .height: return heightAnchor
        }
    }
}

final class LayoutMaker {
    
    private var view: UIView
    
    init (_ view: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func activateLayoutAnchorXAxis(_ constrain: HorizontalConstraints, target: LayoutTarget.XAxis) {
        
        let anchor = view.layoutAnchor(target)
        
        if let constrain = constrain as? AnchorCalculable<NSLayoutXAxisAnchor> {
            anchor.constraint(equalTo: constrain.target, constant: constrain.constant).activate()
        }
        else if let targetAnchor = constrain as? NSLayoutXAxisAnchor {
            anchor.constraint(equalTo: targetAnchor).activate()
        }
        else if let targetView = constrain as? UIView {
            anchor.constraint(equalTo: targetView.layoutAnchor(target)).activate()
        }
        else if let constant = constrain as? CGFloat {
            anchor.constraint(equalTo: view.superview!.layoutAnchor(target), constant: constant).activate()
        }
        else if let constant = constrain as? Int {
            anchor.constraint(equalTo: view.superview!.layoutAnchor(target), constant: CGFloat(constant)).activate()
        }
    }
    
    func activateLayoutAnchorYAxis(_ constrain: VerticalConstraints, target: LayoutTarget.YAxis) {
        
        let anchor = view.layoutAnchor(target)
        
        if let constrain = constrain as? AnchorCalculable<NSLayoutYAxisAnchor> {
            anchor.constraint(equalTo: constrain.target, constant: constrain.constant).activate()
        }
        else if let targetAnchor = constrain as? NSLayoutYAxisAnchor {
            anchor.constraint(equalTo: targetAnchor).activate()
        }
        else if let targetView = constrain as? UIView {
            anchor.constraint(equalTo: targetView.layoutAnchor(target)).activate()
        }
        else if let constant = constrain as? CGFloat {
            anchor.constraint(equalTo: view.superview!.layoutAnchor(target), constant: constant).activate()
        }
        else if let constant = constrain as? Int {
            anchor.constraint(equalTo: view.superview!.layoutAnchor(target), constant: CGFloat(constant)).activate()
        }
    }
    
    
    func activateLayoutAnchorDimension(_ constrain: DimensionalConstraints, target: LayoutTarget.Dimension) {
        
        let anchor = view.layoutAnchor(target)
        
        if let constrain = constrain as? AnchorCalculable<NSLayoutDimension> {
            anchor.constraint(equalTo: constrain.target, multiplier: constrain.multiplier, constant: constrain.constant).activate()
        }
        else if let targetAnchor = constrain as? NSLayoutDimension {
            anchor.constraint(equalTo: targetAnchor).activate()
        }
        else if let targetView = constrain as? UIView {
            anchor.constraint(equalTo: targetView.layoutAnchor(target)).activate()
        }
        else if let constant = constrain as? CGFloat {
            anchor.constraint(equalToConstant: constant).activate()
        }
        else if let constant = constrain as? Int {
            anchor.constraint(equalToConstant: CGFloat(constant)).activate()
        }
    }
}


extension LayoutMaker {
    
    @discardableResult
    func width(_ width: DimensionalConstraints) -> LayoutMaker {
        activateLayoutAnchorDimension(width, target: .width)
        return self
    }
    
    @discardableResult
    func height(_ height: DimensionalConstraints) -> LayoutMaker {
        activateLayoutAnchorDimension(height, target: .height)
        return self
    }
}

extension LayoutMaker {
    
    @discardableResult
    func left(_ left: HorizontalConstraints) -> LayoutMaker {
        activateLayoutAnchorXAxis(left, target: .left)
        return self
    }
    
    @discardableResult
    func right(_ right: HorizontalConstraints) -> LayoutMaker {
        activateLayoutAnchorXAxis(right, target: .right)
        return self
    }
    
    @discardableResult
    func centerX(_ centerX: HorizontalConstraints) -> LayoutMaker {
        activateLayoutAnchorXAxis(centerX, target: .centerX)
        return self
    }
}

extension LayoutMaker {
    
    @discardableResult
    func top(_ top: VerticalConstraints) -> LayoutMaker {
        activateLayoutAnchorYAxis(top, target: .top)
        return self
    }
    
    @discardableResult
    func bottom(_ bottom: VerticalConstraints) -> LayoutMaker {
        activateLayoutAnchorYAxis(bottom, target: .bottom)
        return self
    }
    
    @discardableResult
    func centerY(_ centerY: VerticalConstraints) -> LayoutMaker {
        activateLayoutAnchorYAxis(centerY, target: .centerY)
        return self
    }
}



// shortcut
extension LayoutMaker {
    
    @discardableResult
    func size(_ size: DimensionalConstraints) -> LayoutMaker {
        width(size); height(size);
        return self
    }
    
    @discardableResult
    func center(_ center: HorizontalConstraints & VerticalConstraints) -> LayoutMaker {
        centerY(center); centerX(center);
        return self
    }
}

extension LayoutMaker {
    
    func equalToSuperView() {
        left(0); right(0); top(0); bottom(0);
    }
}


// relate extension
extension LayoutMaker {
    
    @discardableResult
    func top(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorYAxis(view, target: .top)
        return self
    }
    
    @discardableResult
    func bottom(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorYAxis(view, target: .bottom)
        return self
    }
    
    @discardableResult
    func centerY(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorYAxis(view, target: .centerY)
        return self
    }
    
    
    @discardableResult
    func top(anchor: NSLayoutYAxisAnchor, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorYAxis(anchor+offSet, target: .top)
        return self
    }
    
    @discardableResult
    func bottom(anchor: NSLayoutYAxisAnchor, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorYAxis(anchor+offSet, target: .bottom)
        return self
    }
    
    @discardableResult
    func centerY(anchor: NSLayoutYAxisAnchor, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorYAxis(anchor+offSet, target: .centerY)
        return self
    }
}

extension LayoutMaker {
    
    @discardableResult
    func left(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorXAxis(view, target: .left)
        return self
    }
    
    @discardableResult
    func right(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorXAxis(view, target: .right)
        return self
    }
    
    @discardableResult
    func centerX(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorXAxis(view, target: .centerX)
        return self
    }
    
    @discardableResult
    func left(anchor: NSLayoutXAxisAnchor, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorXAxis(anchor+offSet, target: .left)
        return self
    }
    
    @discardableResult
    func right(anchor: NSLayoutXAxisAnchor, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorXAxis(anchor+offSet, target: .right)
        return self
    }
    
    @discardableResult
    func centerX(anchor: NSLayoutXAxisAnchor, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorXAxis(anchor+offSet, target: .centerX)
        return self
    }
}


extension LayoutMaker {
    
    @discardableResult
    func width(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorDimension(view, target: .width)
        return self
    }
    
    @discardableResult
    func height(equalTo view: UIView) -> LayoutMaker {
        activateLayoutAnchorDimension(view, target: .height)
        return self
    }
    
    @discardableResult
    func width(anchor: NSLayoutDimension, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorDimension(anchor+offSet, target: .width)
        return self
    }
    
    @discardableResult
    func height(anchor: NSLayoutDimension, offSet: CGFloat) -> LayoutMaker {
        activateLayoutAnchorDimension(anchor+offSet, target: .height)
        return self
    }
    
    @discardableResult
    func width(anchor: NSLayoutDimension, multiplier: CGFloat) -> LayoutMaker {
        activateLayoutAnchorDimension(anchor*multiplier, target: .width)
        return self
    }
    
    @discardableResult
    func height(anchor: NSLayoutDimension, multiplier: CGFloat) -> LayoutMaker {
        activateLayoutAnchorDimension(anchor*multiplier, target: .height)
        return self
    }
}
