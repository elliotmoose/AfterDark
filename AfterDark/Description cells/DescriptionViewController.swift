//
//  DescriptionViewController.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 5/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    init()
    {
        super.init(nibName: "DescriptionViewController", bundle: Bundle.main)
        Bundle.main.loadNibNamed("DescriptionViewController", owner: self, options: nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Bundle.main.loadNibNamed("DescriptionViewController", owner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func ReloadData()
    {
        guard let bar = BarManager.singleton.displayedDetailBar else {return}
        textView.text = bar.description
    }
    
    override func viewDidLayoutSubviews() {
        
        let detailViewFrame = CGRect(x: 0, y: 0, width: Sizing.ScreenWidth(), height: Sizing.mainViewHeight - Sizing.tabHeight - Sizing.galleryHeight)

        self.view.frame = detailViewFrame
    }
}
