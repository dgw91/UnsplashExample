//
//  PhotoListCollectionViewLayout.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation
import UIKit

class PhotoListCollectionViewLayout: UICollectionViewFlowLayout {
    // I'm just making sure the content looks good on a varitey of devices and orientations here. Another approach would be to use adaptive layouts in storyboards, but that is a bit more time intensive. Also item size is easiest to edit here.
    override func prepare() {
        super.prepare()
        self.itemSize = CGSize(width: 172, height: 172)
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
        self.sectionInset.left = 8
        self.sectionInset.right = 8
        self.sectionInset.top = 2
        self.sectionInset.bottom = 2
    }
}
