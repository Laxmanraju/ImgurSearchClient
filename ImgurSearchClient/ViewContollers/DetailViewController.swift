//
//  DetailViewController.swift
//  ImgurSearchClient
//
//  Created by Laxman Penmesta on 6/27/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var titleString: String?
    var imageLink: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleString
    }
    override func viewDidAppear(_ animated: Bool) {
       displayImageOrPlayVideo()
    }
    
    func displayImageOrPlayVideo()  {
        if imageLink.contains(".mp4"){
            playVideo()
        }else{
            displayImage()
        }
    }
    
    func displayImage() {
        if let url = URL(string: imageLink){
            self.imageView.kf.setImage(with: url)
        }
    }
    
    func playVideo()  {
        if let videoURL = URL(string: imageLink){
            let player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
        }
    }
}
