//
//  TodayViewController.swift
//  SwidgetTodayExtension
//
//  Created by Art on 4/2/2563 BE.
//  Copyright © 2563 Art. All rights reserved.
//

import UIKit
import NotificationCenter
import CryptoCurrencyKit

class TodayViewController: UIViewController {
        
    @IBOutlet private weak var mainLabel: UILabel!
    private var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = ""
        mainLabel.isHidden = true
        
        setUpViews()
        addViews()
        activateConstraints()
    }
    
    private func setUpViews() {
        loadingIndicator = {
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.hidesWhenStopped = true
            indicator.color = .systemPink
            return indicator
        }()
    }
    
    private func addViews() {
        view.addSubview(loadingIndicator)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.layoutIfNeeded()
    }
}

// MARK: - NCWidgetProviding
extension TodayViewController: NCWidgetProviding {
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        defer {
            loadingIndicator.stopAnimating()
            mainLabel.isHidden = false
        }
        
        mainLabel.isHidden = true
        loadingIndicator.startAnimating()
        
        CryptoCurrencyKit.fetchTickers { response in
            switch response {
            case .success(let tickers):
                self.mainLabel.text = "\(tickers)"
                completionHandler(.newData)
                
            case .failure(let error):
                self.mainLabel.text = "\(error)"
                completionHandler(.failed)
            }
        }
    }
}
