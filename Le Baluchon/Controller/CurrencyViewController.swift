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


class CurrencyViewController: UIViewController {
    
    // MARK: - Properties
    private let currencyConverter = CurrencyConverter()
    private var amount: Double = 0
    private var currencyCode: String = ""
    private var usdAmount: Double = 0
    
    // MARK: View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    // MARK: Prepare View
    private func prepareView() {
        titleLabel.text = "Currency Converter"
        amountTextField.placeholder = "Amount"
        currencyCodeTextField.placeholder = "Currency Code"
        usdAmountLabel.text = "AMOUNT INCOMMING"
        convertButton.setTitle("Convert", for: .normal)
        convertButton.setTitleColor(.white, for: .normal)
        convertButton.backgroundColor = .systemBlue
        convertButton.layer.cornerRadius = 5
        convertButton.layer.masksToBounds = true
        activityIndicator.isHidden = true
    }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var usdAmountLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var getRate: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Actions
    @IBAction func onConvertTapped(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        amountTextField.resignFirstResponder()
        currencyCodeTextField.resignFirstResponder()
        
        guard let amountText = amountTextField.text,
              let amount = Double(amountText)
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            usdAmountLabel.text = "Error"
            return
        }
        
        currencyConverter.convertToDollars(amount: amount) { usdAmount in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                guard let usdAmount = usdAmount else {
                    self.usdAmountLabel.text = "Error"
                    return
                }
                self.usdAmountLabel.text = "\(usdAmount) USD"
            }
        }
        
    }
    
    @IBAction func getRateTapped(_ sender: UIButton) {
        getRate.setTitle("Loading", for: .normal)
        getRate.configuration?.showsActivityIndicator = true
        amountTextField.resignFirstResponder()
        currencyCodeTextField.resignFirstResponder()
        
        guard let amountText = amountTextField.text,
              let amount = Double(amountText)
        else {
            usdAmountLabel.text = "Oops, you must provide an Amount value"
            getRate.setTitle("Get", for: .normal)
            getRate.configuration?.showsActivityIndicator = false
            return
        }
        
        currencyConverter.convert(amount: amount) { usdAmount in
            DispatchQueue.main.async { [self] in
                getRate.setTitle("Get", for: .normal)
                getRate.configuration?.showsActivityIndicator = false
                guard let usdAmount = usdAmount else {
                    usdAmountLabel.text = "Error"
                    return
                }
                usdAmountLabel.text = "\(usdAmount) USD"
            }
        }
    }
    
    // MARK: - Methods
    
    
}
