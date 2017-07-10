//
//  ViewController.swift
//  project1
//
//  Created by parth on 2/16/17.
//  Copyright © 2017 parthanand.com. All rights reserved.
//

import UIKit
import TesseractOCR
import paper_onboarding
import SwiftyUserDefaults


class ViewController: UIViewController, G8TesseractDelegate{

    
    let logo: UIImageView = {
        let tv = UIImageView()
        tv.image = UIImage(named: "logo1")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var start: UIButton={
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Get Started", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        
        return button
        
    }()
    
       override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        start.isHidden = true
        logo.isHidden = true

        
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
        view.addSubview(logo)
        view.addSubview(start)
        
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        logo.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        logo.heightAnchor.constraint(equalToConstant: view.frame.height * 0.17 * 0.7).isActive = true


        start.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        start.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 60).isActive = true
        start.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        start.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        print("width = \(view.frame.width)")
        print("height = \(view.frame.height)")

       
    }
    
    func getStarted(){
        
//        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "showCropvc") as! CropViewController
//        
////        self.navigationController?.pushViewController(vc, animated:true)
//        
//        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
        Defaults[.visited] = "vis"

        
        present(UINavigationController(rootViewController: PickAndCropViewController()), animated: true, completion: nil)
        
    }
    
}

extension ViewController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        start.isHidden = index == 2 ? false : true
        
        logo.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {

    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {

        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension ViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        return [
            (UIImage.Asset.Text.rawValue, "Extract", "Extract text from images and screenshots and that too without any internet connection! ", UIImage.Asset.Empty.rawValue, UIColor(red:0, green:0.6, blue:0, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            (UIImage.Asset.Language.rawValue, "Language", "Scan documents written in various languages such as English, French, Spanish, Hindi.", UIImage.Asset.Empty.rawValue, UIColor(red:0, green:71/255, blue:179/255, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            (UIImage.Asset.Empty.rawValue, "", "", UIImage.Asset.Empty.rawValue, UIColor(red:204/255, green:0, blue:0, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
}

extension UIImage {
    enum Asset: String {
        case Banks = "Banks"
        case Hotels = "Hotels"
        case Key = "Key"
        case Shopping_Cart = "Shopping-cart"
        case Stores = "Stores"
        case Wallet = "Wallet"
        case Text = "Text"
        case Language = "Language"
        case Empty = ""
        
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

