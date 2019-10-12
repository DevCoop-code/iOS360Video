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
    
    private var rotationX: Float = 0.0
    private var rotationY: Float = 0.0
    
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //For getting the touch distance in X-axis and Y-axis
        let radiansPerPoint: Float = 0.005
        let touch = touches.first!
        let location = touch.location(in: touch.view)
        let previousLocation = touch.previousLocation(in: touch.view)
        var diffX = Float(location.x - previousLocation.x)
        var diffY = Float(location.y - previousLocation.y)
        
        //For every pixel the user drags, rotate the sphere 0.005 radians
        diffX *= -radiansPerPoint
        diffY *= -radiansPerPoint
        
        //X-axis is horizontal across / Y-axis is vertical
        //user drags from left to right(diffX) actually want to rotate around the y axis(rotationY) and vice versa
        rotationX += diffY
        rotationY += diffX
    }
}

//MARK: - GLKViewControllerDelegate
extension ViewController: GLKViewControllerDelegate{
    func glkViewControllerUpdate(_ controller: GLKViewController){
        renderer?.updateModelViewProjectionMatrix(rotationX, rotationY)
    }
}
