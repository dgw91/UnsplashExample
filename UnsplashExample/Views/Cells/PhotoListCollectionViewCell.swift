//
//  PhotoListCollectionViewCell.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation
import UIKit
class PhotoListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoListCollectionViewCell"
        
    private let photoListImage: UIImageView = {
        let photoListImage = UIImageView()
        photoListImage.clipsToBounds = true
        photoListImage.contentMode = .scaleAspectFill
        return photoListImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoListImage)
    }
    // This is required, but we shouldn't ever use it
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoListImage.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoListImage.image = nil
    }
    
    // Downloads image from the URL supplied by Unsplash
    func setCellImage(url: String) {
        guard let image = URL(string: url) else { return }
        URLSession.shared.dataTask(with: image) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let imageFromData = UIImage(data: data)
                self?.photoListImage.image = imageFromData
            }
        }.resume()
    }
}
