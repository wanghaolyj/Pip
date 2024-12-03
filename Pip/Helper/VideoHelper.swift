//
//  VideoHelper.swift
//  Pip
//
//  Created by 王浩 on 2024/12/2.
//

import Foundation

class VideoHelper {
    public class var shared: VideoHelper {
        struct Static {
            //Singleton instance.
            static let defaultManager = VideoHelper()
        }
        
        /** @return Returns the default singleton instance. */
        return Static.defaultManager
    }
    
    private init() {}
    
    func getSampleVideo() -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else {
            return nil
        }
        return url
    }
    
    func createSampleVideo() async throws -> URL? {
        
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            let config = VideoConfig(size: .init(width: 200, height: 40), duration: 3)
            
            do {
                try await VideoTool.shared.generateWhiteVideo(config: config, outputURL: url)
                print("创建视频文件成功！")
            } catch {
                print("创建文件视频文件失败!")
            }
            
        }
        return url
    }
}
