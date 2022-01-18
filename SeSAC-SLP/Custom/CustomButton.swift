//
//  CustomButton.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/01/18.
//

import Foundation
import UIKit

class InactiveButton: UIButton {
    
    override func updateConfiguration() {
        guard let configuration = configuration else {
            return
        }
        var updatedConfiguration = configuration
        var background = UIButton.Configuration.plain().background
        
        background.cornerRadius = 8
        background.strokeWidth = 1
        
        let strokeColor: UIColor
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        
        switch self.state {
        case .normal:
            strokeColor = CustomColor.SLPGray4.color
            foregroundColor = CustomColor.SLPBlack.color
            backgroundColor = .clear
        case .selected:
            strokeColor = CustomColor.SLPGreen.color
            foregroundColor = CustomColor.SLPWhite.color
            backgroundColor = CustomColor.SLPGreen.color
        default:
            strokeColor = CustomColor.SLPGray4.color
            foregroundColor = CustomColor.SLPBlack.color
            backgroundColor = .clear
        }
        background.strokeColor = strokeColor
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.background = background
        
        self.configuration = updatedConfiguration
    }
}

class FilledButton: UIButton {
    
    override func updateConfiguration() {
        guard let configuration = configuration else {
            return
        }
        var updatedConfiguration = configuration
        var background = UIButton.Configuration.plain().background
        
        background.cornerRadius = 8
        background.strokeWidth = 1
        
        let strokeColor: UIColor
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        
        switch self.state {
        case .normal:
            strokeColor = CustomColor.SLPGreen.color
            foregroundColor = CustomColor.SLPWhite.color
            backgroundColor = CustomColor.SLPGreen.color
        case .disabled:
            strokeColor = CustomColor.SLPGray6.color
            foregroundColor = CustomColor.SLPGray3.color
            backgroundColor = CustomColor.SLPGray6.color
            
            var container = AttributeContainer()
            container.foregroundColor = CustomColor.SLPGray3.color
            let title = updatedConfiguration.title!
            updatedConfiguration.attributedTitle = AttributedString(title, attributes: container)
            
        default:
            strokeColor = CustomColor.SLPGreen.color
            foregroundColor = CustomColor.SLPWhite.color
            backgroundColor = CustomColor.SLPGreen.color
        }
        background.strokeColor = strokeColor
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.background = background
        
        self.configuration = updatedConfiguration
    }

}

class OutlineButton: UIButton {
    
    override func updateConfiguration() {
        guard let configuration = configuration else {
            return
        }
        var updatedConfiguration = configuration
        var background = UIButton.Configuration.plain().background
        
        background.cornerRadius = 8
        background.strokeWidth = 1
        
        let strokeColor: UIColor
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        
        switch self.state {
        case .normal:
            strokeColor = CustomColor.SLPGreen.color
            foregroundColor = CustomColor.SLPGreen.color
            backgroundColor = .clear
        default:
            strokeColor = CustomColor.SLPGreen.color
            foregroundColor = CustomColor.SLPGreen.color
            backgroundColor = .clear
        }
        background.strokeColor = strokeColor
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.background = background
        
        self.configuration = updatedConfiguration
    }
}

class CancelButton: UIButton {
    
    override func updateConfiguration() {
        guard let configuration = configuration else {
            return
        }
        var updatedConfiguration = configuration
        var background = UIButton.Configuration.plain().background
        
        background.cornerRadius = 8
        background.strokeWidth = 1
        
        let strokeColor: UIColor
        let foregroundColor: UIColor
        let backgroundColor: UIColor
        
        switch self.state {
        case .normal:
            strokeColor = CustomColor.SLPGray2.color
            foregroundColor = CustomColor.SLPBlack.color
            backgroundColor = CustomColor.SLPGray2.color
        default:
            strokeColor = CustomColor.SLPGray2.color
            foregroundColor = CustomColor.SLPBlack.color
            backgroundColor = CustomColor.SLPGray2.color
        }
        background.strokeColor = strokeColor
        background.backgroundColor = backgroundColor
        
        updatedConfiguration.baseForegroundColor = foregroundColor
        updatedConfiguration.background = background
        
        self.configuration = updatedConfiguration
    }
}
