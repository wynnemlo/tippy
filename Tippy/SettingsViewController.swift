//
//  SettingsViewController.swift
//  Tippy
//
//  Created by Wynne M Lo on 22/7/2017.
//  Copyright © 2017 Wynne Lo. All rights reserved.
//

import UIKit
import TTSegmentedControl

protocol SettingsViewControllerDelegate {
    func themeSelected(_ theme: ColorScheme)
}

enum ColorScheme {
    case Plain
    case Color
}

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var defaultTipControl: TTSegmentedControl!
    @IBOutlet weak var colorSchemeControl: TTSegmentedControl!
    
    var delegate: SettingsViewControllerDelegate?

    // MARK: - View cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaultTipControl()
        setupThemeControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        // load default tip percentage, if applicable
        let defaultTipPercentageIndex = defaults.integer(forKey: "defaultTipPercentageIndex")
        if defaultTipPercentageIndex != 0 {
            defaultTipControl.selectItemAt(index: defaultTipPercentageIndex - 1)
        }
        
        // load default theme, if applicable
        let defaultThemeIndex = defaults.integer(forKey: "defaultThemeIndex")
        if defaultThemeIndex != 0 {
            colorSchemeControl.selectItemAt(index: defaultThemeIndex - 1)
        }
    }
    
    // MARK: - helpers for viewDidLoad
    
    func setupDefaultTipControl() {
        defaultTipControl.itemTitles = ["10%", "15%", "20%"]
        defaultTipControl.allowChangeThumbWidth = false
        defaultTipControl.defaultTextFont = UIFont.systemFont(ofSize: 16)
        defaultTipControl.selectedTextFont = UIFont.systemFont(ofSize: 16)
        
        defaultTipControl.didSelectItemWith = { (index, title) -> () in
            let defaults = UserDefaults.standard
            defaults.set(index, forKey: "defaultTipPercentageIndex")
            defaults.synchronize()
        }
    }
    
    func setupThemeControl() {
        colorSchemeControl.itemTitles = ["PLAIN", "COLOR"]
        colorSchemeControl.allowChangeThumbWidth = false
        colorSchemeControl.defaultTextFont = UIFont.systemFont(ofSize: 16)
        colorSchemeControl.selectedTextFont = UIFont.systemFont(ofSize: 16)
        
        colorSchemeControl.didSelectItemWith = { (index, title) -> () in
            let defaults = UserDefaults.standard
            defaults.set(index, forKey: "defaultThemeIndex")
            defaults.synchronize()
            
            if index == 1 {
                self.delegate?.themeSelected(.Plain)
            } else if index == 2 {
                self.delegate?.themeSelected(.Color)
            }
        }
    }
    
}
