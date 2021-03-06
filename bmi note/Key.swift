//
//  Constants.swift
//  bmi note
//
//  Created by Walter J on 2022/03/04.
//

import Foundation

struct Key {        
    static let historyListCell = "HistoryListCell"
    static let historyListCellIdentifier = "HistoryListCell"
    static let bmiResultVC = "BmiResultVC"
    static let profile = "Profile"  //프로필 UserDefaults Key
    static let history = "History"  //계산 데이터 저장에 활용될 UserDefaults Key
    
    //Segue Identifier
    static let profileIdentifier = "goProfileEditView"
    static let bmiResultIdentifier = "goBmiResultView"
    static let historyListIdentifier = "goHistoryListView"
    
}
