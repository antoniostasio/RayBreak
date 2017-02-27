//
//  ViewController.swift
//  RayBreak
//
//  Created by Antonio Stasio on 25/02/2017.
//  Copyright © 2017 Antonio Stasio. All rights reserved.
//

import UIKit
import MetalKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0.0,
                                               green: 0.4,
                                               blue: 0.21,
                                               alpha: 1)
}

class ViewController: UIViewController {
    
    var metalView: MTKView {
        return view as! MTKView
    }
    
    var device: MTLDevice!
    
    var commandQueue: MTLCommandQueue!
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.clearColor = Colors.wenderlichGreen

        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device.")
        }
        renderer = Renderer(device: device)
        metalView.delegate = renderer
    }


}


