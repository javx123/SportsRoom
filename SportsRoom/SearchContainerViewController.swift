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

class SearchContainerViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchLocation: UITextField!
    var delegate: SearchContainerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func search(_ sender: Any) {
        delegate?.close()
        delegate?.search()
    }
    

}
