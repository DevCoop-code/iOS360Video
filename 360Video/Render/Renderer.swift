//
//  Renderer.swift
//  360Video
//
//  Created by HanGyo Jeong on 09/10/2019.
//  Copyright © 2019 HanGyoJeong. All rights reserved.
//

import Foundation
import OpenGLES.ES3
import CoreVideo
import GLKit

class Renderer{
    let shader: Shader!
    let model: Sphere!
    let fieldOfView: Float = 60.0
    
    var context: EAGLContext!
    
    // VBO
    var vertexBuffer: GLuint = 0
    var texCoordBuffer: GLuint = 0
    var indexBuffer: GLuint = 0
    
    // VAO
    var vertexArray: GLuint = 0
    
    //Transform
    var modelViewProjectionMatrix = GLKMatrix4Identity
    var degree: Float = 0
    
    init(context: EAGLContext, shader: Shader, model: Sphere){
        self.context = context
        self.shader = shader
        self.model = model
        
        createVBO()
        createVAO()
    }
    
    deinit {
        deleteVBO()
        deleteVAO()
    }
    
    func render(){
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        glUseProgram(shader.program)
        
        //Uniforms
        glUniformMatrix4fv(shader.modelViewProjectionMatrix, 1, GLboolean(GL_FALSE), modelViewProjectionMatrix.array)
        
        glBindVertexArray(vertexArray)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(model.indexCount), GLenum(GL_UNSIGNED_SHORT), nil)
        glBindVertexArray(0)
    }
    
    func updateModelViewProjectionMatrix(){
        let aspect = abs(Float(UIScreen.main.bounds.size.width) / Float(UIScreen.main.bounds.size.height))
        let nearZ: Float = 0.1
        let farZ: Float = 100.0
        
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fieldOfView), aspect, nearZ, farZ)
        
        var modelViewMatrix = GLKMatrix4Identity
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0, 0.0, -2.0)
        degree += 0.0002
        let rotateY = Float((sin(degree) + 1.0) / 2.0 * 360.0)
        modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, rotateY)
        
        modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix)
    }
    
    private func createVBO(){
        /*
         Create the space and put the real data
         */
        //Vertex
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(model.vertexCount * GLint(3 * MemoryLayout<GLfloat>.size)), model.vertices, GLenum(GL_STATIC_DRAW))
        
        //Texture Coordinates
        glGenBuffers(1, &texCoordBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), texCoordBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(model.vertexCount * GLint(2 * MemoryLayout<GLfloat>.size)), model.texCoords, GLenum(GL_STATIC_DRAW))
        
        //Indices
        glGenBuffers(1, &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), GLsizeiptr(model.indexCount * GLint(MemoryLayout<GLushort>.size)), model.indices, GLenum(GL_STATIC_DRAW))
    }
    private func createVAO(){
        glGenVertexArrays(1, &vertexArray)
        glBindVertexArray(vertexArray)
        
        //Bind variable between shader and buffer
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glEnableVertexAttribArray(shader.position)
        glVertexAttribPointer(shader.position, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), nil)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), texCoordBuffer)
        glEnableVertexAttribArray(shader.texCoord)
        glVertexAttribPointer(shader.texCoord, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 2), nil)
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        
        glBindVertexArray(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
        
    }
    
    private func deleteVBO(){
        glDeleteBuffers(1, &vertexBuffer)
        glDeleteBuffers(1, &texCoordBuffer)
        glDeleteBuffers(1, &indexBuffer)
    }
    private func deleteVAO(){
        glDeleteVertexArrays(1, &vertexArray)
    }
}
