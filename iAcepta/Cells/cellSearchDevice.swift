//
//  cellSearchDevice.swift
//  iAcepta
//
//  Created by QUALITY on 9/13/19.
//  Copyright © 2019 Quality & Knowledge. All rights reserved.
//

import Foundation
import UIKit

class cellSearchDevice: UITableViewCell  {
    
    @IBOutlet weak var nameDevice: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setChecked(checked:Bool){
        if (checked) {
            imgCheck.image = UIImage(named:"select_wisepad")
        }else{
            imgCheck.image = nil
        }
    }
}
