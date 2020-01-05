//
//  ViewController.swift
//  ARPortal
//
//  Created by Livia Vasconcelos on 05/01/20.
//  Copyright © 2020 Livia Vasconcelos. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var planeDetected: UILabel!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin,
                                  SCNDebugOptions.showFeaturePoints]
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetected.isHidden = true
        }
    }
}

