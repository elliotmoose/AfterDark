//
//  AddDetailedReviewViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 23/11/16.
//  Copyright © 2016 kohbroco. All rights reserved.
//

import UIKit

protocol AddDetailReviewDelegate : class {
    func DismissAddDetailReviewView()
    func UpdateReviewTable()
}

class AddDetailedReviewViewController: UIViewController,AddReviewDelegate {
    
    static let singleton = AddDetailedReviewViewController(nibName: "AddDetailedReviewViewController", bundle: Bundle.main)
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var avgSlider: ReviewStarSlider!
    
    @IBOutlet weak var pricingSlider: ReviewStarSlider!
    
    @IBOutlet weak var foodSlider: ReviewStarSlider!
    
    @IBOutlet weak var ambienceSlider: ReviewStarSlider!
    
    @IBOutlet weak var serviceSlider: ReviewStarSlider!
    
    @IBOutlet weak var avgLabel: UILabel!
    
    @IBOutlet weak var pricingLabel: UILabel!
    
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var ambienceLabel: UILabel!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    let loadingViewOverlay = UIView(frame: CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.ScreenHeight()))
    
    let loadSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    weak var delegate : AddDetailReviewDelegate?
    
    //METHODS
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        
        guard let currentBar = BarManager.singleton.displayedDetailBar else {return}
        
        //checks
        var errors = [String]()
        if avgSlider.currentRating == 0
        {
            errors.append("-Please Give a rating")
        }
        
        if titleTextField.text == "" || titleTextField.text == nil
        {
            errors.append("-Please Fill in Title")
        }
        
        if descriptionTextField.text == "" || descriptionTextField.text == nil
        {
            errors.append("-Please Fill in description")
        }
        
        if errors.count != 0
        {
            PopupManager.singleton.Popup(title: "Empty Fields:", body: errors.joined(separator: "\n"), presentationViewCont: self)
            
            return
        }
        
        //if no errors
        
        //ui
        PresentLoadingScreen()
        ShowActivity()
        
        
        var tempRating = Rating()
        tempRating.InjectValues(avgSlider.currentRating, pricex: pricingSlider.currentRating, ambiencex: ambienceSlider.currentRating, foodx: foodSlider.currentRating, servicex: serviceSlider.currentRating)
        
        
        if Settings.dummyAppOn
        {
            self.DismissLoadingScreen()
            self.HideActivity()
            
            PopupManager.singleton.Popup(title: "Done!", body: "Your review has been added! Thank you", presentationViewCont: self,handler: {
                
                self.delegate?.DismissAddDetailReviewView()
                self.titleTextField.text = ""
                self.descriptionTextField.text = ""
                
            })
        }
        
        ReviewManager.singleton.AddReview(title: titleTextField.text!, body: descriptionTextField.text!, rating: tempRating, bar: currentBar, userID: Account.singleton.user_ID!,handler: {
        (success,error) -> Void in
            
            self.DismissLoadingScreen()
            self.HideActivity()
            
            if success
            {
                PopupManager.singleton.Popup(title: "Done!", body: "Your review has been added! Thank you", presentationViewCont: self,handler: {
                    
                    //dismiss view
                    self.delegate?.DismissAddDetailReviewView()
                    
                    //reload reviews so that it shows your review
                    ReviewManager.singleton.ReloadReviews(currentBar, lowerBound: 0, count: 5, handler:{
                        (Bool) -> Void in
                        
                        //update ui
                        self.delegate?.UpdateReviewTable()
                        
                    })
                    
                    self.titleTextField.text = ""
                    self.descriptionTextField.text = ""
                    
                    
                })
            }
            else
            {
                PopupManager.singleton.Popup(title: "Oops!", body: "There seems to be an error: \(error)", presentationViewCont: self)
            }
        
        })
        
        
    }

    

    
    //INIT
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        self.modalPresentationStyle = .currentContext
        
        avgSlider.delegate = self
        pricingSlider.delegate = self
        foodSlider.delegate = self
        ambienceSlider.delegate = self
        serviceSlider.delegate = self
        
        self.view.addSubview(loadingViewOverlay)
        loadingViewOverlay.alpha = 0
        loadingViewOverlay.backgroundColor = UIColor.black
        
        self.loadingViewOverlay.addSubview(loadSpinner)
        loadSpinner.frame = CGRect(x: Sizing.ScreenWidth()/2-15, y: Sizing.HundredRelativeHeightPts()*2, width: 30, height: 30)
        loadSpinner.alpha = 0
        loadSpinner.color = UIColor.white
        loadSpinner.tintColor = UIColor.white
        
        //slider colors
        avgSlider.SetStarLayerColor(color: self.view.backgroundColor!)
        pricingSlider.SetStarLayerColor(color: self.view.backgroundColor!)
        foodSlider.SetStarLayerColor(color: self.view.backgroundColor!)
        ambienceSlider.SetStarLayerColor(color: self.view.backgroundColor!)
        serviceSlider.SetStarLayerColor(color: self.view.backgroundColor!)

        //shadows
        titleTextField.layer.shadowOpacity = 0.3
        titleTextField.layer.shadowColor = UIColor.black.cgColor
        titleTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleTextField.clipsToBounds = false
        descriptionTextField.layer.shadowOpacity = 0.3
        descriptionTextField.layer.shadowColor = UIColor.black.cgColor
        descriptionTextField.layer.shadowOffset = CGSize(width: 1, height: 2)
        descriptionTextField.clipsToBounds = false

        
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: ColorManager.placeholderTextColor])
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSForegroundColorAttributeName: ColorManager.placeholderTextColor])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    internal func ratingUpdated(slider : ReviewStarSlider) {
        
        if slider == avgSlider
        {
            pricingSlider.SetRating(rating: slider.currentRating)
            foodSlider.SetRating(rating: slider.currentRating)
            ambienceSlider.SetRating(rating: slider.currentRating)
            serviceSlider.SetRating(rating: slider.currentRating)
        }
        else
        {
            //set avgslider to avg rating
            let avgRating :Float = (pricingSlider.currentRating + foodSlider.currentRating + ambienceSlider.currentRating + serviceSlider.currentRating)/4
            avgSlider.SetRating(rating: avgRating)
        }
        
        //update labels
        avgLabel.text = String(describing: avgSlider.currentRating)
        pricingLabel.text = String(describing: pricingSlider.currentRating)
        foodLabel.text = String(describing: foodSlider.currentRating)
        ambienceLabel.text = String(describing: ambienceSlider.currentRating)
        serviceLabel.text = String(describing: serviceSlider.currentRating)
        
        
    }

    
    func PresentLoadingScreen()
    {
        UIView.animate(withDuration: 0.7, animations: {
            self.loadingViewOverlay.alpha = 0.7
        })
    }
    
    func ShowActivity()
    {
        loadSpinner.alpha = 1
        loadSpinner.startAnimating()
    }
    
    func HideActivity()
    {
        loadSpinner.alpha = 0
        loadSpinner.stopAnimating()
    }
    
    func DismissLoadingScreen()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingViewOverlay.alpha = 0
        })
    }

}
