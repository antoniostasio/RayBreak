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
    
    var pipelineState: MTLRenderPipelineState?
    
    var scene: Scene?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildPipelineState()
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
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        commandEncoder.setRenderPipelineState(pipelineState)

        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
