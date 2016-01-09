//
//  ViewController.swift
//  Timer24
//
//  Created by Francisco Amado on 27/12/15.
//  Copyright © 2015 Francisco Amado. All rights reserved.
//

import UIKit
import ChameleonFramework
import GoogleMaterialIconFont

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var numpadButton: UIButton!
    @IBOutlet weak var reset24Button: UIButton!
    @IBOutlet weak var reset14Button: UIButton!
    
    let STRING_START:String = "Start"
    let STRING_STOP:String = "Stop"
    
    let screenSize:CGRect = UIScreen.mainScreen().bounds
    let PROGRESS_VIEW_WIDTH:CGFloat = UIScreen.mainScreen().bounds.width

    let TIME_INCREMENT:NSTimeInterval = 0.01
    let TIME_24SEC:NSTimeInterval = 24.0
    let TIME_14SEC:NSTimeInterval = 14.0
    
    var timeCount:NSTimeInterval = 0.0
    var timePrefered:NSTimeInterval = 0.0
    var timePaused:NSTimeInterval = 0.0
    var timer:NSTimer = NSTimer()
    var animationOn:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timePrefered = TIME_24SEC
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        view.backgroundColor = FlatOrange()
        topView.backgroundColor = UIColor.clearColor()
        bottomView.backgroundColor = UIColor.flatSandColor().colorWithAlphaComponent(0.5)
        timeLabel.textColor = ContrastColorOf(FlatOrange(), returnFlat:true)
        
// Start Button design configurations
        changeStartButtonTextTo(STRING_START)
        startButton.titleLabel!.textColor = view.backgroundColor
        startButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        startButton.setTitleColor(view.backgroundColor, forState:UIControlState.Normal)
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = view.backgroundColor!.CGColor
        
// Numpad Button design configurations
        numpadButton.setTitle(String.materialIcon(.Dialpad), forState: UIControlState.Normal)
        numpadButton.titleLabel!.font = UIFont.materialIconOfSize(32)
        numpadButton.titleLabel!.textColor = UIColor.flatSandColor().colorWithAlphaComponent(0.0)
        numpadButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        numpadButton.setTitleColor(view.backgroundColor, forState:UIControlState.Normal)
        numpadButton.layer.cornerRadius = numpadButton.frame.width / 2
        numpadButton.layer.borderWidth = 2
        numpadButton.layer.borderColor = view.backgroundColor!.CGColor

// Reset24 Button design configurations
        reset24Button.titleLabel!.textColor = view.backgroundColor
        reset24Button.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        reset24Button.setTitleColor(view.backgroundColor, forState:UIControlState.Normal)
        reset24Button.layer.cornerRadius = reset24Button.frame.width / 2
        reset24Button.layer.borderWidth = 2
        reset24Button.layer.borderColor = view.backgroundColor!.CGColor
        
// Reset14 Button design configurations
        reset14Button.titleLabel!.textColor = view.backgroundColor
        reset14Button.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        reset14Button.setTitleColor(view.backgroundColor, forState:UIControlState.Normal)
        reset14Button.layer.cornerRadius = reset14Button.frame.width / 2
        reset14Button.layer.borderWidth = 2
        reset14Button.layer.borderColor = view.backgroundColor!.CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateProgressViewWithSeconds(seconds:Double, secondsFraction:Double){
        if seconds > 0.0 {
            if secondsFraction <= 0.1 {
                let timeLeft:NSTimeInterval = self.timePrefered - seconds
                let timeLeftInt:Int = Int(timeLeft) + 1
                let ratio:CGFloat = (self.PROGRESS_VIEW_WIDTH * CGFloat(timeLeftInt)) / CGFloat(self.timePrefered)
                let progressViewWidth:CGFloat = self.PROGRESS_VIEW_WIDTH - ratio
                
                if !self.animationOn && self.progressViewWidthConstraint.constant != progressViewWidth {
                    self.animationOn = true

                    self.progressViewWidthConstraint.constant = progressViewWidth
                    UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveLinear, animations: {
                        self.progressView.layoutIfNeeded()
                        }) { finished in
                            self.animationOn = false
                        }
                }
            }
        }
    }
    
// MARK: Button Delegation
    @IBAction func startButtonAction(sender: UIButton) {
        self.startStopTimer()
        if timer.valid {
            changeStartButtonTextTo(STRING_STOP)
        } else {
            changeStartButtonTextTo(STRING_START)
        }
    }
    
    func changeStartButtonTextTo(text:String){
        if text == STRING_START {
            startButton.setTitle(STRING_START, forState:UIControlState.Normal)
            startButton.setTitle(STRING_STOP, forState:UIControlState.Highlighted)
            startButton.setTitle(STRING_STOP, forState:UIControlState.Selected)
        } else {
            startButton.setTitle(STRING_STOP, forState:UIControlState.Normal)
            startButton.setTitle(STRING_START, forState:UIControlState.Highlighted)
            startButton.setTitle(STRING_START, forState:UIControlState.Selected)
        }
    }
    
    @IBAction func reset24ButtonAction(sender: UIButton) {
        self.progressViewWidthConstraint.constant = CGFloat(self.PROGRESS_VIEW_WIDTH)
        self.progressView.layoutIfNeeded()
        timePrefered = TIME_24SEC
        self.startTimerWithTimeInterval(timePrefered)
    }
    
    @IBAction func reset14ButtonAction(sender: UIButton) {
        self.progressViewWidthConstraint.constant = CGFloat(self.PROGRESS_VIEW_WIDTH)
        self.progressView.layoutIfNeeded()
        timePrefered = TIME_14SEC
        self.startTimerWithTimeInterval(timePrefered)
    }
    
// MARK: Timer Delegation
    func startTimerWithTimeInterval(timeInverval:NSTimeInterval) {
        if timer.valid{
            timer.invalidate()
        }
        timeCount = timeInverval
        timer = NSTimer.scheduledTimerWithTimeInterval(TIME_INCREMENT, target:self, selector:Selector("updateTimer:"), userInfo:timer.timeInterval, repeats:true)
        changeStartButtonTextTo(STRING_STOP)
    }
    
    func startStopTimer(){
        if timer.valid {
            timePaused = timeCount
            timer.invalidate()
        } else {
            if timePaused != 0.0 {
                startTimerWithTimeInterval(timePaused)
            } else {
                startTimerWithTimeInterval(timePrefered)
            }
        }
    }
    
    func updateTimer(timeInterval:NSTimeInterval) {
        timeCount -= TIME_INCREMENT
        let timeAsString = timeString(timeCount)
        timeLabel.text = timeAsString
        
        if(timeCount <= 0){
            self.timerDidEnd()
        }
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        animateProgressViewWithSeconds(seconds, secondsFraction:secondsFraction)
        return String(format:"%02i.%01i",Int(seconds),Int(secondsFraction * 10.0))
    }
    
    func timerDidEnd() {
        timer.invalidate()
        timePaused = 0.0
    }
}

