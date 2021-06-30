//
//  CustomSegmentedControl.swift
//  hn
//
//  Created by vlsuv on 29.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomSegmentedControl: UIView {
    
    // MARK: - Properties
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor: UIColor = AssetsColors.text
    var selectorViewColor: UIColor = Color.mediumGray!
    var selectorTextColor: UIColor = Color.mediumGray!
    
    var selectedSegmentIndex: BehaviorRelay<Int> = .init(value: 0)
    
    // MARK: - Actions
    @objc func didTapButton(_ sender: UIButton) {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            
            if button == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
                
                selectedSegmentIndex.accept(index)
                
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                
                button.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    
    // MARK: - Setups
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    private func configStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        
        selectorView.backgroundColor = selectorViewColor
        
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    // MARK: - User Setups
    func setButtonTitles(buttonTitle: [String]) {
        self.buttonTitles = buttonTitle
        updateView()
    }
}
