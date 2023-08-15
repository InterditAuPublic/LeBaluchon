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
        
        textToTranslateLabel.text = "Text to translate :"
        translatedLabel.text = "Translation :"
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
         scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

         // Contraintes pour la UIStackView
         verticalStackView.translatesAutoresizingMaskIntoConstraints = false
         verticalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
         verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
         verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
         verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
         verticalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
         
         // Contraintes pour les UIView à l'intérieur de la UIStackView (textToTranslateViewContainer et translatedTextViewContrainer doivent être de taille égale)
         textToTranslateViewContainer.translatesAutoresizingMaskIntoConstraints = false
         translatedTextViewContrainer.translatesAutoresizingMaskIntoConstraints = false
         textToTranslateViewContainer.widthAnchor.constraint(equalTo: translatedTextViewContrainer.widthAnchor).isActive = true

         // Contraintes pour les Labels
         let topSpacing: CGFloat = 16.0
         textToTranslateLabel.translatesAutoresizingMaskIntoConstraints = false
         textToTranslateLabel.topAnchor.constraint(equalTo: textToTranslateViewContainer.topAnchor, constant: topSpacing).isActive = true
         textToTranslateLabel.centerXAnchor.constraint(equalTo: textToTranslateViewContainer.centerXAnchor).isActive = true

         translatedLabel.translatesAutoresizingMaskIntoConstraints = false
         translatedLabel.topAnchor.constraint(equalTo: translatedTextViewContrainer.topAnchor, constant: topSpacing).isActive = true
         translatedLabel.centerXAnchor.constraint(equalTo: translatedTextViewContrainer.centerXAnchor).isActive = true

         // Contraintes pour les UITextView
         textToTranslateTextView.translatesAutoresizingMaskIntoConstraints = false
         translatedTextView.translatesAutoresizingMaskIntoConstraints = false
         textToTranslateTextView.widthAnchor.constraint(equalTo: translatedTextView.widthAnchor).isActive = true
         textToTranslateTextView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
         translatedTextView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        textToTranslateTextView.layer.borderWidth = 1.0 // Épaisseur de la bordure (en points)
        textToTranslateTextView.layer.borderColor = UIColor.lightGray.cgColor // Couleur de la bordure
        translatedTextView.layer.borderWidth = 1.0 // Épaisseur de la bordure (en points)
                translatedTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        translatedTextView.isEditable = false


         // Ajout d'une contrainte pour aligner les UITextView verticalement
         textToTranslateTextView.centerYAnchor.constraint(equalTo: textToTranslateViewContainer.centerYAnchor).isActive = true
         translatedTextView.centerYAnchor.constraint(equalTo: translatedTextViewContrainer.centerYAnchor).isActive = true
         textToTranslateTextView.leadingAnchor.constraint(equalTo: textToTranslateViewContainer.leadingAnchor, constant: 16.0).isActive = true
         textToTranslateTextView.trailingAnchor.constraint(equalTo: textToTranslateViewContainer.trailingAnchor, constant: -16.0).isActive = true
         translatedTextView.leadingAnchor.constraint(equalTo: translatedTextViewContrainer.leadingAnchor, constant: 16.0).isActive = true
         translatedTextView.trailingAnchor.constraint(equalTo: translatedTextViewContrainer.trailingAnchor, constant: -16.0).isActive = true

         // Contrainte pour le bouton de traduction
         translateButton.translatesAutoresizingMaskIntoConstraints = false
         translateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         translateButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16.0).isActive = true
         translateButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
         translateButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true

         // Contrainte pour l'indicateur d'activité
         activityIndicator.translatesAutoresizingMaskIntoConstraints = false
         activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
            return UIAlertHelper.showAlertWithTitle("Error", message: "Please enter a text to translate", from: self)
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        textToTranslateTextView.resignFirstResponder()
        self.textToTranslate = textToTranslateTextView.text ?? ""
        self.textToTranslate = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""

        translationService.getTranslation(request: TranslationRequest(source: "fr", target: "en", text: self.textToTranslate)) { (success, response) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            if success, let response = response {
                self.translatedText = response.translatedText
                self.translatedTextView.text = self.translatedText
            } else {
                
                self.translatedTextView.text = "Error"
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
