//
//  DuplicateNumber.swift
//  BARO
//
//  Created by . on 2021/01/16.
//

import UIKit

class DuplicateNumber : UIViewController {
    
    @IBOutlet weak var okayBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pressOkay(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
