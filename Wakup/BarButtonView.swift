//
//  BarButtonView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 17/12/18.
//  Copyright © 2018 Yellow Pineapple. All rights reserved.
//

import UIKit

public typealias T = String

public protocol BarButtonViewHelper {
    func select(index: Int, animated: Bool)
    func deselectItem(animated: Bool)
}

@IBDesignable
open class BarButtonView: UIScrollView {
    
    open class Helper<T: Equatable, V: UIButton>: BarButtonViewHelper {
        public let view: BarButtonView
        public var items: [T] = [] { didSet { setup() }}
        public var selectedItem: T?
        
        // Callbacks
        public var setSelectedStatus: (V, Int, Bool) -> Void = { button, _, selected in button.isSelected = selected }
        public var configureButton: (V, T) -> Void = { _, _ in }
        public var onItemSelected: (T?) -> Void = { _ in }
        public var createButton: (() -> V?)?
        
        // Convenience methods
        var stackView: UIStackView? { get { return view.stackView }}
        var selectionBarView: UIView? { get { return view.selectionBarView }}
        var sampleButton: UIButton? { get { return view.sampleButton }}
        
        private var barConstraints: [NSLayoutConstraint] = [] {
            didSet {
                view.removeConstraints(oldValue)
                view.addConstraints(barConstraints)
            }
        }
        
        init(view: BarButtonView, onSelection: @escaping (T?) -> Void = { _ in }, configureButton: @escaping (V, T) -> Void = { _, _ in }, createButton: (() -> V?)? = nil) {
            self.view = view
            self.onItemSelected = onSelection
            self.configureButton = configureButton
            self.createButton = createButton
            
            setup()
        }
        
        open func select(index: Int, animated: Bool) {
            guard index < items.count else { return }
            let item = items[index]
            guard item != selectedItem else {
                deselectItem(animated: animated)
                return
            }
            selectedItem = item
            onItemSelected(selectedItem)
            updateSelectedItem()
            selectionBarView?.isHidden = false
            moveSelectionBar(toItem: item, animated: animated)
            scrollToItem(item: item, animated: animated)
        }
        
        open func deselectItem(animated: Bool) {
            selectedItem = nil
            onItemSelected(nil)
            updateSelectedItem()
            selectionBarView?.isHidden = true
        }
        
        private func updateSelectedItem() {
            guard let stackView = stackView else { return }
            for (item, view) in zip(items, stackView.arrangedSubviews) {
                guard let button = view as? V else { continue }
                button.isSelected = item == selectedItem
            }
        }
        
        private func setup() {
            guard let stackView = stackView else { return }
            for view in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            for item in items {
                guard let button = createButton(forItem: item) else { continue }
                stackView.addArrangedSubview(button)
            }
            
            view.contentOffset = CGPoint.zero
            selectedItem = nil
            selectionBarView?.isHidden = true
        }
        
        private func createButton(forItem item: T) -> V! {
            guard let button = (createButton ?? cloneButton)() else { return nil }
            configureButton(button, item)
            button.addTarget(self, action: #selector(barButtonSelected(sender:)), for: .touchUpInside)
            return button
        }
        
        private func moveSelectionBar(toItem: T, animated: Bool = true) {
            guard let stackView = stackView, let selectionBarView = selectionBarView else { return }
            let margins = stackView.spacing / 2
            guard let toView = viewForItem(toItem) else { return }
            
            if view.moveSelectionBarToCenter {
                barConstraints = [
                    selectionBarView.centerXAnchor.constraint(equalTo: toView.centerXAnchor)
                ]
            }
            else {
                barConstraints = [
                    selectionBarView.leftAnchor.constraint(equalTo: toView.leftAnchor, constant: -margins),
                    selectionBarView.rightAnchor.constraint(equalTo: toView.rightAnchor, constant: margins)
                ]
            }
            
            if animated {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
        
        private func scrollToItem(item: T, animated: Bool) {
            guard let view = viewForItem(item) else { return }
            var frame = view.frame
            if item != items.first && item != items.last {
                let insets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: -40)
                frame = UIEdgeInsetsInsetRect(frame, insets)
            }
            self.view.scrollRectToVisible(frame, animated: animated)
        }
        
        func viewForItem(_ item: T) -> V? {
            guard let stackView = stackView, let index = items.index(of: item) else { return nil }
            return stackView.arrangedSubviews[index] as? V
        }
        
        @objc func barButtonSelected(sender: AnyObject) {
            guard let stackView = stackView, let index = stackView.arrangedSubviews.index(of: sender as! UIView) else { return }
            select(index: index, animated: true)
        }
        
        private func cloneButton() -> V? {
            guard let sample = self.sampleButton else { return nil }
            let data = NSKeyedArchiver.archivedData(withRootObject: sample)
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? V
        }
    }
    
    @IBInspectable open dynamic var moveSelectionBarToCenter: Bool = false
    
    @IBOutlet open weak var stackView: UIStackView!
    @IBOutlet open weak var selectionBarView: UIView!
    
    @IBOutlet open var sampleButton: UIButton!
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        contentInset = UIEdgeInsets(top: 0, left: stackView.spacing / 2, bottom: 0, right: stackView.spacing / 2)
    }
}
