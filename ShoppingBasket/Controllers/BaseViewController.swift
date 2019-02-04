//
//  BaseViewController.swift
//  ShoppingBasket
//
//  Created by Imran on 2/2/19.
//  Copyright © 2019 Imran. All rights reserved.
//

import UIKit

let greenColor = UIColor.init(red: 158/255.0, green: 224/255.0, blue: 0/255.0, alpha: 1.0)

struct Currency
{
    var code = " "
    var name = " "
}

class Item
{
    let id: Int
    var name: String? = ""
    var price = 0.00
    var quantity = 0
    var perItemText: String
    
    init(itemId: Int, itemName: String, itemPrice: Double, itemQuantity: Int, perItemTxt: String)
    {
        id = itemId
        name = itemName
        price = itemPrice
        quantity = itemQuantity
        perItemText = perItemTxt
    }
}

var selectedCurrency = Currency(code: "$", name: "US Dollars")
var exchangeRate = 1.0  //default

class BaseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var selectedIndexpath: IndexPath?
    var itemList = [Item(itemId: 0, itemName: "Peas", itemPrice: 0.95, itemQuantity: 0, perItemTxt: "per bag"),
                    Item(itemId: 1, itemName: "Eggs", itemPrice: 2.10, itemQuantity: 0, perItemTxt: "per dozen"),
                    Item(itemId: 2, itemName: "Milk", itemPrice: 1.30, itemQuantity: 0, perItemTxt: "per bottle"),
                    Item(itemId: 3, itemName: "Beans", itemPrice: 0.73, itemQuantity: 0, perItemTxt: "per can")]
    
    var currencyCollection = [Currency]()
    
    //Mark: - UIPickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1000
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let item = itemList[(selectedIndexpath?.row)!] as Item
        item.quantity = row
    }
    
    func pricePerItemDescription(item: Item) -> String
    {
        
        return String(format: "\(selectedCurrency.code) %.2f \(item.perItemText)", item.price * exchangeRate)
    }
    
    func priceString(price: Double) -> String
    {
        return String(format: "\(selectedCurrency.code) %.2f", price * exchangeRate)
    }
    
    func loadPickerView(withContainer pickerContainer: UIView) {
        if let pickerView = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?.first as? PickerView
        {
            pickerView.pickerView.delegate = self
            pickerView.pickerView.dataSource = self
            pickerContainer.addSubview(pickerView)
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            pickerContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":pickerView]))
            pickerContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":pickerView]))
            pickerContainer.isHidden = true
        }
    }
}
