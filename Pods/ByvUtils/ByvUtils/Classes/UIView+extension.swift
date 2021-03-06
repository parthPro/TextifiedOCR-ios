//
//  UIView+extension.swift
//  Pods
//
//  Created by Adrian Apodaca on 28/11/16.
//
//

import Foundation

public enum ByvPosition {
    case top
    case right
    case bottom
    case left
    case all
}

public enum ByvDirection {
    case vertical
    case horizontal
}

public extension UIView {
    func addTo(_ superView: UIView, position:ByvPosition = .all, insets: UIEdgeInsets = UIEdgeInsets.zero, centered:Bool = false, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        let views = ["view" : self]
        
        var formatString = "H:"
        
        if position == .left || ((position == .top || position == .bottom || position == .all) && !centered) {
            formatString += "|-(\(insets.left))-"
        }
        
        formatString += "[view"
        
        if let width = width {
            formatString += "(\(width))"
        }
        
        formatString += "]"
        
        if position == .right || ((position == .top || position == .bottom || position == .all) && !centered) {
            formatString += "-(\(insets.right))-|"
        }
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options:[] , metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
        
        if centered && position != .left && position != .right {
            superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        }
        
        formatString = "V:"
        
        if position == .top || ((position == .left || position == .right || position == .all) && !centered) {
            formatString += "|-(\(insets.top))-"
        }
        
        formatString += "[view"
        
        if let height = height {
            formatString += "(\(height))"
        }
        
        formatString += "]"
        
        if position == .bottom || ((position == .left || position == .right || position == .all) && !centered) {
            formatString += "-(\(insets.bottom))-|"
        }
        
        constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options:[] , metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
        
        if centered && position != .top && position != .left {
            superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        }
        
    }
    
    func add(subViews:Array<UIView>, direction:ByvDirection = .vertical, insets: UIEdgeInsets = UIEdgeInsets.zero, margin: CGFloat = 0.0, size: CGFloat? = nil) {
        
        var preView: UIView?
        
        for view in subViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            let views = ["view" : view, "preView": preView]
            var formatString = "H:"
            if direction == .horizontal {
                formatString = "V:"
            }
            
            formatString += "|-(\(insets.left))-[view]-(\(insets.right))-|"
            var constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options:[] , metrics: nil, views: views)
            
            NSLayoutConstraint.activate(constraints)
            
            formatString = "V:"
            if direction == .horizontal {
                formatString = "H:"
            }
            
            if preView != nil {
                formatString += "[preView]-(\(margin))-"
            } else {
                formatString += "|-(\(insets.top))-"
            }
            
            formatString += "[view"
            
            if let _size = size {
                formatString += "(\(_size))"
            }
            
            formatString += "]"
            
            if view == subViews.last {
                formatString += "-(\(insets.bottom))-|"
            }
            
            constraints = NSLayoutConstraint.constraints(withVisualFormat: formatString, options:[] , metrics: nil, views: views)
            
            NSLayoutConstraint.activate(constraints)
            
            preView = view
        }
    }
    
    func setHeight(_ height: CGFloat, relation:NSLayoutRelation = .equal) {
        if let hc = self.height() {
            if hc.relation == relation {
                hc.constant = height
                return
            }
        }
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        self.addConstraint(heightConstraint)
    }
    
    func height() -> NSLayoutConstraint? {
        return getConstraint(attribute: NSLayoutAttribute.height)
    }
    
    func setWidth(_ width: CGFloat, relation:NSLayoutRelation = .equal) {
        if let wc = self.width() {
            if wc.relation == relation {
                wc.constant = width
                return
            }
        }
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)
        self.addConstraint(widthConstraint)
    }
    
    func width() -> NSLayoutConstraint? {
        return getConstraint(attribute: NSLayoutAttribute.width)
    }
    
    private func getConstraint(attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
    
    func addShadow(color: UIColor = UIColor.black, opacity: Float = 0.8, offset: CGSize = CGSize.zero, radius: CGFloat = 10.0 ) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    func indexPath(for tableView: UITableView) -> IndexPath? {
        var view:UIView? = self
        while (view != nil) {
            if view!.isKind(of: UITableViewCell.classForCoder()) {
                return tableView.indexPath(for: view as! UITableViewCell)
            } else {
                if let sv = view?.superview {
                    view = sv
                } else {
                    view = nil
                }
            }
        }
        
        return nil;
    }
}
