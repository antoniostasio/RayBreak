//
//  Renderer.swift
//  RayBreak
//
//  Created by Antonio Stasio on 27/02/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    let vertices: [Float] = [
        -1, 1, 0,
        -1, -1, 0,
        1, -1, 0,
        1, 1, 0
    ]
    
    let indices : [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    struct Constants {
        var animateBy: Float = 0.0
    }
    
    var constants = Constants()
    
    var time: Float = 0.0
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var pipelineState: MTLRenderPipelineState?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildModel()
        buildPipelineState()
    }
    
    
    func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Float>.size,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    
    func buildPipelineState() {
        let library = device.newDefaultLibrary()
        let vertex_shader = library?.makeFunction(name: "vertex_shader")
        let fragment_shader = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertex_shader
        pipelineDescriptor.fragmentFunction = fragment_shader
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.description)")
        }
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let indexBuffer = indexBuffer,
            let descriptor = view.currentRenderPassDescriptor else {
                return
        }
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        time += 1 / Float(view.preferredFramesPerSecond)
        let animatedBy = abs(sin(time)/2 + 0.5)
        constants.animateBy = animatedBy
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, at: 1)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
