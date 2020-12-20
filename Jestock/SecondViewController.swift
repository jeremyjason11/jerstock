//
//  SecondViewController.swift
//  Jestock
//
//  Created by Jeremy Jason on 19/12/20.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var x = 0
    var isi = [String]()
    
    var symbolA = [String]()
    var openA = [String]()
    var lowA = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissKeyboard()
        self.title = "Compare"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "tableViewCell")
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Symbol", message: nil, preferredStyle: .alert)
        alert.addTextField{ (symblph) in
            symblph.placeholder = "Enter Symbol"
        }
        //user input symbol
        let action = UIAlertAction(title: "add", style: .default) { (_) in
            guard let isiSymbol = alert.textFields?.first?.text else { return }
            print(isiSymbol)
            self.isi.append(isiSymbol)
            self.x += 1
            self.getStockQuote()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    
    func getStockQuote() {
        let session = URLSession.shared
        //url and api key
        let quoteURL = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(isi[x-1] )&apikey=7I7FV9O5TV2GHOLK")!
        
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
                                    self.symbolA.append(symbol as! String)
                                }
                                if let open = quoteDictionary.value(forKey: "02. open") {
                                    self.openA.append(open as! String)
                                }
                                if let low = quoteDictionary.value(forKey: "04. low") {
                                    self.lowA.append(low as! String)
                                }
                                self.tableView.reloadData()
                            }
                        } else {
                            print("Error: unable to find quote")
                            DispatchQueue.main.async {}
                        }
                    } else {
                        print("Error: unable to convert json data")
                        DispatchQueue.main.async {}
                    }
                } else {
                    print("Error: did not receive data")
                    DispatchQueue.main.async {}
                }
            }
        }
        dataTask.resume()
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


//set up data source
extension SecondViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        //isi data
        cell.commonInit("\(symbolA[x-1])", open: "\(openA[x-1])", low: "\(lowA[x-1])")
        
        return cell
    }
    
    
}
