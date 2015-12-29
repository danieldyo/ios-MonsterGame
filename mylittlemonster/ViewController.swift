//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Home on 12/24/15.
//  Copyright © 2015 Home. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monster: MonsterImg!
    @IBOutlet weak var heart: DragImg!
    @IBOutlet weak var food: DragImg!
    @IBOutlet weak var skull1: UIImageView!
    @IBOutlet weak var skull2: UIImageView!
    @IBOutlet weak var skull3: UIImageView!
    
    @IBOutlet weak var restart: UIButton!
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_SKULL = 3
    
    var skull = 0
    var timer: NSTimer!
    var happy = false
    var currentItem: UInt32 = 0
    
    var musicBG: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        heart.dropTarget = monster
        food.dropTarget = monster
        skull1.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOncharacter:", name: "onTargetDropped", object: nil)
        do {
            let resource = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resource)
            try musicBG = AVAudioPlayer(contentsOfURL: url)
            
            let resource2 = NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!
            let url2 = NSURL(fileURLWithPath: resource2)
            try sfxBite = AVAudioPlayer(contentsOfURL: url2)
            
            let resource3 = NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!
            let url3 = NSURL(fileURLWithPath: resource3)
            try sfxHeart = AVAudioPlayer(contentsOfURL: url3)
            
            let resource4 = NSBundle.mainBundle().pathForResource("death", ofType: "wav")!
            let url4 = NSURL(fileURLWithPath: resource4)
            try sfxDeath = AVAudioPlayer(contentsOfURL: url4)
            
            let resource5 = NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!
            let url5 = NSURL(fileURLWithPath: resource5)
            try sfxSkull = AVAudioPlayer(contentsOfURL: url5)
            
            musicBG.prepareToPlay()
            musicBG.play()
            
            sfxSkull.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxBite.prepareToPlay()
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        startTimer()
    }
    
    func itemDroppedOncharacter(notif: AnyObject){
        happy = true
        startTimer()
        food.alpha = DIM_ALPHA
        food.userInteractionEnabled = false
        heart.alpha = DIM_ALPHA
        heart.userInteractionEnabled = false
        if currentItem == 0 {
            sfxHeart.play()
        }
        else if currentItem == 1 {
            sfxBite.play()
        }
        
    }
    
    func startTimer(){
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !happy{
            skull++
            sfxSkull.play()
            if skull == 1 {
                skull1.alpha = OPAQUE
            }
            else if skull == 2 {
                skull2.alpha = OPAQUE
            }
            else if skull == 3 {
                skull3.alpha = OPAQUE
            }
            else {
                skull1.alpha = DIM_ALPHA
                skull2.alpha = DIM_ALPHA
                skull3.alpha = DIM_ALPHA
            }
        
            if skull >= MAX_SKULL{
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2)
        if rand == 0 {
            food.alpha = DIM_ALPHA
            food.userInteractionEnabled = false
            heart.alpha = OPAQUE
            heart.userInteractionEnabled = true
        }
        if rand == 1 {
            food.alpha = OPAQUE
            food.userInteractionEnabled = true
            heart.alpha = DIM_ALPHA
            heart.userInteractionEnabled = false
        }
        currentItem = rand
        happy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monster.playDeathAnimation()
        sfxDeath.play()
        restart.hidden = false
    }

    @IBAction func restart(sender: AnyObject) {
        
         skull = 0
         happy = false
        currentItem = 0
        viewDidLoad()
        restart.hidden = true
        monster.playIdleAnimation()
        
    }
}

