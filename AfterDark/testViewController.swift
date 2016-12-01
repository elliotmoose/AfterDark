//
//  testViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 17/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    
    var label = UILabel()
    @IBAction func sliderValueChanged(_ sender: Any) {
        

        let slider = sender as! UISlider
        blurrView.layer.timeOffset = CFTimeInterval(slider.value + 0.5)

        label.text = String(describing: blurrView.layer.timeOffset)
    }

    @IBOutlet weak var blurrView: UIVisualEffectView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blurrView.effect = nil
        blurrView.layer.speed = 0
        UIView.animate(withDuration: 1, animations: {
            self.blurrView.effect = UIBlurEffect(style: .light)

            

        })
        
        
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.HundredRelativeHeightPts()/2))
        
        self.view.addSubview(self.label)
        
        

    }

    override func viewDidAppear(_ animated: Bool) {
        blurrView.layer.timeOffset = CFTimeInterval(1)

    }
}
