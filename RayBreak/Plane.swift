//
//  Plane.swift
//  RayBreak
//
//  Created by Antonio Stasio on 05/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import MetalKit

class Plane: Node {
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    let vertices: [Float] = [
        -1, 1, 0,
        -1, -1, 0,
        1, -1, 0,
        1, 1, 0
    ]
    
    let indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var time: Float = 0
    
    struct Constants {
        var animateBy: Float = 0
    }
    
    var constants = Constants()
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
    
    func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Float>.size,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer = indexBuffer else {return}
        
        time += deltaTime
        let animateBy = abs(sin(time)/2 + 0.5)
        constants.animateBy = animateBy
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        commandEncoder.setVertexBytes(&constants,
                                      length: MemoryLayout<Constants>.stride,
                                      at: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
