//
//  BasketViewController.swift
//  ShoppingBasket
//
//  Created by Imran on 2/2/19.
//  Copyright © 2019 Imran. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var checkmarkImageView: UIImageView!
    @IBOutlet var itemTagView: UIView!
    @IBOutlet var quantityLabel: UILabel!
}

class BasketViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet var checkoutButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pickerContainerView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        checkoutButton.isEnabled = false
        self.loadPickerView(withContainer: self.pickerContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if itemList.count > 0
        {
            self.collectionView.reloadData()
        }
    }
    
    //Mark: - CollectionView DataSource/Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCollectionViewCell
        let item = itemList[indexPath.row] as Item
        cell.itemName.text = item.name
        cell.itemPrice.text = self.pricePerItemDescription(item: item)
        
        if item.quantity > 0
        {
            cell.itemTagView.backgroundColor = greenColor
            cell.checkmarkImageView.image = UIImage.init(named: "icon_checkmark")
            cell.quantityLabel.text = String(item.quantity)
            checkoutButton.isEnabled = true
        }
        else
        {
            cell.itemTagView.backgroundColor = UIColor.lightGray
            cell.checkmarkImageView.image = nil
            cell.quantityLabel.text = "Qty"
        }
        
        switch indexPath.row
        {
        case 0:
            cell.itemImageView.image = UIImage.init(named:"icon_peas")
        case 1:
            cell.itemImageView.image = UIImage.init(named:"icon_eggs")
        case 2:
            cell.itemImageView.image = UIImage.init(named:"icon_milk")
        case 3:
            cell.itemImageView.image = UIImage.init(named:"icon_beans")
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedIndexpath = indexPath
        pickerContainerView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCheckout", let checkoutController = segue.destination as? CheckoutViewController
        {
            checkoutController.itemList = self.itemList.filter({$0.quantity > 0})
        }
    }

    //Mark: - UIPickerView Delegate
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        self.checkoutButton.isEnabled = false //Enable it only time when basket has atleast one item
        collectionView.reloadData()
    }
}
