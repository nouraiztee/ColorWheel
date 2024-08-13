//
//  ColorSegmentedControlView.swift
//  ColorWheel
//
//  Created by Nouraiz Taimour on 13/08/2024.
//

import Foundation
import UIKit

protocol ColorSegmentedControlDelegate: AnyObject {
    func colorSegmentChanged(to color: UIColor, at index: Int)
}

// Reusable segmented control view
class ColorSegmentedControlView: UIView {

    weak var delegate: ColorSegmentedControlDelegate?
    private var colorSegments: [UIColor] = [.clear, .clear, .clear]
    private let segmentedControl = UISegmentedControl()
    
    var colors: [UIColor] {
        get { return colorSegments }
        set {
            colorSegments = newValue
            updateSegments()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = UIColor(resource: .colorSelectedSegment)
        segmentedControl.backgroundColor = UIColor(resource: .colorSegmentBG)
        segmentedControl.frame.size.height = 60
        addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateSegments()
    }
    
    private func updateSegments() {
        segmentedControl.removeAllSegments()
        
        for (index, color) in colorSegments.enumerated() {
            segmentedControl.insertSegment(withTitle: "", at: index, animated: false)
            updateSegmentView(at: index, with: color)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func updateSegmentView(at index: Int, with color: UIColor) {
        guard index < segmentedControl.numberOfSegments else { return }
        
        // Create the circular view
        let circleDiameter: CGFloat = 20
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        circleView.backgroundColor = color
        circleView.layer.cornerRadius = circleDiameter / 2
        circleView.layer.borderWidth = 1.0
        circleView.layer.borderColor = UIColor.white.cgColor
        
        // Embed the circular view into a UIImage to set as segment image
        let renderer = UIGraphicsImageRenderer(size: circleView.bounds.size)
        let image = renderer.image { ctx in
            circleView.layer.render(in: ctx.cgContext)
        }
        
        segmentedControl.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard selectedIndex >= 0 && selectedIndex < colorSegments.count else { return }
        let selectedColor = colorSegments[selectedIndex]
        delegate?.colorSegmentChanged(to: selectedColor, at: selectedIndex)
    }
    
    // Update color of a specific segment
    func updateColor(_ color: UIColor, at index: Int) {
        guard index < colorSegments.count else { return }
        colorSegments[index] = color
        updateSegmentView(at: index, with: color)
    }
    
    func selectedSegmentIndex() -> Int {
        return segmentedControl.selectedSegmentIndex
    }
}
