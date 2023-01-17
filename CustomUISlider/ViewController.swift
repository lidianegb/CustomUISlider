//
//  ViewController.swift
//  CustomUISlider
//
//  Created by Lidiane Gomes Barbosa on 13/01/23.
//

import UIKit

class ViewController: UIViewController {

    private lazy var sliderView: IVCustomSlider = {
        let slider = IVCustomSlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.delegate = self
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.thumbImage = UIImage(systemName: "pencil.slash")
        slider.value = 0.4
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sliderView)

        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        sliderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
    }
}

extension ViewController: CustomSliderDelegate {
    func rangeSliderValueChanged(_ value: CGFloat) {
        print("Range slider value changed: \(value)")
    }
}
