//
//  SettingsViewController.swift
//  StockDemo
//
//  Created by Rahul Dange on 28/03/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var apiKeyField: UITextField!
    @IBOutlet weak var intervalField: UITextField!
    @IBOutlet weak var outputSizeControl: UISegmentedControl!
    
    fileprivate var intervalOptionsSheet: UIAlertController?
    private var outputSizeString = ""
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// populate UI
        viewModel.populateSettingsValue { (apiKey, interval, outputSize, segmentIndex: Int) in
            apiKeyField.text = apiKey
            intervalField.text = interval
            outputSizeString = outputSize
            outputSizeControl.selectedSegmentIndex = segmentIndex
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// hide keyboard on touch if apiKeyField is firstResponder
        if apiKeyField.isFirstResponder {
            self.view.endEditing(true)
        }
    }
    
    // MARK: - private methods -
    private func setupUI() {
        /// add left view to apiKeyField and intervalfield
        for field in [apiKeyField, intervalField] {
            field?.leftViewMode = .always
            field?.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 20))
        }
        /// create interval options actionsheet
        intervalOptionsSheet = UIAlertController(title: "", message: AppConstants.interval_option_message, preferredStyle: .actionSheet)
        intervalOptionsSheet?.view.tintColor = AppConstants.theme_color
        /// add different sorting options
        let actions = createIntervalActions(with: [.oneMin, .fiveMin, .fifteenMin, .fifteenMin, .thirtyMin, .sixtyMin])
        for action in actions {
            intervalOptionsSheet?.addAction(action)
        }
    }
    
    private func createIntervalActions(with actionArray: [TimeInterval]) -> [UIAlertAction] {
        var alertActions: [UIAlertAction] = []
        for option in actionArray {
            let action = UIAlertAction.init(title: option.rawValue, style: .default) { [weak self] (action) in
                // -- add interval action handler code
                //_ = self?.viewModel.sortTimeSeriesModelDict(with: action.title ?? "")
                self?.intervalField.text = action.title
            }
            alertActions.append(action)
        }
        // -- add cancel action
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertActions.append(cancelAction)
        return alertActions
    }
    
    // MARK: - event handler methods -
    @IBAction func outputSizeChanged(_ sender: UISegmentedControl) {
        outputSizeString = sender.selectedSegmentIndex == 0 ? "compact" : "full"
    }
    
    @IBAction func saveSettingsBtnClicked(_ sender: Any) {
        /// hide keyboard
        view.endEditing(true)
        /// save settings
        viewModel.saveSettings(apiKey: apiKeyField.text ?? "",
                               interval: intervalField.text ?? "",
                               outputSize: outputSizeString) { msg in
            var message = msg
            if msg.isEmpty {
                message = AppConstants.settings_data_save_success_msg
            }
            Utility.showAlert(self, title: "", message: message)
        }
    }
}

/// Extension for UITextFieldDelegate methods
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let intervalOptionsSheet = intervalOptionsSheet, textField == intervalField {
            /// if apikeyfield if first responder then resign first responder
            if apiKeyField.isFirstResponder {
                self.apiKeyField.resignFirstResponder()
            }
            /// present interval options sheet
            present(intervalOptionsSheet, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

