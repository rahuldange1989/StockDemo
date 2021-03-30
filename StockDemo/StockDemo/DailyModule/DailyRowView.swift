//
//  DailyRowView.swift
//  StockDemo
//
//  Created by Rahul Dange on 30/03/21.
//

import UIKit

class DailyRowView: UIView {
    
    init(frame: CGRect, dailyTimeRecord: EquityInfoModel, symbol: String) {
        super.init(frame: frame)
        createDailyView(with: [symbol, dailyTimeRecord.open, dailyTimeRecord.low])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods -
    private func createLabel(with value: String, lastXPosition: CGFloat) -> UILabel {
        let width = frame.width * (lastXPosition == 0 ? 0.4 : 0.3)
        let label = UILabel(frame: .init(x: lastXPosition, y: 10, width: width, height: 30))
        label.font = AppConstants.helvetica_regular_font
        label.text = value
        return label
    }
    
    private func createDailyView(with labelStrings: [String]) {
        let lastXPositionArray = [0.0, frame.width * 0.4, frame.width * 0.7]
        for i in 0...2 {
            let label = createLabel(with: labelStrings[i], lastXPosition: lastXPositionArray[i])
            addSubview(label)
        }
    }
}
