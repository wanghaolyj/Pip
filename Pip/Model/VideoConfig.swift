//
//  VideoConfig.swift
//  Pip
//
//  Created by 王浩 on 2024/12/2.
//

import UIKit
import AVFoundation

struct VideoConfig {
    let size: CGSize       // 视频分辨率
    let fps: Int32         // 帧率
    let duration: Int      // 持续时间（秒）
    let fileType: AVFileType // 视频文件类型
    let codec: AVVideoCodecType // 视频编码格式
    
    var totalFrames: Int {
        return duration * Int(fps)
    }
    
    init(
            size: CGSize = CGSize(width: 1920, height: 1080),
            fps: Int32 = 30,
            duration: Int,
            fileType: AVFileType = .mp4,
            codec: AVVideoCodecType = .h264
        ) {
            self.size = size
            self.fps = fps
            self.duration = duration
            self.fileType = fileType
            self.codec = codec
        }
}
