//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Chris Eidhof on 18.07.17.
//  Copyright © 2017 objc.io. All rights reserved.
//

import UIKit

let ratesURL = URL(string: "http://api.fixer.io/latest?base=EUR")!

struct State {
    private var inputText: String? = nil
    private var rate: Double? = nil

    enum Message {
        case setInputText(String?)
        case dataReceived(Data?)
    }

    mutating func send(_ message: Message) {
        switch message {
        case .setInputText(let text):
            inputText = text
        case .dataReceived(let data):
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let dict = json as? [String : Any],
                let dataDict = dict["rates"] as? [String : Double]
                else { return }
            rate = dataDict["USD"]
        }
    }

    var inputAmount: Double? {
        guard
            let text = inputText,
            let number = Double(text)
            else { return nil }
        return number
    }

    var outputAmount: Double? {
        guard
            let input = inputAmount,
            let rate = rate
            else { return nil }
        return input * rate
    }
}

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

    var state = State() {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        input.backgroundColor = state.inputAmount == nil ? .red : .white
        output.text = state.outputAmount.map { "\($0) USD" } ?? "..."
    }

    @objc func inputChanged() {
        state.send(State.Message.setInputText(input.text))
    }

    @objc func reload() {
        URLSession
            .shared
            .dataTask(with: ratesURL) { (data, _, _) in
                DispatchQueue.main.async { [weak self] in
                    self?.state.send(.dataReceived(data))
                }
            }
            .resume()
    }
}
