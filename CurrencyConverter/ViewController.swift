//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Chris Eidhof on 18.07.17.
//  Copyright © 2017 objc.io. All rights reserved.
//

import UIKit

let ratesURL = URL(string: "http://api.fixer.io/latest?base=EUR")!

class CurrencyViewController: UIViewController, UITextFieldDelegate {
    let input: UITextField = {
        let result = UITextField()
        result.text = "100"
        result.borderStyle = .roundedRect
        return result
    }()
    let button: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle("Reload", for: .normal)
        return result
    }()
    let output: UILabel = {
        let result = UILabel()
        result.text = "..."
        return result
    }()
    let stackView: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stackView.addArrangedSubview(input)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(output)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            ])

        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        input.addTarget(self, action: #selector(inputChanged), for: .editingChanged)
    }

    var rate: Double?
    @objc func inputChanged() {
        guard let text = input.text, let number = Double(text) else {
            input.backgroundColor = .red
            return
        }
        input.backgroundColor = .white
        guard let rate = rate else { return }
        output.text = "\(number * rate) USD"
    }

    @objc func reload() {
        URLSession
            .shared
            .dataTask(with: ratesURL) { (data, _, _) in
                guard
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let dict = json as? [String : Any],
                    let dataDict = dict["rates"] as? [String : Double],
                    let rate = dataDict["USD"]
                    else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.rate = rate
                    self?.inputChanged()
                }
            }
            .resume()
    }
}
