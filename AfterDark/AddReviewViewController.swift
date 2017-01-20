//
//  AddReviewViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

protocol AddReviewToReviewContDelegate : class
{
    func Dismiss()
    func LoadCanGiveReview()
}

class AddReviewViewController: UIViewController,AddReviewDelegate {

    static let singleton = AddReviewViewController(nibName: "AddReviewViewController", bundle: Bundle.main)
    
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
    
    @IBOutlet weak var loadingViewOverlay: UIView!
    
    
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var overlayBG: UIView!
    
    weak var delegate : AddReviewToReviewContDelegate?
    @IBAction func Dismiss(_ sender: Any) {
        self.delegate?.Dismiss()
    }
    
    
    
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        //submit review
        guard let currentBar = BarManager.singleton.displayedDetailBar else {return}
        
        //checks
        var errors = [String]()
        if avgSlider.currentRating == 0
        {
            errors.append("-Please Give a rating")
        }
        

        if errors.count != 0
        {
            PopupManager.singleton.Popup(title: "Empty Fields:", body: errors.joined(separator: "\n"), presentationViewCont: self)
            
            return
        }
        
        //if no errors
        

        var tempRating = Rating()
        tempRating.InjectValues(avgSlider.currentRating, pricex: pricingSlider.currentRating, ambiencex: ambienceSlider.currentRating, foodx: foodSlider.currentRating, servicex: serviceSlider.currentRating)
        
        //check if low rating 
        if avgSlider.currentRating < 3 || pricingSlider.currentRating < 2 || ambienceSlider.currentRating < 2 || foodSlider.currentRating < 2 || serviceSlider.currentRating < 2
        {
            PopupManager.singleton.PopupWithTextInput(title: "How can we improve:", body: "", presentationViewCont: self, handler: {
                (output) -> Void in
                
                if output != "" && output != " "
                {
                    
                    //is loading ui
                    self.PresentLoadingScreen()
                    self.ShowActivity()
                    
                    print(output)
                    //dummy app
                    if Settings.dummyAppOn
                    {
                        self.DismissLoadingScreen()
                        self.HideActivity()
                        
                        PopupManager.singleton.Popup(title: "Done!", body: "Your review has been added! Thank you", presentationViewCont: self)
                        
                        return
                        
                    }
                    
                    self.SubmitReview(title: "", body: output, rating: tempRating, bar: currentBar, userID: Account.singleton.user_ID!)

                }
                else
                {
                    PopupManager.singleton.Popup(title: "Oops!", body: "Please help us by providing us with some constructive feedback", presentationViewCont: self)
                }
                
            })
        }
        else
        {
            SubmitReview(title: "", body: "", rating: tempRating, bar: currentBar, userID: Account.singleton.user_ID!)
        }
    }
    
    func SubmitReview(title : String,body : String, rating : Rating, bar : Bar,userID : String)
    {
        ReviewManager.singleton.AddReview(title: title, body: body, rating: rating, bar: bar, userID: userID,handler: {
            (success,error) -> Void in
            
            DispatchQueue.main.async {
                self.DismissLoadingScreen()
                self.HideActivity()
                
                if success
                {
                    PopupManager.singleton.Popup(title: "Done!", body: "Your review has been added! Thank you", presentationViewCont: self,handler: {
                        
                        //update ability to give review
                        self.delegate?.LoadCanGiveReview()
                        self.delegate?.Dismiss()
                        
                    })
                }
                else
                {
                    
                    PopupManager.singleton.Popup(title: "Oops!", body: "There seems to be an error: \(error)", presentationViewCont: self, handler:
                        {
                            self.delegate?.Dismiss()
                    })
                }
            }

        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed(nibNameOrNil!, owner: self, options: nil)
        
        avgSlider.delegate = self
        pricingSlider.delegate = self
        foodSlider.delegate = self
        ambienceSlider.delegate = self
        serviceSlider.delegate = self
        
        overlayBG.clipsToBounds = false
        overlayBG.layer.cornerRadius = 3
        overlayBG.layer.shadowOpacity = 0.8
        overlayBG.layer.shadowOffset =  CGSize(width: 1, height: 2)
        overlayBG.layer.shadowRadius = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLayoutSubviews() {
        
    }

    func ratingUpdated(slider: ReviewStarSlider) {
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
