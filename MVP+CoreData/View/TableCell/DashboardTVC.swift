//
//  UserTVC.swift
//  MVP+CoreData
//
//  Created by Umang on 17/06/23.
//

import UIKit

class DashboardTVC: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFName: UILabel!
    @IBOutlet weak var lblLName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        imgProfile.roundedCorners()
    }

}
