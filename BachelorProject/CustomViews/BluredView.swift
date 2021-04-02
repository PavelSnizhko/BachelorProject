//
//  BluredView.swift
//  BachelorProject
//
//  Created by Павел Снижко on 02.04.2021.
//

import UIKit

class BluredView: UIView, NibLoadable {

    @IBOutlet weak var stopButton: CustomButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var animationView: CircleAnimationView!
    
    var stopTapped: VoidClosure?
    

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        animationView.updateAnimation()
    }
    
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        // TODO: figure out maybe it's not appropriate to do things like this
        
        animationView.stopAnimationView()
    }
    
    
    func updateTimeOnLabel(time: String) {
        //  time unit is  secunds
        
        
        timeLabel.text = time
        
    }

    @IBAction func tappedStop(_ sender: Any) {
        //Don't put removeFrom super view due to wanna send location and audio to server
        stopTapped?()
    }
}
