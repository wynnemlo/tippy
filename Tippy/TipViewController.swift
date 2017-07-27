//
//  TipViewController.swift
//  Tippy
//
//  Created by Wynne M Lo on 21/7/2017.
//  Copyright © 2017 Wynne Lo. All rights reserved.
//

import UIKit
import TTSegmentedControl
import RaisePlaceholder

@objc
protocol TipViewControllerDelegate {
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}


class TipViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tipPercentageControl: TTSegmentedControl!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var billAmountTextField: RaisePlaceholder!
    @IBOutlet weak var numberOfPeopleTextField: RaisePlaceholder!
    @IBOutlet weak var extraAmountTextField: RaisePlaceholder!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var hiddenTextField: UITextField!
    
    // MARK: - Variables
    
    var delegate: TipViewControllerDelegate?
    
    var currencyFormatter: NumberFormatter!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var selectedTipPercentageIndex: Int = 1
    
    let TIP_PERCENTAGES = [0.10, 0.15, 0.20]
    
    let GRAY = UIColor(red:0.86, green:0.87, blue:0.87, alpha:1.0)
    
    // MARK: - View Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // set up apperances
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        createGradientLayer()
        
        // show keyboard upon loading
        // using a hidden textfield instead of assigning billAmountTextField as firstResponder because don't want to get in the way of the raised placeholder UI
        hiddenTextField.becomeFirstResponder()
        
        // setup number formatter
        currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        currencyFormatter.numberStyle = .currency
        
        // load defaults, if applicable
        loadDefaultTipPercentage()
        loadPreviousBillAmounts()
        loadDefaultTheme()
        
        // setup delegates
        billAmountTextField.addTarget(self, action: #selector(amountDidChange(_:)), for: .editingDidEnd)
        extraAmountTextField.addTarget(self, action: #selector(amountDidChange(_:)), for: .editingDidEnd)
        numberOfPeopleTextField.addTarget(self, action: #selector(numberOfPeopleDidChange(_:)), for: .editingDidEnd)

        // setup segmented control
        tipPercentageControl.itemTitles = ["10%", "15%", "20%"]
        tipPercentageControl.allowChangeThumbWidth = false
        tipPercentageControl.defaultTextFont = UIFont.systemFont(ofSize: 16)
        tipPercentageControl.selectedTextFont = UIFont.systemFont(ofSize: 16)
        tipPercentageControl.didSelectItemWith = { (index, title) -> () in
            self.selectedTipPercentageIndex = index
            self.updateTotal()
        }
    }
    
    // MARK: - Loading helpers
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:0.63, green:1.00, blue:0.81, alpha:0.7).cgColor, UIColor(red:0.98, green:1.00, blue:0.82, alpha:0.7).cgColor]
        self.backgroundView.layer.addSublayer(gradientLayer)
    }
    
    func loadDefaultTipPercentage() {
        let defaults = UserDefaults.standard
        let defaultTipPercentageIndex = defaults.integer(forKey: "defaultTipPercentageIndex")
        if defaultTipPercentageIndex != 0 {
            selectedTipPercentageIndex = defaultTipPercentageIndex
            tipPercentageControl.selectItemAt(index: selectedTipPercentageIndex - 1)
        }
    }
    
    func loadPreviousBillAmounts() {
        let defaults = UserDefaults.standard
        if let lastClosedDate = defaults.object(forKey: "lastClosedDate") as? NSDate {
            // 10 minutes = 60 seconds * 10
            let tenMinutes: Double = 60 * 10
            // if it hasn't passed 10 minutes since last closed time, then load previous amounts
            if abs(lastClosedDate.timeIntervalSinceNow) < tenMinutes {
                let lastBillAmountText = defaults.object(forKey: "lastBillAmountText") as! String
                let lastNumberOfPeopleText = defaults.object(forKey: "lastNumberOfPeopleText")  as! String
                let lastExtraAmountText = defaults.object(forKey: "lastExtraAmountText") as! String
                
                billAmountTextField.text = lastBillAmountText
                numberOfPeopleTextField.text = lastNumberOfPeopleText
                extraAmountTextField.text = lastExtraAmountText
                
                updateTotal()
            }
        }
    }
    
    func loadDefaultTheme() {
        let defaults = UserDefaults.standard
        let defaultThemeIndex = defaults.integer(forKey: "defaultThemeIndex")
        if defaultThemeIndex == 1 {
            themeSelected(.Plain)
        } else if defaultThemeIndex == 2 {
            themeSelected(.Color)
        }
    }
    
    // MARK: - Calculations
    
    func calculateTip() -> Double {
        
        // extract all numbers from text fields into Double format
        let billAmount = extractDoubleFromTextField(billAmountTextField)
        let extraAmount = extractDoubleFromTextField(extraAmountTextField)
        let numberOfPeople = Double(numberOfPeopleTextField.text!) ?? 1
        
        // do calculation
        let tipAmount = billAmount * TIP_PERCENTAGES[selectedTipPercentageIndex - 1]
        let total = ( billAmount + tipAmount + extraAmount ) / numberOfPeople
        
        return total
    }
    
    // Parse the text fields and obtain a double from it, otherwise return 0
    func extractDoubleFromTextField(_ textField: UITextField) -> Double {
        guard let amtText = textField.text else { return 0 }
        if let double = currencyFormatter.number(from: amtText) as? Double {
            return double
        } else if let double = Double(amtText) {
            return double
        } else {
            return 0
        }
    }
    
    func amountDidChange(_ textField: UITextField) {
        // if text is already in currency format, then extract NSNumber and reformat
        if let num = currencyFormatter.number(from: textField.text!) {
            textField.text = currencyFormatter.string(from: num)
            updateTotal()
            return
        }
        
        // if text is not valid decimal places, then return 0
        guard let amount = Double(textField.text!) else {
            textField.text = currencyFormatter.string(from: NSNumber(integerLiteral: 0))
            updateTotal()
            return
        }
        
        // if text is successfully converted to Double, then return as correct format
        if let formattedAmount = currencyFormatter.string(from: amount as NSNumber) {
            textField.text = formattedAmount
            updateTotal()
            return
        }
        
    }
    
    func numberOfPeopleDidChange(_ textField: UITextField) {
        if textField  == numberOfPeopleTextField {
            updateTotal()
            return
        }
    }
    
    func updateTotal() {
        let total = calculateTip()
        saveToAppDelegate()
        totalAmountLabel.text = currencyFormatter.string(from: NSNumber(floatLiteral: total))
    }
    
    // MARK: - Gestures / Navigation

    @IBAction func onBackgroundTap(_ sender: Any) {
        updateTotal()
    }
    
    @IBAction func calculateButtonPressed(_ sender: Any) {
        billAmountTextField.endEditing(true)
        extraAmountTextField.endEditing(true)
        updateTotal()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        delegate?.toggleRightPanel?()
    }
    
    func saveToAppDelegate() {
        appDelegate.billAmountText = billAmountTextField.text ?? ""
        appDelegate.numberOfPeopleText = numberOfPeopleTextField.text ?? ""
        appDelegate.extraAmountText = extraAmountTextField.text ?? ""
    }
}


extension TipViewController: SettingsViewControllerDelegate {

    func themeSelected(_ theme: ColorScheme) {
        if theme == .Color {
            showGradientLayer()
        } else {
            hideGradientLayer()
        }
    }
    
    func showGradientLayer() {
        self.backgroundView.alpha = 1
        calculateButton.backgroundColor = UIColor.white
    }
    
    func hideGradientLayer() {
        self.backgroundView.alpha = 0
        calculateButton.backgroundColor = GRAY
    }
}

