//
//  VideoPlayer.swift
//  360Video
//
//  Created by HanGyo Jeong on 09/10/2019.
//  Copyright © 2019 HanGyoJeong. All rights reserved.
//

import Foundation
import CoreVideo
import AVFoundation

class VideoPlayer{
    private var avPlayer: AVPlayer!
    private var avPlayerItem: AVPlayerItem!
    private var avAsset: AVAsset!
    private var output: AVPlayerItemVideoOutput!
    
    init(url: URL, framesPerSecond: Int){
        avAsset = AVAsset(url: url)
        avPlayerItem = AVPlayerItem(asset: avAsset)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        
        configureOutput(framesPerSecond: framesPerSecond)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func play(){
        avPlayer.play()
    }
    
    func retrievePixelBuffer() -> CVPixelBuffer? {
        //Return the pixel buffer of the current video frame
        let pixelBuffer = output.copyPixelBuffer(forItemTime: avPlayerItem.currentTime(),
                                                 itemTimeForDisplay: nil)
        return pixelBuffer
    }
    
    private func configureOutput(framesPerSecond: Int){
        //Set the pixel buffer format(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)
        //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange represents Bi-Planar Component Y'CbCr 8-bit 4:2:0
        //video-range, luma = 16,235 / chroma = 16,240
        let pixelBuffer = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)]
        output = AVPlayerItemVideoOutput(pixelBufferAttributes: pixelBuffer)
        //Set the video player's update frame corresponding to the GLKViewCotroller's time frame
        output.requestNotificationOfMediaDataChange(withAdvanceInterval: 1.0/TimeInterval(framesPerSecond))
        avPlayerItem.add(output)
    }
    
    @objc private func playEnd() {
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
    }
}
