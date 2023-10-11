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

class CurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CurrencyServiceDelegate {
    
    // MARK: - Properties
    private let currencyService = CurrencyServiceImplementation()
    private var amount: Double = 0
    private var currencyCode: String = ""
    private var usdAmount: Double = 0
    
    // MARK: - Picker View
    private var currencyDictionary: [String: String] = [:]
    
    // MARK: CurrencyServiceDelegate method
       func currencyDataDidUpdate() {
           DispatchQueue.main.async { [weak self] in
               self?.countryPicker.reloadAllComponents()
           }
       }
    
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
                currencyCodeTextField.text = currencyCode
            }
        }
    }
    
    // MARK: View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        currencyService.delegate = self
        setPickerView()
    }
    
    // MARK: Prepare View
    private func prepareView() {
        
        amountTextField.placeholder = "Amount"
        currencyCodeTextField.placeholder = "Currency Code"
        usdAmountLabel.text = "AMOUNT INCOMMING"
        getRate.setTitle("Convert", for: .normal)
        getRate.setTitleColor(.white, for: .normal)
        getRate.layer.cornerRadius = 5
        getRate.layer.masksToBounds = true
        
        self.currencyDictionary = currencyService.symbols
        
        // TODO: Delegate
        
        if currencyDictionary.isEmpty {
            // Display an alert indicating data is not available yet
            UIAlertHelper.showAlertWithTitle("Data Not Available", message: "Currency data is still loading. Please try again later.", from: self)
            
        } else {
            // Set picker's data source and delegate only if data is available
            countryPicker.delegate = self
            countryPicker.dataSource = self
        }

        currencyCodeTextField.isUserInteractionEnabled = false

        // Setup tap gesture to dismiss keyboard and picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

    }
    
    // MARK: - Outlets
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
                  !amount.isNaN,
                  !amountText.isEmpty,
                  let country = currencyCodeTextField.text,
                  !country.isEmpty
            else {
                // Cas où l'utilisateur a saisi du texte, n'a rien saisi ou n'a pas saisi de code de devise
                var errorMessage = ""
            let isAmountEmpty = amountTextField.text?.isEmpty
            let isCountryEmpty = currencyCodeTextField.text?.isEmpty
                let isAmountNaN = amount.isNaN
                
                switch (isAmountEmpty, isCountryEmpty, isAmountNaN) {
                case (true, true, _):
                    errorMessage = "Please provide both Amount and Currency Code."
                case (true, _, _):
                    errorMessage = "Please provide a valid Amount."
                case (_, true, _):
                    errorMessage = "Please provide a valid Currency Code."
                case (_, _, true):
                    errorMessage = "Amount must be a valid number."
                default:
                    errorMessage = "Invalid input."
                }
                
                UIAlertHelper.showAlertWithTitle("Error", message: errorMessage, from: self)
                usdAmountLabel.text = "Error: \(errorMessage)"
                getRate.setTitle("Convert", for: .normal)
                getRate.configuration?.showsActivityIndicator = false
                return
            }
        
        currencyService.convert(amount: amount, country: country) { usdAmount in
                DispatchQueue.main.async { [self] in
                    if let usdAmount = usdAmount {
                        usdAmountLabel.text = "\(usdAmount) \(country)"
                    } else {
                        
                        UIAlertHelper.showAlertWithTitle("Error", message: "Something went wrong", from: self)
                        usdAmountLabel.text = "Error"
                    }
                }
            }
        getRate.setTitle("Convert", for: .normal)
        getRate.configuration?.showsActivityIndicator = false
    }
    
    @objc private func currencyCodeTextFieldTapped() {
        currencyCodeTextField.inputView = countryPicker
        currencyCodeTextField.becomeFirstResponder()
    }

    @objc private func handleTap() {
        // Dismiss keyboard and picker when tapped outside
        amountTextField.resignFirstResponder()
        currencyCodeTextField.resignFirstResponder()
    }
}

