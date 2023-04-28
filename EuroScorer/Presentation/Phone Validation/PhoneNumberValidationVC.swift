//
//  PhoneNumberValidationVC.swift
//  EuroScorer
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneNumberValidationVC: UIViewController {
    
    var didLogin: (() -> Void)?
    let phoneNumberKit = PhoneNumberKit()
    var userRegionID: String?
    var userInternationalNumberPhoneNumber: String?
    
    let v = PhoneNumberValidationView()
    private let userService: UserService
    override func loadView() { view = v }
    
    required init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
        overrideUserInterfaceStyle = .dark
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Phone Validation"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(close))
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
    func close() {
        dismiss(animated: true, completion: nil)
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
        v.okButton.isLoading = true
        guard let phoneNumberString = v.phoneNumberField.text else {
            v.okButton.isLoading = false
            return
        }
        guard let phoneNumber = try? phoneNumberKit.parse(phoneNumberString) else {
            v.okButton.isLoading = false
            return
        }
        
        userInternationalNumberPhoneNumber = phoneNumberKit.format(phoneNumber, toType: .international)
        userRegionID = phoneNumber.regionID
        
        Task { @MainActor in
            do {
                try await userService.askForPhoneNumberVerification(phoneNumber: userInternationalNumberPhoneNumber!)
                self.showSMSCodePopup()
            } catch {
                print(error)
                self.v.okButton.isLoading = false
            }
        }
    }
    
    func showSMSCodePopup() {
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
                Task { @MainActor in
                    try await self.userService.confirmPhoneNumberWith(code: smsCode)
                    self.didLogin?()
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
