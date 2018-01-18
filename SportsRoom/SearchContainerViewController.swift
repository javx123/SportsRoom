//
//  SearchContainerViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2018-01-01.
//  Copyright © 2018 Javier Xing. All rights reserved.
//

import UIKit
import ChameleonFramework
import DropDown
import ModernSearchBar

protocol SearchContainerProtocol {
    func close()
    func search()
    func chooseSearchLocation()
    func searchCurrentLocation()
}

class SearchContainerViewController: UIViewController, ModernSearchBarDelegate {
    
    @IBOutlet weak var searchBar: ModernSearchBar!
    @IBOutlet weak var searchLocationView: UIView!
    @IBOutlet weak var searchLocationLabel: UILabel!
    
    let dropDown = DropDown()
    var searchDelegate: SearchContainerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegateModernSearchBar = self
        configureSearchBar()
        setupDropDown()
        setupModernSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.setShowsCancelButton(true, animated: true)
        dropDown.selectionAction = { (index: Int, item: String) in
            self.searchLocationLabel.textColor = UIColor.white
            self.searchLocationLabel.text = item
            if item == "Current Location" {
                self.searchDelegate?.searchCurrentLocation()
            }
            
            if item == "Custom Location..." {
                self.searchDelegate?.chooseSearchLocation()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
    
    //MARK: - Setup the View
    
    func configureSearchBar() {
    
    let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.textColor = .white
    searchBar.tintColor = .flatYellow
    searchBar.placeholder = "Search (e.g. Soccer)"
    searchBar.enablesReturnKeyAutomatically = true
    
    let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
    glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
    glassIconView?.tintColor = .flatYellow

    }
    
    func setupDropDown() {
        dropDown.anchorView = searchLocationView
        dropDown.dataSource = ["Current Location", "Custom Location..."]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.backgroundColor = UIColor.flatNavyBlueDark
        dropDown.textColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.flatYellow
    }
    
    func setupModernSearch() {
        let sportSuggestionList = ["Baseball", "Basketball", "Hockey", "Soccer", "Football", "Tennis", "Softball", "Table Tennis", "Squash", "Ultimate", "Rugby"]
        searchBar.setDatas(datas: sportSuggestionList)
        
        searchBar.searchLabel_textColor = .white
        
        searchBar.suggestionsView_backgroundColor = .flatNavyBlue
        searchBar.suggestionsView_contentViewColor = .flatNavyBlue
        searchBar.suggestionsView_selectionStyle = UITableViewCellSelectionStyle.gray
    }
    
        //MARK: - Search Functions

    @IBAction func search(_ sender: Any) {
        searchDelegate?.close()
        searchDelegate?.search()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        enableCancelButton()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchDelegate?.close()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchDelegate?.close()
        searchDelegate?.search()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func onClickItemSuggestionsView(item: String) {
        searchBar.text = item
        searchBar.resignFirstResponder()
        enableCancelButton()
    }
    
    func onClickShadowView(shadowView: UIView) {
        searchBar.resignFirstResponder()
        enableCancelButton()
    }
    
    @IBAction func searchLocationDropDown(_ sender: Any) {
        dropDown.show()
        searchBar.resignFirstResponder()

        enableCancelButton()
    }
    
    func enableCancelButton() {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
}
