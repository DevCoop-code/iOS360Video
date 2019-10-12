//
//  Shader.swift
//  360Video
//
//  Created by HanGyo Jeong on 09/10/2019.
//  Copyright © 2019 HanGyoJeong. All rights reserved.
//

import Foundation
import GLKit

class Shader{
    var program: GLuint = 0
    
    var position = GLuint()
    var texCoord = GLuint()
    var modelViewProjectionMatrix = GLint()
    
    var samplerY = GLuint()
    var samplerUV = GLuint()
    
    init(){
        let glProgram = GLProgram()
        program = glProgram.compileShaders(vertexShaderName: "vertexShader", fragmentShaderName: "fragmentShader")
        glUseProgram(program)
        
        //Get Vertex Shader variable
        position = GLuint(glGetAttribLocation(program, "position"))
        glEnableVertexAttribArray(position)
        texCoord = GLuint(glGetAttribLocation(program, "texCoord"))
        glEnableVertexAttribArray(texCoord)
        modelViewProjectionMatrix = GLint(glGetUniformLocation(program, "modelViewProjectionMatrix"))
        
        samplerY = GLuint(glGetUniformLocation(program, "samplerY"))
        samplerUV = GLuint(glGetUniformLocation(program, "samplerUV"))
    }
}
