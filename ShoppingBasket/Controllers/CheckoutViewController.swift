//
//  CheckoutViewController.swift
//  ShoppingBasket
//
//  Created by Imran on 2/2/19.
//  Copyright © 2019 Imran. All rights reserved.
//

import UIKit

class CheckoutItemTableViewCell: UITableViewCell
{
    @IBOutlet var itemName: UILabel!
    @IBOutlet var pricePerItem: UILabel!
    @IBOutlet var itemTotal: UILabel!
    @IBOutlet var itemQuantity: UITextField!
    
}
class CheckoutViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    var totalCost = 0.00
    @IBOutlet var totalCostLabel: UILabel!
    @IBOutlet var pickerContainerView: UIView!
    @IBOutlet var checkoutTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.checkoutTableView.delegate = self
        self.checkoutTableView.dataSource = self
        self.loadPickerView(withContainer: self.pickerContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        totalCost = 0.00
        if itemList.count > 0
        {
            self.checkoutTableView.reloadData()
        }
    }
    
    //Mark: - TableView DataSource/Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! CheckoutItemTableViewCell
        let item = itemList[indexPath.row]
        cell.itemName.text = item.name
        cell.pricePerItem.text = self.pricePerItemDescription(item: item)
        cell.itemQuantity.text = String(item.quantity)
        let itemCost = item.price * Double(item.quantity)
        cell.itemTotal.text = self.priceString(price: itemCost)
        totalCost = totalCost + itemCost
        totalCostLabel.text = self.priceString(price: totalCost)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndexpath = indexPath
        self.pickerContainerView.isHidden = false
    }
    
    //Mark: - UIPickerView Delegate
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        totalCost = 0.00
        checkoutTableView.reloadData()
    }
}
