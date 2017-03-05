//
//  GameScene.swift
//  RayBreak
//
//  Created by Antonio Stasio on 05/03/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import MetalKit

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device)
        super.init(device: device, size: size)
        add(childNode: quad)
    }
    
}
