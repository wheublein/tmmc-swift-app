//
//  ViewController.swift
//  TMMC_App_v1
//
//  Created by wheublein on 4/6/16.
//  Coded in 2016 by Will Heublein for the Marine Mammal Center.
//  App Code is covered by Creative Commons NonCommercial 4.0 Licence
//  http://creativecommons.org/licenses/by-nc/4.0/
//
// You may share, copy and redistribute the material in any medium or format
// You may adapt — remix, transform, and build upon the material
//
//  Images are copyrighted by The Marine Mammal Center, all rights reserved
//
//  Developed as a Taproot+ Project
//



import UIKit
import AudioToolbox


class ViewController: UIViewController {

    
    var imageView:UIImageView = UIImageView()
    let myScreenSize: CGRect = UIScreen.mainScreen().bounds
    
    var textField : UITextField!
    let titleString : String = "The Marine Mammal Center App"
    
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    
    var webBanners1600Dict:Dictionary<String,String> = Dictionary()
    var webBanners2048Dict:Dictionary<String,String> = Dictionary()

    let bannerImage : UIImage = UIImage(named: "banner2")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myScreenWidth = myScreenSize.width
        let myScreenHeight = myScreenSize.height
        
        
        //1600 wide image links
        webBanners1600Dict = ["link1":"http://www.willheublein.com/mmc/1600/seal1.jpg","link2":"http://www.willheublein.com/mmc/1600/seal2.jpg","link3":"http://www.willheublein.com/mmc/1600/seal3.jpg"]
        //2048 wide image links
        webBanners2048Dict = ["link1":"http://www.willheublein.com/mmc/2048/seal1.jpg","link2":"http://www.willheublein.com/mmc/2048/seal2.jpg","link3":"http://www.willheublein.com/mmc/2048/seal3.jpg"]
        

        
        
        //---------------------------------------------------------------------
        //Add background image
        //---------------------------------------------------------------------

        let view:UIView = UIView(frame: CGRectMake(0,0, myScreenWidth, myScreenHeight))
        view.backgroundColor = .blackColor()
        self.view.addSubview(view)
        
        var backgroundImage:UIImage = UIImage(named:"background1")!
        imageView = UIImageView(frame: view.frame)
        imageView.image = backgroundImage
        self.view.addSubview(imageView)

        //---------------------------------------------------------------------
        //Add Title Text
        //---------------------------------------------------------------------
        
