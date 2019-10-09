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
        
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func play(){
        avPlayer.play()
    }
    
    @objc private func playEnd() {
        avPlayer.seek(to: CMTime.zero)
        avPlayer.play()
    }
}
