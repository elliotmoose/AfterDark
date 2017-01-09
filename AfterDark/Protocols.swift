//
//  protocols.swift
//  AfterDark
//
//  Created by Koh Yi Zhi Elliot - Ezekiel on 9/1/17.
//  Copyright © 2017 kohbroco. All rights reserved.
//

import Foundation
import UIKit

protocol TabDelegate : class {
    func NavCont() -> UINavigationController
}

protocol MainCellDelegate : class{
    func NavCont() -> UINavigationController
}
