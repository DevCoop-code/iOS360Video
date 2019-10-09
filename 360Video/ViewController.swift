//
//  ViewController.swift
//  360Video
//
//  Created by HanGyo Jeong on 09/10/2019.
//  Copyright © 2019 HanGyoJeong. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
    var renderer: Renderer?
    var videoPlayer: VideoPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRenderer()
        setupVideoPlayer()
        
        delegate = self
    }

    private func setupRenderer(){
        if let context = EAGLContext(api: .openGLES3){
            EAGLContext.setCurrent(context)
            let glkView = view as! GLKView
            glkView.context = context
            glkView.drawableDepthFormat = .format16
            let shader = Shader()
            let model = Sphere()
            
            renderer = Renderer(context: context, shader: shader, model: model)
        }
    }
    
    private func setupVideoPlayer() {
        if let path = Bundle.main.path(forResource: "360_VR Master Series _ London On Tower Bridge_1080p", ofType: "mp4"){
            let url = URL(fileURLWithPath: path)
            videoPlayer = VideoPlayer(url: url, framesPerSecond:framesPerSecond)
            videoPlayer?.play()
        }
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        renderer?.render()
    }
}

//MARK: - GLKViewControllerDelegate
extension ViewController: GLKViewControllerDelegate{
    func glkViewControllerUpdate(_ controller: GLKViewController){
        renderer?.updateModelViewProjectionMatrix()
    }
}
