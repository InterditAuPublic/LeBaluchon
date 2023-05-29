//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation
import UIKit

// MARK: - TranslateViewController

class TranslateViewController: UIViewController {
        
        // MARK: - Properties
        private let translationService = TranslationServiceImplementation()
        private var textToTranslate: String = ""
        private var translatedText: String = ""
        
        // MARK: View Life cycles
        override func viewDidLoad() {
            super.viewDidLoad()
            prepareView()
        }
        
        // MARK: Prepare View
        private func prepareView() {
            textToTranslateTextField.placeholder = "Text to translate"
            translatedTextLabel.text = "TRANSLATED TEXT"
            translateButton.setTitle("Translate", for: .normal)
            translateButton.setTitleColor(.white, for: .normal)
            translateButton.backgroundColor = .systemBlue
            translateButton.layer.cornerRadius = 5
            translateButton.layer.masksToBounds = true
            activityIndicator.isHidden = true
        }
        
        // MARK: - Outlets
        @IBOutlet weak var textToTranslateTextField: UITextField!
        @IBOutlet weak var translatedTextLabel: UILabel!
        @IBOutlet weak var translateButton: UIButton!
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
        // MARK: - Actions
        @IBAction func onTranslateTapped(_ sender: UIButton) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            textToTranslateTextField.resignFirstResponder()
            textToTranslate = textToTranslateTextField.text ?? ""
            textToTranslate = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            
            translationService.getTranslation(request: TranslationRequest(source: "fr", target: "en", text: textToTranslate)) { (success, response) in
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                if success, let response = response {
                    self.translatedText = response.translatedText
                    self.translatedTextLabel.text = self.translatedText
                    
                } else {
                    self.translatedTextLabel.text = "Error"
                }
            }
        }
}
