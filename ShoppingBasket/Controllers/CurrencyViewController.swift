//
//  CurrencyViewController.swift
//  ShoppingBasket
//
//  Created by Imran on 2/2/19.
//  Copyright © 2019 Imran. All rights reserved.
//

import UIKit

let accessKey = "98ef994c0ac0471c5679369b6a6dceb6"
let errorTitle = "Service Error"
let errorMessage = "Unable to download currency data."

class CurrencyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var currencyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyTableView.delegate = self
        self.currencyTableView.dataSource = self
        self.fetchCurrencyList()
        // Do any additional setup after loading the view.
    }
    //Mark: - TableView DataSource/Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currencyCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell")
        let aCurrency = currencyCollection[indexPath.row]
        
        cell?.textLabel!.text = aCurrency.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.findExchangeRate(withSelectedCurrency: currencyCollection[indexPath.row])
    }
    
    //Mark: - Service calls
    func fetchCurrencyList()
    {
        guard let url = URL(string: "http://apilayer.net/api/list?access_key=\(accessKey)") else {
            self.showCurrencySeriveError()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    self.showCurrencySeriveError()
                    return
            }
            do{
                //response data
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: []) as AnyObject
                print(jsonResponse)
                
                if let currencies = jsonResponse["currencies"] as? [String: String] {
                    for aCurrency in currencies
                    {
                        let currency = Currency(code: aCurrency.0, name: aCurrency.1)
                        self.currencyCollection.append(currency)
                    }
                    
                    //Sorting currency list in alphabetical order
                    self.currencyCollection.sort(by: { (c1, c2) -> Bool in
                        c1.name < c2.name
                    })
                    
                    //refresh screen
                    DispatchQueue.main.async {
                        self.currencyTableView.reloadData()
                    }
                }
            } catch {
                self.showCurrencySeriveError()
            }
        }
        task.resume()
    }
        
    func findExchangeRate(withSelectedCurrency currency: Currency) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: NSDate() as Date)
        print (dateString)
        let urlString = String(format:"http://apilayer.net/api/historical?access_key=\(accessKey)&date=%@", dateString)
        
        guard let url = URL(string: urlString) else {
            self.showCurrencySeriveError()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    self.showCurrencySeriveError()
                    return
            }
            do {
                //response data
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: []) as AnyObject
                print(jsonResponse) //Response result
                
                selectedCurrency = currency
                if let quotes = jsonResponse["quotes"] as? [String: AnyObject] {
                    print(quotes[currency.code] ?? "")
                    let desiredCurrencyCode = "USD\(currency.code)"
                    for aQuote in quotes
                    {
                        if desiredCurrencyCode == aQuote.0
                        {
                            exchangeRate = Double(truncating: aQuote.1 as! NSNumber)
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                
            } catch {
                self.showCurrencySeriveError()
            }
        }
        task.resume()
    }
    
    //Mark: - Currency Error
    func showCurrencySeriveError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //Mark: - Dismiss Modal
    @IBAction func cancelPressed(sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
