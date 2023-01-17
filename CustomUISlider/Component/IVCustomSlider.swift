//
//  IVCustomSlider.swift
//  CustomUISlider
//
//  Created by Lidiane Gomes Barbosa on 13/01/23.
//

import UIKit

protocol CustomSliderDelegate: AnyObject {
    func valueDidChange(_ value: CGFloat)
}

class IVCustomSlider: UIControl {
    
    weak var delegate: CustomSliderDelegate?
    
    var minimumValue: CGFloat = .zero {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maximumValue: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var value: CGFloat = .zero {
        didSet {
            updateLayerFrames()
        }
    }
    
    var thumbImage = UIImage(systemName: "circle.fill") {
        didSet {
            thumb.image = thumbImage
            updateLayerFrames()
        }
    }
    
    var highlightedThumbImage = UIImage(systemName: "pencil.circle") {
      didSet {
        thumb.highlightedImage = highlightedThumbImage
        updateLayerFrames()
      }
    }
    
    var trackTintColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var height: CGFloat = 8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var trackHighlightTintColor = UIColor(red: 0.31, green: 0.765, blue: 0.969, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    private let thumb: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
        return imageView
    }()
    
    private let trackLayer = CustomSliderTrackLayer()
    private var previousLocation = CGPoint()
   
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        thumb.image = thumbImage
        thumb.highlightedImage = highlightedThumbImage
        addSubview(thumb)
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        trackLayer.frame = CGRect(x: .zero, y: bounds.midY - (height / 2), width: bounds.width, height: height)
        trackLayer.setNeedsDisplay()
        
        let thumbSize = thumb.frame.size
        thumb.frame = CGRect(origin: thumbOriginForValue(value),
                             size: thumbSize)
        CATransaction.commit()
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        let newValue = value / maximumValue
        return bounds.width * newValue
    }
    
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let imageSize = thumb.frame.size
        let x = positionForValue(value) - imageSize.width / 2.0
        let y = (bounds.height - imageSize.height) / 2.0
        return CGPoint(x: x, y: y)
    }
    
    override func layoutSubviews() {
        updateLayerFrames()
    }
}

extension IVCustomSlider {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        if thumb.frame.contains(previousLocation) {
            thumb.isHighlighted = true
        }
        
        return thumb.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        if thumb.isHighlighted {
            value += deltaValue
            value = boundValue(value, toLowerValue: minimumValue,
                               upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        delegate?.valueDidChange(value)
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumb.isHighlighted = false
        delegate?.valueDidChange(value)
    }
}
