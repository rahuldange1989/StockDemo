//
//  DailyTableViewCell.swift
//  StockDemo
//
//  Created by Rahul Dange on 30/03/21.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - private methods -
    func createAndAddDateLabel(date: String) {
        let dateLabel = UILabel()
        dateLabel.font = AppConstants.helvetica_medium_font
        dateLabel.text = date
        stackView.addArrangedSubview(dateLabel)
    }
    
    // MARK: - Internal methods -
    func setData(dailyTimeSeries: [(key: String, value: EquityInfoModel)], symbols: [String]) {
        /// remove all subviews from stackview
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        
        /// get date text
        if dailyTimeSeries.count > 0 {
            let dateString = Utility.getDateStringFrom(dateString: dailyTimeSeries[0].key,
                                                  isIntradayDate: false)
            createAndAddDateLabel(date: dateString)
        }
            
        /// DailyRowView frame
        let frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 50)
        for i in 0..<dailyTimeSeries.count {
            let currentDailyValue = dailyTimeSeries[i].value
            let symbol = symbols[i]
            let dailyView = DailyRowView(frame: frame, dailyTimeRecord: currentDailyValue, symbol: symbol)
            stackView.addArrangedSubview(dailyView)
        }
    }
}
