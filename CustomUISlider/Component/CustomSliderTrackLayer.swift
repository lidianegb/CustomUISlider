//
//  CustomSliderTrackLayer.swift
//  CustomUISlider
//
//  Created by Lidiane Gomes Barbosa on 17/01/23.
//

import UIKit

class CustomSliderTrackLayer: CALayer {
    weak var rangeSlider: IVCustomSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = slider.positionForValue(slider.minimumValue)
        let upperValuePosition = slider.positionForValue(slider.value)
        let rect = CGRect(x: lowerValuePosition, y: 0,
                          width: upperValuePosition - lowerValuePosition,
                          height: bounds.height)
        ctx.fill(rect)
    }
    
}
