//
//  NYPostCell.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import UIKit

class NYPostCell: UITableViewCell {
    
    @IBOutlet weak var imgNYPost: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgNYPost.layer.cornerRadius = self.imgNYPost.bounds.size.height / 2;
        self.imgNYPost.layer.masksToBounds = true;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
