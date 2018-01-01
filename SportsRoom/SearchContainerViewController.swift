//
//  SearchContainerViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2018-01-01.
//  Copyright © 2018 Javier Xing. All rights reserved.
//

import UIKit

protocol SearchContainerProtocol {
    func close()
    func search()
}

class SearchContainerViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchLocation: UITextField!
    var delegate: SearchContainerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
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
    

}
