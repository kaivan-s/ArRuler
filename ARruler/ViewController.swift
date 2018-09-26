//  ViewController.swift
//  ARruler
//  Created by kaivan shah on 26/09/18.
//  Copyright © 2018 kaivan shah. All rights reserved.

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if dotNodes.count>=2
        {
            for dot in dotNodes
            {
                dot.removeFromParentNode()
            }
            dotNodes=[SCNNode]()
        }
        if let touchLocation = touches.first?.location(in: sceneView)
        {
            let hitTest = sceneView.hitTest(touchLocation, types:.featurePoint)
            if let hitresult = hitTest.first
            {
                addDot(at:hitresult)
            }
        }
    }
    func addDot(at hitresult : ARHitTestResult)
    {
        let dotgeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotgeometry.materials=[material]
        let dotnode = SCNNode(geometry: dotgeometry)
        dotnode.position = SCNVector3(hitresult.worldTransform.columns.3.x, hitresult.worldTransform.columns.3.y, hitresult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotnode)
        dotNodes.append(dotnode)
        if dotNodes.count>=2{
            calculate()
        }
    }
    func calculate()
    {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2)+pow(b,2)+pow(c,2))
        updateText(text:"\(abs(distance))", atpos:end.position)
    }
    
    
    func updateText(text: String,atpos pos:SCNVector3)
    {
        textNode.removeFromParentNode()
        let geotext = SCNText(string: text, extrusionDepth: 1.0)
        geotext.firstMaterial?.diffuse.contents = UIColor.red
        textNode = SCNNode(geometry: geotext)
        textNode.position = SCNVector3(pos.x,pos.y+0.01,pos.z)
        textNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }

}

