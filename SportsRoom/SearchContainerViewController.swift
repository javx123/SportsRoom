//
//  SearchContainerViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2018-01-01.
//  Copyright © 2018 Javier Xing. All rights reserved.
//

import UIKit
import SHSearchBar
import ChameleonFramework
import DropDown

protocol SearchContainerProtocol {
    func close()
    func search()
    func chooseSearchLocation()
    func searchCurrentLocation()
}

class SearchContainerViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchLocationView: UIView!
    @IBOutlet weak var searchLocationLabel: UILabel!
    
    let dropDown = DropDown()
    var delegate: SearchContainerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = .white
        searchBar.tintColor = .flatYellow
        searchBar.placeholder = "Search (e.g. Soccer)"
        searchBar.enablesReturnKeyAutomatically = true
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = .flatYellow
        
        
//        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
//        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
//
//        clearButton.tintColor = UIColor.flatYellow
        
        
        
        dropDown.anchorView = searchLocationView
        dropDown.dataSource = ["Current Location", "Custom Location..."]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.backgroundColor = UIColor.flatNavyBlueDark
        dropDown.textColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.flatYellow
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropDown.selectionAction = { (index: Int, item: String) in
            self.searchLocationLabel.textColor = UIColor.white
            self.searchLocationLabel.text = item
            if item == "Current Location" {
//                set search location to current location
                self.delegate?.searchCurrentLocation()
            }
            
            if item == "Custom Location..." {
//                present selectLocationViewController
                self.delegate?.chooseSearchLocation()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }

    @IBAction func search(_ sender: Any) {
        delegate?.close()
        delegate?.search()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        delegate?.close()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.close()
        delegate?.search()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    @IBAction func searchLocationDropDown(_ sender: Any) {
//        searchLocationLabel.text = ""
        dropDown.show()
//        searchLocationView.becomeFirstResponder()
        searchBar.resignFirstResponder()

        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
//        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
//
//        clearButton.tintColor = UIColor.flatYellow
    }
    
}
