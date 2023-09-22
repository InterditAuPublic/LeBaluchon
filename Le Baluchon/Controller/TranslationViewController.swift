//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation
import UIKit

// MARK: - TranslateViewController

class TranslationViewController: UIViewController {
    
    // MARK: - Properties
    private let translationService = TranslationServiceImplementation()
    private var textToTranslate: String = ""
    private var translatedText: String = ""
    private var tapGesture: UITapGestureRecognizer?
//    private var alert = UIAlertHelper()
    
    // MARK: View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        addTapGesture()
        registerKeyboardNotifications()
        setupConstraints()
    }
    
    // MARK: Prepare View
    private func prepareView() {
        
        textToTranslateLabel.text = "Text to translate (fr) :"
        translatedLabel.text = "Translation (en) :"
        translateButton.setTitle("Translate", for: .normal)
        translateButton.setTitleColor(.white, for: .normal)
        translateButton.backgroundColor = .systemBlue
        translateButton.layer.cornerRadius = 5
        translateButton.layer.masksToBounds = true
        activityIndicator.isHidden = true
        
        textToTranslateTextView.text = ""
        translatedTextView.text = ""
    }
    
    private func setupConstraints() {
         // Contraintes pour la UIScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

// Contraintes pour la UIStackView
verticalStackView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    verticalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
    verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
    verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
    verticalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
])

// Contraintes pour les UIView à l'intérieur de la UIStackView
textToTranslateViewContainer.translatesAutoresizingMaskIntoConstraints = false
translatedTextViewContrainer.translatesAutoresizingMaskIntoConstraints = false

// Contraintes pour les Labels
let topSpacing: CGFloat = 16.0
textToTranslateLabel.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    textToTranslateLabel.topAnchor.constraint(equalTo: textToTranslateViewContainer.topAnchor, constant: topSpacing),
    textToTranslateLabel.centerXAnchor.constraint(equalTo: textToTranslateViewContainer.centerXAnchor)
])

translatedLabel.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    translatedLabel.topAnchor.constraint(equalTo: translatedTextViewContrainer.topAnchor, constant: topSpacing),
    translatedLabel.centerXAnchor.constraint(equalTo: translatedTextViewContrainer.centerXAnchor)
])

// Contraintes pour les UITextView
textToTranslateTextView.translatesAutoresizingMaskIntoConstraints = false
translatedTextView.translatesAutoresizingMaskIntoConstraints = false
        textToTranslateTextView.layer.borderWidth = 1.0 // Épaisseur de la bordure (en points)
        textToTranslateTextView.layer.borderColor = UIColor.lightGray.cgColor // Couleur de la bordure
        translatedTextView.layer.borderWidth = 1.0 // Épaisseur de la bordure (en points)
                translatedTextView.layer.borderColor = UIColor.lightGray.cgColor
NSLayoutConstraint.activate([
    textToTranslateTextView.leadingAnchor.constraint(equalTo: textToTranslateViewContainer.leadingAnchor, constant: 16.0),
    textToTranslateTextView.trailingAnchor.constraint(equalTo: textToTranslateViewContainer.trailingAnchor, constant: -16.0),
    translatedTextView.leadingAnchor.constraint(equalTo: translatedTextViewContrainer.leadingAnchor, constant: 16.0),
    translatedTextView.trailingAnchor.constraint(equalTo: translatedTextViewContrainer.trailingAnchor, constant: -16.0)
])

// Contraintes pour la hauteur des UITextView
NSLayoutConstraint.activate([
    textToTranslateTextView.heightAnchor.constraint(equalToConstant: 150.0),
    translatedTextView.heightAnchor.constraint(equalToConstant: 150.0)
])

// Desactiver le clique sur TransalateTextView
translatedTextView.isEditable = false

// Contrainte pour aligner les UITextView verticalement
NSLayoutConstraint.activate([
    textToTranslateTextView.centerYAnchor.constraint(equalTo: textToTranslateViewContainer.centerYAnchor),
    translatedTextView.centerYAnchor.constraint(equalTo: translatedTextViewContrainer.centerYAnchor)
])

// Contrainte pour le bouton de traduction, le placer en dessous de la TRanslatedTextView
translateButton.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    translateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    translateButton.topAnchor.constraint(equalTo: translatedTextView.bottomAnchor, constant: 1.0),
    translateButton.widthAnchor.constraint(equalToConstant: 200.0),
    translateButton.heightAnchor.constraint(equalToConstant: 40.0)
])

// Contrainte pour l'indicateur d'activité
activityIndicator.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])

     }
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textToTranslateViewContainer: UIView!
    @IBOutlet weak var textToTranslateLabel: UILabel!
    @IBOutlet weak var textToTranslateTextView: UITextView!
    
    @IBOutlet weak var translatedTextViewContrainer: UIView!
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var translatedTextView: UITextView!
    
    // MARK: - Actions
    
    @IBAction func onTranslateTapped(_ sender: UIButton) {


            guard let textToTranslate = textToTranslateTextView.text, !textToTranslate.isEmpty else {
                UIAlertHelper.showAlertWithTitle("Error", message: "Please enter a text to translate", from: self)
                return
            }
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            textToTranslateTextView.resignFirstResponder()
            
            let textToTranslateEncoded = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let translationRequest = TranslationRequest(source: "fr", target: "en", text: textToTranslateEncoded)
            
            translationService.getTranslation(request: translationRequest) { result in
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let response):
                    self.translatedText = response.translatedText
                    self.translatedTextView.text = self.translatedText
                case .failure(let error):
                    self.translatedTextView.text = "Error: \(error.localizedDescription)"
                }
            }

    }
    
    // MARK: - Tap Gesture
    
    private func addTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc private func handleTap() {
        textToTranslateTextView.resignFirstResponder()
    }
    
    // MARK: - Keyboard
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}
