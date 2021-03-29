//
//  IntradayTableViewCell.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

import UIKit

class IntradayTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(key dateTime: String, value: EquityInfoModel?) {
        guard let infoModel = value else { return }
        openLabel.text = infoModel.open
        lowLabel.text = infoModel.low
        highLabel.text = infoModel.high
        dateTimeLabel.text = Utility.getDateStringFrom(dateString: dateTime)
    }
}
