//
//  Sphere.swift
//  360Video
//
//  Created by HanGyo Jeong on 09/10/2019.
//  Copyright © 2019 HanGyoJeong. All rights reserved.
//

import GLKit

class Sphere {
    var vertices: UnsafeMutablePointer<GLfloat>?
    var texCoords: UnsafeMutablePointer<GLfloat>?
    var indices: UnsafeMutablePointer<GLfloat>?
    var vertexCount: GLint = 0
    var indexCount: GLint = 0
    
    init(){
        let sliceCount: GLint = 200
        let radius: GLfloat = 1.0
        vertexCount = ((sliceCount / 2) + 1) * (sliceCount + 1)
        indexCount = esGenSphere(sliceCount, radius, &vertices, &texCoords, &indices)
    }
}
