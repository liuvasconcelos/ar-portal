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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handletap))
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handletap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if let hitTest = hitTestResult.first {
            self.addPortal(hitTestResult: hitTest)
        }
    }
    
    func addPortal(hitTestResult: ARHitTestResult) {
        let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
        let portalNode  = portalScene?.rootNode.childNode(withName: "Portal", recursively: false)
        let transform   = hitTestResult.worldTransform
        
        let planeXPosition = transform.columns.3.x
        let planeYPosition = transform.columns.3.y
        let planeZPosition = transform.columns.3.z
        
        portalNode?.position = SCNVector3(planeXPosition, planeYPosition, planeZPosition)
        if let portalNode = portalNode {
            self.sceneView.scene.rootNode.addChildNode(portalNode)
            self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
            self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
            self.addWall(nodeName: "backWall", portalNode: portalNode, imageName: "back")
            self.addWall(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
            self.addWall(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
            self.addWall(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
            self.addWall(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")
        }
    }
    
    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).png")
    }
    
    func addWall(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).png")
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

