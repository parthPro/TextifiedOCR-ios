//
//  PickAndCropViewController.swift
//  project1
//
//  Created by parth on 2/24/17.
//  Copyright © 2017 parthanand.com. All rights reserved.
//

import UIKit
import ByvImagePicker
import TesseractOCR
import ALLoadingView
import CPAlertViewController
import BTNavigationDropdownMenu


class PickAndCropViewController: UIViewController, G8TesseractDelegate{
    
    var picker:ByvImagePicker? = nil
    
    let items = ["English", "Spanish", "French", "Hindi"]

    var languageChosen: String = "eng"

    
    let button_pick: UIButton={
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0, green: 102/255, blue: 1, alpha: 1)

        button.setTitle("Select", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlePickAndCrop), for: .touchUpInside)
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    let button_read: UIButton={
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0, green: 102/255, blue: 1, alpha: 1)
        button.setTitle("Read", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRead), for: .touchUpInside)
        button.layer.cornerRadius = 5
        
        return button
        
    }()
    
    
    let imageview: UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "sample")
        image.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let bottomView: UIView = {
    
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 102/255, blue: 1, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    
    let line: UIView = {
    
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray

        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        setUpLanguageMenu()
        
        
        let image_help : UIImage? = UIImage(named:"help")!.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image_help, style: .plain, target: self, action: #selector(handleHelp))
        
        }
    
    
    func setUpLanguageMenu(){
    
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: items[0], items: items as [AnyObject])
        
        menuView.menuTitleColor = .white
//      menuView.navigationBarTitleFont = UIFont (name: "HelveticaNeue-Light", size: 16)
        menuView.cellTextLabelColor = .white
//      menuView.cellSeparatorColor = .white
        menuView.cellTextLabelFont = UIFont (name: "HelveticaNeue-Light", size: 16)
        
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            

            switch indexPath {
            case 0:
                self?.languageChosen = "eng"
            case 1:
                self?.languageChosen = "spa"
            case 2:
                self?.languageChosen = "fra"
            case 3:
                self?.languageChosen = "hin"
            default:
                self?.languageChosen = "eng"
            }
            
            
        }

    }
    
    
    func setUpViews(){
    
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 102/255, blue: 1, alpha: 1)

        navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        
        view.addSubview(imageview)
        view.addSubview(bottomView)
        bottomView.addSubview(line)
        bottomView.addSubview(button_read)
        bottomView.addSubview(button_pick)
        
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: view.frame.height * 0.8).isActive = true
        
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.07).isActive = true
        
        line.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -2).isActive = true
        line.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        button_pick.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        button_pick.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        button_pick.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        button_pick.rightAnchor.constraint(equalTo: line.leftAnchor).isActive = true
        
        button_read.leftAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        button_read.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        button_read.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        button_read.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true

    
    }
    
    func handleHelp(){
        
        CPAlertViewController().showInfo(title: "Shooting Tips!", message: "1. Only text documents can be converted \n 2. take pictures in good light", buttonTitle: "OK", otherButtonTitle: nil, action: nil)
    }
    

    
    
    func handlePickAndCrop(){
        
        if picker == nil {
            picker = ByvImagePicker()
        }
        let from = ByvFrom(controller: self, from: .init(x: 0, y: 0, width: 50, height: 50), inView:self.view, arrowDirections:.any)
        
        picker!.getEditableImage(from: from, completion: { image in
            
            if let image = image {
            
            self.imageview.image = image
            
            }
            
        })
        
    }
    
    func handleRead() {
    
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .fullscreen)
        ALLoadingView.manager.messageText = "Extracting..."
        
            DispatchQueue.global(qos: .background).async {
                
                if let tesseract = G8Tesseract(language: "\(self.languageChosen)") {
                    
                    let dcv = DisplayViewController()
                    
                    tesseract.delegate = self
                    tesseract.image = self.imageview.image?.g8_blackAndWhite()
                    
                    tesseract.recognize()
                    
                    dcv.recognizedText = tesseract.recognizedText
                    self.present(UINavigationController(rootViewController: dcv), animated: true, completion: nil)
                    
                    ALLoadingView.manager.hideLoadingView()
                    
                }
                
            }
    }
    
}


