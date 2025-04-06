//
//  PostCell.swift
//  ios101-project6-tumblr
//

import UIKit
import Nuke

class PostCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    // Add this configuration method
    func configure(with post: Post) {
        summaryLabel.text = post.summary
        
        if let photo = post.photos.first {
            Nuke.loadImage(with: photo.originalSize.url, into: postImageView)
        }
    }
}
