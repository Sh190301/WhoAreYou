//
//  NotVerifiedVC.swift
//  API+DB
//
//  Created by Shreya Das on 29/05/22.
//

import UIKit
import SDWebImage

class NotVerifiedVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.sd_imageTransition = .fade
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: capturedImageURL), placeholderImage: UIImage(named: "Abstract"))
        label.text = messageData
        // Do any additional setup after loading the view.
    }
    
    
    

}
