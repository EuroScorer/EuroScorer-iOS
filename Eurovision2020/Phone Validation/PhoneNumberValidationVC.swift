//
//  PhoneNumberValidationVC.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import FirebaseAuth
import PhoneNumberKit

class PhoneNumberValidationVC: UIViewController {
    
    var didLogin: (() -> Void)?
    let phoneNumberKit = PhoneNumberKit()
    var userRegionID: String?
    var userInternationalNumberPhoneNumber: String?
    
    let v = PhoneNumberValidationView()
    override func loadView() { view = v }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        overrideUserInterfaceStyle = .dark
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Phone Validation"
        v.okButton.isEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        v.blurredbackground.addGestureRecognizer(tap)
     
        
        v.okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        v.phoneNumberField.addTarget(self, action: #selector(phoneNumberChanged), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.phoneNumberField.becomeFirstResponder()
    }
    
    @objc
    func phoneNumberChanged() {
        guard let phoneNumberString = v.phoneNumberField.text else { return }
        let phoneNumber = try? phoneNumberKit.parse(phoneNumberString)
        v.okButton.isEnabled = (phoneNumber != nil)
    }
    
    @objc
    func tapped() {
        view.endEditing(true)
    }
    
    @objc
    func okTapped() {
        v.okButton.isEnabled = false
        guard let phoneNumberString = v.phoneNumberField.text else {
            v.okButton.isEnabled = true
            return
        }
        guard let phoneNumber = try? phoneNumberKit.parse(phoneNumberString) else {
            v.okButton.isEnabled = true
            return
        }
        
        userInternationalNumberPhoneNumber = phoneNumberKit.format(phoneNumber, toType: .international)
        userRegionID = phoneNumber.regionID
                
        // Localize sms sent to user's laguage
        Auth.auth().languageCode = Locale.current.languageCode ?? "en"
        
        // Start SMS confirmation
        PhoneAuthProvider.provider().verifyPhoneNumber(userInternationalNumberPhoneNumber!, uiDelegate: nil) { [weak self] (verificationID, error) in
            guard let verificationID = verificationID else {
                self?.v.okButton.isEnabled = true
                return
            }

            // Ask for SMS confirmation code.
            let alert = UIAlertController(title: "SMS confirmation",
                                          message: "Confim your phone number by entering the code received via SMS",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addTextField {
                $0.placeholder = "Code"
                $0.keyboardType = .numberPad
                $0.keyboardType = .numberPad
                $0.font = .systemFont(ofSize: 40, weight: .bold)
            }
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { a in
                if let smsCode = alert.textFields?.first?.text {
                    // Confirm Phone number with both verificationID amd SMS code.
                    self?.authWith(id: verificationID, code: smsCode)
                }
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func authWith(id: String, code: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            self?.didLogin?()
        }
    }
}
