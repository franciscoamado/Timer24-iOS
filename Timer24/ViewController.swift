//
//  ViewController.swift
//  Timer24
//
//  Created by Francisco Amado on 27/12/15.
//  Copyright © 2015 Francisco Amado. All rights reserved.
//

import UIKit
import ChameleonFramework

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var integerTimeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        view.backgroundColor = FlatOrange()
        topView.backgroundColor = UIColor.clearColor()
        bottomView.backgroundColor = UIColor.flatSandColor().colorWithAlphaComponent(0.5)
        integerTimeLabel.textColor = ContrastColorOf(FlatOrange(), returnFlat:true)
        startButton.titleLabel!.textColor = view.backgroundColor
        startButton.setTitleColor(view.backgroundColor, forState:UIControlState.Normal)
        startButton.setTitleColor(ComplementaryFlatColorOf(view.backgroundColor!), forState:UIControlState.Highlighted)
        startButton.setTitleColor(ComplementaryFlatColorOf(view.backgroundColor!), forState:UIControlState.Selected)
        
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = view.backgroundColor!.CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonAction(sender: UIButton) {
//        startButton.layer.borderColor = sender.titleColorForState(UIControlState.Selected)?.CGColor;
    }
}

