//
//  ViewController.swift
//  Jestock
//
//  Created by Jeremy Jason on 17/12/20.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var stockOpenLabel: UILabel!
    @IBOutlet weak var stockHighLabel: UILabel!
    @IBOutlet weak var stockLowLabel: UILabel!
    @IBOutlet weak var stockDateLabel: UILabel!
    @IBOutlet weak var stockTextField: UITextField!
    
    @IBOutlet weak var box1: UIView!
    @IBOutlet weak var box2: UIView!
    @IBOutlet weak var box3: UIView!
    //the graph it just for the design
    @IBOutlet weak var graph: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cornerradius
        box1.layer.cornerRadius = 20
        box2.layer.cornerRadius = 20
        box3.layer.cornerRadius = 20
        
        
        resetLabels()
        self.stockTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func stockSearchTapped(_ sender: Any) {
        getStockQuote()
        dismissKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getStockQuote()
        self.view.endEditing(true)
        return false
    }
    
    func getStockQuote() {
        let session = URLSession.shared
        //url and api key
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(stockTextField.text ?? "")&apikey=7I7FV9O5TV2GHOLK")!
        
        let dataTask = session.dataTask(with: quoteURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("All the quote data:\n\(dataString!)")
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        if let quoteDictionary = jsonObj.value(forKey: "Global Quote") as? NSDictionary {
                            DispatchQueue.main.async {
                                if let symbol = quoteDictionary.value(forKey: "01. symbol") {
                                    self.stockSymbolLabel.text = symbol as? String
                                }
                                if let open = quoteDictionary.value(forKey: "02. open") {
                                    self.stockOpenLabel.text = open as? String
                                }
                                if let high = quoteDictionary.value(forKey: "03. high") {
                                    self.stockHighLabel.text = high as? String
                                }
                                if let low = quoteDictionary.value(forKey: "04. low") {
                                    self.stockLowLabel.text = low as? String
                                }
                                if let date = quoteDictionary.value(forKey: "07. latest trading day") {
                                    self.stockDateLabel.text = date as? String
                                }
                                self.graph.alpha = 1

                            }
                        } else {
                            print("Error: unable to find quote")
                            DispatchQueue.main.async {
                                self.resetLabels()
                            }
                        }
                    } else {
                        print("Error: unable to convert json data")
                        DispatchQueue.main.async {
                            self.resetLabels()
                        }
                    }
                } else {
                    print("Error: did not receive data")
                    DispatchQueue.main.async {
                        self.resetLabels()
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func resetLabels() {
        stockSymbolLabel.text = "";
        stockOpenLabel.text = "";
        stockHighLabel.text = "";
        stockLowLabel.text = "";
        stockDateLabel.text = "";
        //the graph it just for the design
        graph.alpha = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

