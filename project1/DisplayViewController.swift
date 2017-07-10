//
//  DisplayViewController.swift
//  project1
//
//  Created by parth on 2/21/17.
//  Copyright © 2017 parthanand.com. All rights reserved.
//

import UIKit
import SCLAlertView
import MessageUI


class DisplayViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate  {

    
    var recognizedText: String?
    
    let convertedText: UITextView = {
    
        let tc = UITextView()
        tc.translatesAutoresizingMaskIntoConstraints = false
        tc.backgroundColor = .white
        tc.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        return tc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(convertedText)
        
        let image_cross : UIImage? = UIImage(named:"cross")!.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image_cross, style: .plain, target: self, action: #selector(handleCross))
        
        let image_share : UIImage? = UIImage(named:"share")!.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image_share, style: .plain, target: self, action: #selector(handleShare))
        
        
        setOrignalView()
        convertedText.text = recognizedText!
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func handleCross(){
    
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleShare(){
    
        let appearance = SCLAlertView.SCLAppearance(showCircularIcon: true, hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Whatsapp", target:self, selector:#selector(DisplayViewController.handleWhatsapp))
        alertView.addButton("Message", target:self, selector:#selector(DisplayViewController.handleMessage))
        alertView.addButton("Email", target:self, selector:#selector(DisplayViewController.handleEmail))

      _ = alertView.showCustom("Share!", subTitle: "share the extracted text with your friends", color: UIColor(red: 0, green: 102/255, blue: 1, alpha: 1), icon: UIImage(named: "share_icon")!)
        
        view.endEditing(true)
        
        setOrignalView()

    }
    
    func handleMessage(){

        if let text = convertedText.text {
            
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "\(text)"
            messageVC.recipients = [] // Optionally add some tel numbers
            messageVC.messageComposeDelegate = self
            // Open the SMS View controller
            present(messageVC, animated: true, completion: nil)
            
        }
    }

    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
            
        case MessageComposeResult.cancelled :
            print("message canceled")
             setOrignalView()
            
        case MessageComposeResult.failed :
            print("message failed")
            setOrignalView()

            
        case MessageComposeResult.sent :
            print("message sent")
            setOrignalView()

        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }

    
    func handleEmail(){

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([])
            
            if let text = convertedText.text {
                mail.setSubject("sent using Textify: Image Text Extractor")
                mail.setMessageBody("\(text)", isHTML: false)
            }
            present(mail, animated: true)
            
        } else {
            // show failure alert
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        setOrignalView()
    }
    
    func handleWhatsapp(){
    
        if let text = convertedText.text {
        
        var urlString = "\(text) \nSent using Textify: Image Text Extractor"
            
        var urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        var url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.openURL(url! as URL)
        }
    
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//                self.convertedText.frame.origin.y -= keyboardSize.height
                
                convertedText.frame = CGRect(x: 0 ,y: 0, width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height)


            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func setOrignalView(){
    
        convertedText.frame = CGRect(x: 0 ,y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
    }

    


}
