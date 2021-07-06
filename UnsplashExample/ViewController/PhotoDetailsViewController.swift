//
//  PhotoDetailsViewController.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/6/21.
//

import Foundation
import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDesciptionLabel: UILabel!
    @IBOutlet weak var photographerNameLabel: UILabel!
    @IBOutlet weak var photographerUsernameLabel: UILabel!
    
   // When we are pushing viewcontroller the outlets aren't created yet. These will hold the data until they are ready
    var descLabel: String = ""
    var nameLabel: String = ""
    var userLabel: String = ""
    var thumbUrl: String = ""
    var largeUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        // At this point this call could be moved to a common place in the networking group
        guard let image = URL(string: thumbUrl) else { return }
        URLSession.shared.dataTask(with: image) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let imageFromData = UIImage(data: data)
                self?.photoImageView.image = imageFromData
            }
        }.resume()
    }
    
    func setLabels() {
        photoDesciptionLabel.text = descLabel
        photographerUsernameLabel.text = userLabel
        photographerNameLabel.text = nameLabel
    }
}
