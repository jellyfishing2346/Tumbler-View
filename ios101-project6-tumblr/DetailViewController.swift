//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Faizan Khan on 4/5/25.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var summaryTextView: UITextView! // Changed from UILabel to UITextView
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        // Configure text view
        summaryTextView.text = post.summary
        summaryTextView.isEditable = false
        summaryTextView.isScrollEnabled = true
        summaryTextView.font = UIFont.systemFont(ofSize: 16)
        summaryTextView.textColor = .black
        summaryTextView.backgroundColor = .clear
        
        // Load image
        if let photo = post.photos.first {
            let imageUrl = photo.originalSize.url
            Nuke.loadImage(with: imageUrl, into: photoImageView)
        }
    }
}
