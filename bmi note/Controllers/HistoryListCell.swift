//
//  HistoryListCell.swift
//  bmi note
//
//  Created by Walter J on 2022/03/04.
//

import UIKit

class HistoryListCell: UITableViewCell {

    @IBOutlet weak var historyListCell: UIView!
    @IBOutlet weak var bmiValue: UILabel!
    @IBOutlet weak var bmiState: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var regDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Cell 가장자리 둥글게
        configView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     Cell 모양 설정
     */
    func configView() {
        self.historyListCell.layer.cornerRadius = self.frame.height / 4
    }
}
