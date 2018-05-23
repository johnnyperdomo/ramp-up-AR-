//
//  RampPickerVC.swift
//  ramp-up
//
//  Created by Johnny Perdomo on 4/30/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    var sceneView: SCNView! //scene view
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerVC!
    
    init(size: CGSize) { //initializer to pass in the size
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //configuring our popupView
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        preferredContentSize = size
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")! //shows the 3d world model
        sceneView.scene = scene
        
        let camera = SCNCamera() //set a specific camera view
        camera.usesOrthographicProjection = true //camera type
        scene.rootNode.camera = camera //add it
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1)) //to rotate
        
        
        let pipeObj = SCNScene(named: "art.scnassets/pipe.dae")  //pipe scene
        let pipeNode = pipeObj?.rootNode.childNode(withName: "pipe", recursively: true)! //calls the specific object in the scene(node)..calls it by identifier
        pipeNode?.runAction(rotate) //rotates the node image
        pipeNode?.scale = SCNVector3Make( 0.0025, 0.0025,0.0025) //change the scale size of the ramp
        pipeNode?.position = SCNVector3Make(-1, 0.7, -1)
        scene.rootNode.addChildNode(pipeNode!) //add the node to this scene
        
        
        let pyramidObj = SCNScene(named: "art.scnassets/pyramid.dae") //pyramid scene
        let pyramidNode = pyramidObj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        pyramidNode?.runAction(rotate)
        pyramidNode?.scale = SCNVector3Make(0.006, 0.006, 0.006)
        pyramidNode?.position = SCNVector3Make(-1, -0.3, -1)
        scene.rootNode.addChildNode(pyramidNode!) //add the node to scene
        
        let quarterObj = SCNScene(named: "art.scnassets/quarter.dae") //quarterPipe scene
        let quarterNode = quarterObj?.rootNode.childNode(withName: "quarter", recursively: true)!
        quarterNode?.runAction(rotate)
        quarterNode?.scale = SCNVector3Make(0.006, 0.006, 0.006)
        quarterNode?.position = SCNVector3Make(-1, -2, -1)
        scene.rootNode.addChildNode(quarterNode!)
        
    }

    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let p = gestureRecognizer.location(in: sceneView) //get location of the tap in sceneView
        let hitResults = sceneView.hitTest(p, options: [:]) //check if anything was hit
        
        if hitResults.count > 0 { //if we hit an object
            let node = hitResults[0].node
            print(node.name!)
            rampPlacerVC.onRampSelected(rampName: node.name!)
        }
    }
    
    

}
