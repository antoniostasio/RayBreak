//
//  Scene.swift
//  RayBreak
//
//  Created by Antonio Stasio on 05/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
    }
}
