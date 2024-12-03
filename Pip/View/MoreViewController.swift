//
//  MoreViewController.swift
//  Pip
//
//  Created by 王浩 on 2024/12/2.
//

import UIKit
import AVKit

class MoreViewController: UIViewController {
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var pipController: AVPictureInPictureController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "更多有意思的事情"
        self.view.backgroundColor = .systemBackground
        
        
        // 创建 AVPlayerLayer 并添加到视图
        if let url = VideoHelper.shared.getSampleVideo() {
            let asset = AVAsset.init(url: url)
            let playerItem = AVPlayerItem.init(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            
            player.isMuted = true
            player.allowsExternalPlayback = true
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = .init(origin: .init(x: 20, y: view.safeAreaInsets.top), size: .init(width: view.frame.width - 40, height: 300))
            playerLayer.backgroundColor = UIColor.red.cgColor
            view.layer.addSublayer(playerLayer)
            player.play()
        }
        
        let button = UIButton(type: .system)
        button.frame = .init(origin: .zero, size: .init(width: 100, height: 40))
        button.setTitle("开启画中画", for: .normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        button.center = self.view.center
        
        
        guard AVPictureInPictureController.isPictureInPictureSupported(),
              let playerLayer = playerLayer else { return }
        
        if pipController == nil {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController?.delegate = self
            // 隐藏播放按钮、快进快退按钮
            pipController?.setValue(1, forKey: "controlsStyle")
            if #available(iOS 14.2, *) {
                pipController?.canStartPictureInPictureAutomaticallyFromInline = true
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func play() {
        
       
        if pipController?.isPictureInPictureActive == true {
            pipController?.stopPictureInPicture()
        } else {
            pipController?.startPictureInPicture()
        }
    }
    
}

extension MoreViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画即将开始")
        if let window = UIApplication.shared.windows.first {
            let view = UIView()
            view.backgroundColor = .red
            window.addSubview(view)
            view.frame = window.bounds
        }
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画已开始")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画即将停止")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("画中画已停止")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("画中画启动失败: \(error.localizedDescription)")
    }
}
