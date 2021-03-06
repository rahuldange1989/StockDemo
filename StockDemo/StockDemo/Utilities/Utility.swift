//
//  Utility.swift
//  StockDemo
//
//  Created by Rahul Dange on 28/03/21.
//

import UIKit

class Utility {
    /// show Alert on given viewController with title and message
    /// - parameters:
    ///     - parent: viewController on which alert to be shown
    ///     - title: title of the alert
    ///     - message: message string of the alert
    ///
    static func showAlert(_ parent: UIViewController?, title:String, message:String) {
        if let p = parent {
            let alertView: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            /// Add the actions.
            alertView.addAction(okAction)
            /// add accesibility identifier
            alertView.view.accessibilityIdentifier = "common-alert"
            p.present(alertView, animated: true, completion: nil)
        }
    }
    
    /// show activityIndicator on given UIView
    /// - parameters:
    ///     - uiView: UiVIew on which activity Indicator to be shown
    ///
    static func showActivityIndicatory(_ uiView: UIView) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.init(netHex: 0xFFFFFF, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.init(netHex: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0);
        actInd.style =
            UIActivityIndicatorView.Style.large
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        container.tag = 2134
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    /// hide activityIndicator on given UIView
    /// - parameters:
    ///     - uiView: UiVIew on which activity Indicator to be hidden
    ///
    static func hideActivityIndicatory(_ uiView: UIView) {
        if let viewWithTag = uiView.viewWithTag(2134) {
            viewWithTag.removeFromSuperview()
        }
        else {
            print("hideActivityIndicatory: tag not found")
        }
    }
    
    /// get dateString in required format from given datetime string
    /// - parameters:
    ///     - dateString: dateString to be converted to required format
    ///     - isIntradayDate: if date required is for Intraday API. defaults value it true
    ///
    static func getDateStringFrom(dateString: String, isIntradayDate: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isIntradayDate ? AppConstants.incoming_intraday_date_format : AppConstants.incoming_daily_date_format
        let date = dateFormatter.date(from: dateString) ?? Date()
        /// change dateFormatter to required date format
        let requiredDateFormat = isIntradayDate ? AppConstants.required_date_format + " " + AppConstants.required_time_format : AppConstants.required_date_format
        dateFormatter.dateFormat = requiredDateFormat
        return dateFormatter.string(from: date)
    }
}

// MARK: - UIColor Extension for implementing nethex value acceptance -
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha:CGFloat, dummy: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(netHex:Int, alpha: CGFloat) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alpha:alpha, dummy: 0)
    }
}

// MARK: - String extension -
extension String {
    func percentageEncoding() -> String {
        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