        let placeholder = NSAttributedString(string: titleString, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        print("myScreenWidth : ")
        print(myScreenWidth)
        
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: myScreenWidth, height: (myScreenHeight/12)));
        textField.attributedPlaceholder = placeholder;
        textField.frame.origin = CGPoint(x: 20, y:0)
        textField.font = UIFont(name: "Verdana", size: 30)
        //textField.backgroundColor = .grayColor();
        //textField.tag = 10
        
        self.view.addSubview(textField)
        
        
        //---------------------------------------------------------------------
        //Add banner image
        //---------------------------------------------------------------------
        
        let imageViewBanner : UIImageView = UIImageView(image: bannerImage)
        imageViewBanner.frame = CGRectMake(0, 0, bannerImage.size.width, bannerImage.size.height - 100)
        imageViewBanner.frame.origin = CGPoint(x: 0, y:(myScreenHeight/12))
        
        self.view.addSubview(imageViewBanner)
        
        //---------------------------------------------------------------------
        //Add buttons with images
        //---------------------------------------------------------------------
        
        let imageMail : UIImage = UIImage(named: "button-mail")!
        let imageMailButton   = UIButton(type: UIButtonType.Custom) as UIButton
        imageMailButton.frame = CGRectMake(0, 0, imageMail.size.width, imageMail.size.height)
        imageMailButton.setImage(imageMail, forState: .Normal)
        var j = -1.0;
        var xOffset = CGFloat(j) * (imageMailButton.frame.width)
        
        imageMailButton.center = CGPointMake((myScreenWidth/2) + xOffset, (myScreenHeight/2) + (imageMailButton.frame.height))
        imageMailButton.tag = 1;
        imageMailButton.addTarget(self, action: "buttonActionMail:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(imageMailButton)
        
        
        let imageDonate : UIImage = UIImage(named: "button-give")!
        let imageDonateButton   = UIButton(type: UIButtonType.Custom) as UIButton
        imageDonateButton.frame = CGRectMake(0, 0, imageDonate.size.width, imageDonate.size.height)
        imageDonateButton.setImage(imageDonate, forState: .Normal)
        j = 1.0
        xOffset = CGFloat(j) * (imageMailButton.frame.width)
        imageDonateButton.center = CGPointMake((myScreenWidth/2) + xOffset, (myScreenHeight/2) + (imageDonateButton.frame.height))
        
        imageDonateButton.tag = 2
        imageDonateButton.addTarget(self, action: "buttonActionDonate:", forControlEvents: UIControlEvents.TouchUpInside)
        //imageDonateButton.addTarget(self, action: "buttonTransiton:", forControlEvents: UIControlEvents.TouchUpInside)
        //imageDonateButton.addTarget(self, action: "buttonActionThree:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(imageDonateButton)
        
        
    }
    
    
    
    //---------------------------------------------------------------------
    //Actions for buttons
    //---------------------------------------------------------------------
    
    
    func buttonActionDonate(sender:UIButton!){
        print("Button tapped")
        print("Button tag :")
        print (sender.tag)
        var button:UIButton = sender;
        playSoundDing()
        let alertController = UIAlertController(title: "Donations", message:
            "The Marine Mammal Center uses Square for donations made by credit or debit card - a volunteer can help you complete your donation", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
  
    func buttonActionMail(sender:UIButton!){
        print("Button tapped")
        print("Button tag :")
        print (sender.tag)
        var button:UIButton = sender;
        playSoundClick()
        print("transition web")
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.marinemammalcenter.org/Get-Involved/take-action/email-signup-ipad.html")!)
    }
    
    
    //---------------------------------------------------------------------
    //Add Sound - Ding
    //---------------------------------------------------------------------
    
    
    func  playSoundDing(){
        let filePath = NSBundle.mainBundle().pathForResource("sound-corsica-ding", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func  playSoundClick(){
        let filePath = NSBundle.mainBundle().pathForResource("sound-basic-click", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }

    
    
    //---------------------------------------------------------------------
    //Random Integer
    //---------------------------------------------------------------------
    
    func randRange (lower: UInt32 , upper: UInt32) -> UInt32 {
        return lower + arc4random_uniform(upper - lower + 1)
    }
    
    
    //---------------------------------------------------------------------
    //Random Banner
    //---------------------------------------------------------------------
    /*
     let bannerImage : UIImage = UIImage(named: "header1")!
     
     var imageV : UIImageView = UIImageView(image: bannerImage)
     imageV.frame = CGRectMake(0, 0, bannerImage.size.width, bannerImage.size.height - 100)
     imageV.frame.origin = CGPoint(x: -300, y:80)
     
     self.view.addSubview(imageV)
     */
    
    func loadRandomBanner(){
        print("running random banner")
        var nix = randRange(0,upper: 2)
        var imageKey = "link3"
        
        if nix == 0 {
            imageKey = "link1"
        }
        if nix == 1 {
            imageKey = "link2"
        }
        if nix == 2 {
            imageKey = "link3"
        }
        
        //let url = NSURL(string: "http://www.willheublein.com/mmc/mmc_seal_2048x1600.jpg")
        
        let imageUrl = webBanners1600Dict[imageKey]!
        print("imageUrl")
        print(imageUrl)
        
        let url = NSURL(string: imageUrl as String)
        if let data = NSData(contentsOfURL: url!) {
            print("going with URL image")
            imageView.image = UIImage(data: data)
            imageView.frame =  CGRectMake(0, 0, bannerImage.size.width, bannerImage.size.height - 100)
            imageView.frame.origin = CGPoint(x: 0, y:80)
            imageView.contentScaleFactor = 0.5
            imageView.tag = 10
        }
        //view.willRemoveSubview(imageView)
        view.addSubview(imageView)
        
        
        //view.insertSubview(imageView, aboveSubview: imageView)
        /*
         for subUIView in self.subviews as [UIView] {
         subUIView.removeFromSuperview()
         }
         */
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

