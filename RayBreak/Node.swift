//
//  Node.swift
//  RayBreak
//
//  Created by Antonio Stasio on 05/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import MetalKit

class Node {
    var name: String = "untitled"
    var children: [Node] = []
    
    func add(childNode: Node) {
        children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        for child in children {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        }
    }
    
}
