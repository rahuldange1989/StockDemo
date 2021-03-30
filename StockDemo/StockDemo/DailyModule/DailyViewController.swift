//
//  DailyViewController.swift
//  StockDemo
//
//  Created by Rahul Dange on 28/03/21.
//

import UIKit

class DailyViewController: UIViewController {

    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var symbolsTextField: UITextField!
    
    fileprivate let viewModel = DailyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    // MARK: - Internal methods
    fileprivate func handleCompareInfoBtnUI(enabled: Bool) {
        compareBtn.isEnabled = enabled
        compareBtn.alpha = enabled ? 1.0 : 0.5
    }
    
    private func setupUI() {
        /// to hide extra lines
        dailyTableView.tableFooterView = UIView()
        dailyTableView.accessibilityIdentifier = "daily-tableview"
        /// add left view to symbolTextField
        symbolsTextField.leftViewMode = .always
        symbolsTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 20))
    }
    
    //MARK: - Event handler methods
    @IBAction func compareBtnClicked(_ sender: Any) {
        /// hide keyboard when user touches outside it
        view.endEditing(true)
        
        let symbols = symbolsTextField.text ?? ""
        /// don't call api if symbol is empty
        if symbols.isEmpty {
            return
        }
        /// empty all arrays from view model
        viewModel.removeAllElements()
        
        Utility.showActivityIndicatory((parent?.view)!)
        viewModel.fetchDailyTimeSeries(for: symbols) { [weak self] msg in
            DispatchQueue.main.async {
                Utility.hideActivityIndicatory((self?.parent?.view)!)
                if msg.isEmpty {
                    self?.dailyTableView.reloadData()
                } else {
                    Utility.showAlert(self, title: "", message: msg)
                }
                
                /// hide or display no data label
                if !(self?.viewModel.getSortedTimeSeriesList().first?.isEmpty ?? true) {
                    self?.noDataLabel.isHidden = true
                    /// scrolling tableview to top after some time as reloadData is in progress.
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self?.dailyTableView.setContentOffset(.zero, animated: true)
                    }
                } else {
                    self?.noDataLabel.isHidden = false
                }
            }
        }
    }
}

/// Extension for UITextFieldDelegate methods
extension DailyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
           let currentText = textField.text ?? ""

        // attempt to read the range which user is trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else {
            handleCompareInfoBtnUI(enabled: false)
            return true
        }

        // add user's new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        handleCompareInfoBtnUI(enabled: updatedText.count > 0)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        compareBtnClicked(compareBtn ?? UIButton())
        return true
    }
}

/// Extension for UITableViewDatasource  methods
extension DailyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSortedTimeSeriesList().first?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell") as? DailyTableViewCell
        
        /// create new cell if it is nil
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "DailyTableViewCell") as? DailyTableViewCell
        }
        
        /// get current dailyTimeSeries for different symbols
        var compareDailySeriesArray: [(key: String, value: EquityInfoModel)] = []
        for currentDailySeries in viewModel.getSortedTimeSeriesList() {
            compareDailySeriesArray.append(currentDailySeries[indexPath.row])
        }
        cell?.setData(dailyTimeSeries: compareDailySeriesArray, symbols: viewModel.getSymbols())
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((viewModel.getSortedTimeSeriesList().count + 1) * 44)
    }
}

