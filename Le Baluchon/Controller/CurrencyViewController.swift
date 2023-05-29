//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation
import UIKit

// MARK: - CurrencyViewController
/// This class is used to convert a currency to another one.
/// It uses the Fixer API to get the exchange rate.
/// The API key and the base URL are stored in the Keys.plist file.


class CurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    private let currencyConverter = CurrencyConverter()
    private var amount: Double = 0
    private var currencyCode: String = ""
    private var usdAmount: Double = 0

    // MARK: - Picker View
    private var currencyDictionary: [String: String] = [:]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyDictionary.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sortedSymbols = currencyDictionary.sorted { $0.key < $1.key }
        let currencyCode = sortedSymbols[row].key
        let currencyName = sortedSymbols[row].value
        return "\(currencyCode) - \(currencyName)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortedSymbols = currencyDictionary.sorted { $0.key < $1.key }
        let currencyCode = sortedSymbols[row].key
        currencyCodeTextField.text = currencyCode     
    }

    // set the selected row of the picker view to "USD" key by default
    func setPickerView() {
        let sortedSymbols = currencyDictionary.sorted { $0.key < $1.key }
        for (index, element) in sortedSymbols.enumerated() {
            if element.key == "USD" {
                countryPicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }




    // MARK: View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        setPickerView()
    }
    
    // MARK: Prepare View
    private func prepareView() {
        titleLabel.text = "Currency Converter"
        amountTextField.placeholder = "Amount"
        currencyCodeTextField.placeholder = "Currency Code"
        usdAmountLabel.text = "AMOUNT INCOMMING"
        getRate.setTitle("Convert", for: .normal)
        getRate.setTitleColor(.white, for: .normal)
        getRate.layer.cornerRadius = 5
        getRate.layer.masksToBounds = true

        currencyCodeTextField.inputView = countryPicker
        self.currencyDictionary = currencyConverter.symbols
        for (key, value) in currencyDictionary {
            print("In VC : \(key) - \(value)")
        }
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
    }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var usdAmountLabel: UILabel!
    @IBOutlet weak var getRate: UIButton!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    // MARK: - Actions
    
    @IBAction func getRateTapped(_ sender: UIButton) {
        getRate.setTitle("Loading", for: .normal)
        getRate.configuration?.showsActivityIndicator = true
        amountTextField.resignFirstResponder()
        currencyCodeTextField.resignFirstResponder()
        
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              let country = currencyCodeTextField.text
        else {
            usdAmountLabel.text = "Oops, you must provide an Amount value"
            getRate.setTitle("Get", for: .normal)
            getRate.configuration?.showsActivityIndicator = false
            return
        }
        
        currencyConverter.convert(amount: amount, country: country) { usdAmount in
            DispatchQueue.main.async { [self] in
                getRate.setTitle("Get", for: .normal)
                getRate.configuration?.showsActivityIndicator = false
                guard let usdAmount = usdAmount else {
                    usdAmountLabel.text = "Error"
                    return
                }
                usdAmountLabel.text = "\(usdAmount) \(country)"
            }
        }
    }
}
