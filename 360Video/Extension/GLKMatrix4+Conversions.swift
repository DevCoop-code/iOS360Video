//
//  GLKMatrix4+Conversions.swift
//  360Video
//
//  Created by HanGyo Jeong on 09/10/2019.
//  Copyright © 2019 HanGyoJeong. All rights reserved.
//

import GLKit

extension GLKMatrix4{
    var array: [Float]{
        return (0..<16).map{
            i in self[i]
        }
    }
}
