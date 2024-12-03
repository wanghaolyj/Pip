//
//  Tool.swift
//  Pip
//
//  Created by 王浩 on 2024/12/2.
//

import Foundation
import AVFoundation
import UIKit

class VideoTool {
    public class var shared: VideoTool {
        struct Static {
            //Singleton instance.
            static let defaultManager = VideoTool()
        }
        
        /** @return Returns the default singleton instance. */
        return Static.defaultManager
    }
    
    private init() {}
    
    func generateWhiteVideo(config: VideoConfig, outputURL: URL) async throws {
        // 创建 AVAssetWriter
        guard let writer = try? AVAssetWriter(outputURL: outputURL, fileType: config.fileType) else {
            throw NSError(domain: "com.example.video", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法创建 AVAssetWriter"])
        }
        
        // 视频设置
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: config.codec,
            AVVideoWidthKey: config.size.width,
            AVVideoHeightKey: config.size.height
        ]
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        writerInput.expectsMediaDataInRealTime = false

        guard writer.canAdd(writerInput) else {
            throw NSError(domain: "com.example.video", code: -2, userInfo: [NSLocalizedDescriptionKey: "无法添加 AVAssetWriterInput"])
        }
        writer.add(writerInput)
        
        // 像素缓冲区设置
        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: config.size.width,
            kCVPixelBufferHeightKey as String: config.size.height
        ]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: pixelBufferAttributes)

        // 开始写入
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)

        // 异步写入帧
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                var frameCount: Int = 0
            
                while frameCount < config.totalFrames {
                    if writerInput.isReadyForMoreMediaData {
                        let presentationTime = CMTime(value: CMTimeValue(frameCount), timescale: config.fps)
                        if let pixelBuffer = createWhitePixelBuffer(size: config.size) {
                            adaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                        }
                        frameCount += 1
                    }
                }
                
                // 完成写入
                writerInput.markAsFinished()
                writer.finishWriting {
                    if writer.status == .completed {
                        continuation.resume()
                    } else {
                        let error = writer.error ?? NSError(domain: "com.example.video", code: -3, userInfo: [NSLocalizedDescriptionKey: "写入失败"])
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
        
        @Sendable func createWhitePixelBuffer(size: CGSize, color:UIColor = .black) -> CVPixelBuffer? {
            let options: [String: Any] = [
                kCVPixelBufferCGImageCompatibilityKey as String: true,
                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
            ]
            
            var pixelBuffer: CVPixelBuffer?
            CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height),
                                kCVPixelFormatType_32ARGB, options as CFDictionary, &pixelBuffer)
            
            guard let buffer = pixelBuffer else { return nil }
            CVPixelBufferLockBaseAddress(buffer, .readOnly)
            
            if let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) {
                context.setFillColor(color.cgColor) // 纯白背景
                context.fill(CGRect(origin: .zero, size: size))
            }
            
            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
            return buffer
        }
    }
}

