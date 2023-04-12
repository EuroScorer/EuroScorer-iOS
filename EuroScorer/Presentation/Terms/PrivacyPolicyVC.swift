//
//  PrivacyPolicyVC.swift
//  EuroScorer
//
//  Created by Sacha DSO on 05/05/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Firebase

class PrivacyPolicyVC: UIViewController {
    
    var didAccept = {}
    var v = PrivacyPolicyView()
    override func loadView() { view = v }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(close))

        v.button.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        
        let privacyPolicyHTML = RemoteConfig.remoteConfig()["privacyPolicy"].stringValue ?? ""
        let css = """
        <style>
            p, li {
                font-size: 14px;
            }
            body {
                font-family: -apple-system;
            }
        </style>
        """
        
        let htmlData = NSString(string:  css + privacyPolicyHTML).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                  options: options,
                                                                  documentAttributes: nil)
        attributedString?.addAttributes([
            .foregroundColor: UIColor.white], range: NSRange(location: 0, length: attributedString?.length ?? 0))
        
        v.textView.attributedText = attributedString
        
    }

    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func acceptButtonTapped() {
        didAccept()
    }
}
