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



//---------------------------------------------------------------------
//Todo
//---------------------------------------------------------------------
/*
 
2. kiosk mode lock - no calendar accessS
3. random background after 10 minutes (backgroundTimer = 600)

6. disable horizontal scroll in webview

 // disable suggest/autocorrect - textField.autocorrectionType = UITextAutocorrectionType.No
 // or  myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
 
*/

//---------------------------------------------------------------------
//Done
//---------------------------------------------------------------------
/*
1. show back button below web view
2. close webview after thank you message
 4. fix seal3 image size
 7. stop banner from covering webview
 5. hide keyboard after webview timeout
 
 */

import UIKit
import WebKit
import AudioToolbox


class ViewController: UIViewController {

    
    //var appStatus = "loaded" //loaded, webform, webthanks, donateAlert
    //var imageView:UIImageView = UIImageView()
    
    
    let myScreenSize: CGRect = UIScreen.mainScreen().bounds
    var isWebView = false
    
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    
    var webTimer = NSTimer()
    var webTimerCounter = 0
    var webTimerTimeout = 120
    var webCountdown = 4
    
    var bannerTimer = NSTimer()
    var bannerTimerCounter = 0
    var bannerTimeout = 6
    
    
    var webBanners1600Dict:Dictionary<String,String> = Dictionary()
    var webBanners2048Dict:Dictionary<String,String> = Dictionary()

    var imageViewBanner : UIImageView = UIImageView()
    var imageViewBackground: UIImageView = UIImageView()
    
