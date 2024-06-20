//
//  ViewController.swift
//  StudyDecimalNumber
//
//  Created by MacBook Pro on 6/20/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let d1 = "-456".decimalNumber
        let d2 = NSDecimalNumber(string: "+1")
        let d3 = d1 + d2
        print(d1, d2, d3)
        
    }


}

