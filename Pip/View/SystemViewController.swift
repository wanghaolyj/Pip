//
//  SystemViewController.swift
//  Pip
//
//  Created by 王浩 on 2024/12/2.
//

import UIKit
import AVKit

class SystemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "系统播放器"
        self.view.backgroundColor = .systemBackground
        
        let button = UIButton(type: .system)
        button.frame = .init(origin: .zero, size: .init(width: 100, height: 40))
        button.setTitle("播放", for: .normal)
        self.view.addSubview(button)

        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        button.center = self.view.center
        
    }
    

    @objc func play() {
        
        
        if let url = VideoHelper.shared.getSampleVideo() {
            
            self.playVideo(url)
            
        }
        
        
    }
    
    private func playVideo(_ videoURL:URL) {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // 显示播放器
        present(playerViewController, animated: true) {
            player.play()
        }
    }

}