    let myWebView:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))

    var BackTextField = UITextField()
    let imageBackButton   = UIButton(type: UIButtonType.Custom) as UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myScreenWidth = myScreenSize.width
        let myScreenHeight = myScreenSize.height
        
        print("myScreenWidth : ")
        print(myScreenWidth)
        
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
        imageViewBackground = UIImageView(frame: view.frame)
        imageViewBackground.image = backgroundImage
        self.view.addSubview(imageViewBackground)

        //---------------------------------------------------------------------
        //Add Title Text
        //---------------------------------------------------------------------
        let titleTextField : UITextField!
        let titleString : String = "The Marine Mammal Center App"

        let placeholder = NSAttributedString(string: titleString, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        titleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: myScreenWidth, height: (myScreenHeight/12)));
        titleTextField.attributedPlaceholder = placeholder;
        titleTextField.frame.origin = CGPoint(x: 20, y:0)
        titleTextField.font = UIFont(name: "Verdana", size: 24)
        titleTextField.userInteractionEnabled = false
        
        self.view.addSubview(titleTextField)
        
        
        //---------------------------------------------------------------------
        //Add banner image
        //---------------------------------------------------------------------
        
        /*
        let imageViewBanner : UIImageView = UIImageView(image: bannerImage)
        imageViewBanner.frame = CGRectMake(0, 0, bannerImage.size.width, bannerImage.size.height - 100)
        imageViewBanner.frame.origin = CGPoint(x: 0, y:(myScreenHeight/12))
        
        self.view.addSubview(imageViewBanner)
        */
        
        loadRandomBanner()
        
        //---------------------------------------------------------------------
        //Add buttons with images
        //---------------------------------------------------------------------
        
        let imageMail : UIImage = UIImage(named: "button-mail")!
        let imageMailButton   = UIButton(type: UIButtonType.Custom) as UIButton
        imageMailButton.frame = CGRectMake(0, 0, imageMail.size.width, imageMail.size.height)
        imageMailButton.setImage(imageMail, forState: .Normal)
        var j = -1.0
        j = -0.75
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
        j = 0.75
        xOffset = CGFloat(j) * (imageMailButton.frame.width)
        imageDonateButton.center = CGPointMake((myScreenWidth/2) + xOffset, (myScreenHeight/2) + (imageDonateButton.frame.height))
        
        imageDonateButton.tag = 2
        imageDonateButton.addTarget(self, action: "buttonActionDonate:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(imageDonateButton)
        
        
        //---------------------------------------------------------------------
        //Add back button with image - shows only on webview
        //---------------------------------------------------------------------
        
        let imageBack : UIImage = UIImage(named: "button-back")!
        //imageBackButton   = UIButton(type: UIButtonType.Custom) as UIButton
        imageBackButton.frame = CGRectMake(0, 0, imageBack.size.width, imageBack.size.height)
        imageBackButton.setImage(imageBack, forState: .Normal)
        xOffset = 0
        imageBackButton.center = CGPointMake((myScreenWidth/2) + xOffset, (myScreenHeight) - (myScreenHeight / 4))
        imageBackButton.tag = 3
        imageBackButton.addTarget(self, action: "buttonActionBack:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(imageBackButton)
        

        
        //---------------------------------------------------------------------
        //Add button labels
        //---------------------------------------------------------------------
       
        let DonateText = NSAttributedString(string: "Make a Donation", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        let DonateTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (myScreenWidth/3), height: (myScreenHeight/12)));
        DonateTextField.attributedPlaceholder = DonateText;
        DonateTextField.center = imageDonateButton.center;
        DonateTextField.frame.origin.y += imageDonate.size.height
        DonateTextField.font = UIFont(name: "Verdana", size: 30)
        DonateTextField.textAlignment = .Center
        DonateTextField.userInteractionEnabled = false
        self.view.addSubview(DonateTextField)
        
        let MailText = NSAttributedString(string: "Join Mailing List", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        let MailTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (myScreenWidth/3), height: (myScreenHeight/12)));
        MailTextField.attributedPlaceholder = MailText;
       MailTextField.center = imageMailButton.center;
        MailTextField.frame.origin.y += (imageDonate.size.height)
        MailTextField.font = UIFont(name: "Verdana", size: 30)
        MailTextField.textAlignment = .Center
        MailTextField.userInteractionEnabled = false
        self.view.addSubview(MailTextField)
        
        let BackText = NSAttributedString(string: "Go Back to App", attributes: [NSForegroundColorAttributeName : UIColor.blackColor()])
        BackTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (myScreenWidth/3), height: (myScreenHeight/12)));
        BackTextField.attributedPlaceholder = BackText;
        BackTextField.center = imageBackButton.center;
        BackTextField.frame.origin.y += (imageBack.size.height)
        BackTextField.font = UIFont(name: "Verdana", size: 30)
        BackTextField.textAlignment = .Center
        BackTextField.userInteractionEnabled = false
        self.view.addSubview(BackTextField)
        
        
        //Hide back button until web view shows
        self.view.sendSubviewToBack(BackTextField)
        self.view.sendSubviewToBack(imageBackButton)
        
        
        //This works
        //print("self.view.subviews.indexOf(BackTextField) :")
        //print(self.view.subviews.indexOf(BackTextField))
        
        //returns
        //self.view.subviews.indexOf(BackTextField) :
        //Optional(11)
        
        //---------------------------------------------------------------------
        //Timers
        //---------------------------------------------------------------------
        
        webTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateWebTimerCounter"), userInfo: nil, repeats: true)
        bannerTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateBannerTimerCounter"), userInfo: nil, repeats: true)
        
    }
    
    //---------------------------------------------------------------------
    //End Main
    //---------------------------------------------------------------------
    
    
    //---------------------------------------------------------------------
    //Begin Actions
    //---------------------------------------------------------------------
    
    
    //---------------------------------------------------------------------
    //Actions for buttons
    //---------------------------------------------------------------------
    
    
    func buttonActionDonate(sender:UIButton!){
        // runs when donate button is clicked
        //print("Button tapped")
        //print("Button tag :")
        //print (sender.tag)
        var button:UIButton = sender;
        //playSoundDing()
        playSoundClick()
        let alertController = UIAlertController(title: "Donations", message:
            "The Marine Mammal Center uses Square for donations made by credit or debit card - a volunteer can help you complete your donation", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
    }
  
    func buttonActionMail(sender:UIButton!){
        //runs when mailing list button is clicked
        //print("Button tapped")
        //print("Button tag :")
        //print (sender.tag)
        var button:UIButton = sender;
        playSoundClick()
        print("transition web")
        openWebPage()
    }
    
    func buttonActionBack(sender:UIButton!){
        //runs when back button is clicked - only available with webview shown
        print("Button tapped")
        print("Button tag :")
        print (sender.tag)
        playSoundClick()
        hideWebPage()
    }
        
    
    func openWebPage(){
        //opens tmmc site's ipad-specific sign up page
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.marinemammalcenter.org/Get-Involved/take-action/email-signup-ipad.html")!))
        //myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        
        //myWebView.scalesPageToFit = true
        myWebView.scrollView.scrollEnabled = false
        if (myWebView.hidden == true){
            myWebView.hidden = false
        } else {
            self.view.addSubview(myWebView)
        }
        self.view.bringSubviewToFront(myWebView)
        self.view.bringSubviewToFront(BackTextField)
        self.view.bringSubviewToFront(imageBackButton)
        isWebView = true
        webTimerCounter = 0
    }
    
    func hideWebPage(){
        myWebView.hidden = true
        isWebView = false
        URLState = "none"
        webCountdown = 4
        //hide keyboard
        view.endEditing(true)
        //hide back button
        self.view.sendSubviewToBack(BackTextField)
        self.view.sendSubviewToBack(imageBackButton)
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
    //Timer
    //---------------------------------------------------------------------
    
    func updateWebTimerCounter(){
        
        if  isWebView == true {
            print("web timer: ")
            print(webTimerCounter)
            webTimerCounter += 1
            if (URLState == "Thank you page"){
               webCountdown -= 1
            }
            
            if webCountdown <= 0 {
                hideWebPage()
            } else if (webTimerCounter == webTimerTimeout){
                //time reached to clear web view
                hideWebPage()
            }
        }
    }

    
    func updateBannerTimerCounter(){
        //print("banner timer: ")
        //print(bannerTimerCounter)
        if  isWebView == false {
            bannerTimerCounter += 1
            if (bannerTimerCounter == bannerTimeout) {
                //time reached to change banner image
                loadRandomBanner()
                bannerTimerCounter = 0
            }
        }
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
    
    func loadRandomBanner(){
        print("running random banner")
        
        let bannerSource = "local"
        var bannerImage : UIImage = UIImage(named: "banner2")!
        let localBanners : [String] = ["banner1","banner2","banner3"]
        var bannerString = localBanners[1]

        let myRand = randRange(0,upper: 2)
        
        var imageKey = "link3"
        
        if myRand == 0 {
            imageKey = "link1"
            bannerString = localBanners[0]
    
        }
        if myRand == 1 {
            imageKey = "link2"
            bannerString = localBanners[1]

        }
        if myRand == 2 {
            imageKey = "link3"
            bannerString = localBanners[2]
        }
        
        if bannerSource == "local" {
            //use banner included in app
            bannerImage = UIImage(named: (bannerString as String))!
           
            imageViewBanner.image = bannerImage
            
        }
        
        if bannerSource == "web"{
            //use banners on web
            let imageUrl = webBanners1600Dict[imageKey]!
            print("imageUrl")
            print(imageUrl)
    
            let url = NSURL(string: imageUrl as String)
            if let data = NSData(contentsOfURL: url!) {
                print("going with URL image")
                imageViewBanner.image = UIImage(data: data)
            
            }
        }
        
        //let myScreenWidth = myScreenSize.width
        //let myScreenHeight = myScreenSize.height

        imageViewBanner.frame =  CGRectMake(0, 0, bannerImage.size.width, bannerImage.size.height - 100)
        imageViewBanner.frame =  CGRectMake(0, 0, myScreenSize.width, (myScreenSize.width * 0.5))
        
        imageViewBanner.frame.origin = CGPoint(x: 0, y:80)
        imageViewBanner.contentScaleFactor = 0.5
        imageViewBanner.tag = 10
        view.addSubview(imageViewBanner)

    }

    
    //---------------------------------------------------------------------
    //Detect Touch
    //---------------------------------------------------------------------
    
    //unused
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            print("touch")
            let position = touch.locationInView(view)
            print(position)
            //clearCounter()
        }
    }
    */
    


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

