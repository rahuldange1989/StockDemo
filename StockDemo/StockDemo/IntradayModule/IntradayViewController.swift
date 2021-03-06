//
//  IntradayViewController.swift
//  StockDemo
//
//  Created by Rahul Dange on 28/03/21.
//

import UIKit

class IntradayViewController: UIViewController {

    @IBOutlet weak var intradayTableView: UITableView!
    @IBOutlet weak var getInfoBtn: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var symbolTextField: UITextField!
    
    fileprivate let viewModel = IntradayViewModel()
    private var sortOptionsSheet: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    // MARK: - Internal methods
    fileprivate func handleGetInfoBtnUI(enabled: Bool) {
        getInfoBtn.isEnabled = enabled
        getInfoBtn.alpha = enabled ? 1.0 : 0.5
    }
    
    private func setupUI() {
        /// to hide extra lines
        intradayTableView.tableFooterView = UIView()
        intradayTableView.accessibilityIdentifier = "intraday-tableview"
        /// add left view to symbolTextField
        symbolTextField.leftViewMode = .always
        symbolTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 20))
        /// create sort options actionsheet
        sortOptionsSheet = UIAlertController(title: "", message: AppConstants.sorting_option_message, preferredStyle: .actionSheet)
        sortOptionsSheet?.view.tintColor = AppConstants.theme_color
        /// add different sorting options
        let actions = self.createSortActions(with: [.dateAscending, .dateDescending, .highAscending, .highDescending, .lowAscending, .lowDescending, .openAscending, .openDescending])
        for action in actions {
            sortOptionsSheet?.addAction(action)
        }
    }
    
    private func createSortActions(with actionArray: [SortOptions]) -> [UIAlertAction] {
        var alertActions: [UIAlertAction] = []
        for option in actionArray {
            let action = UIAlertAction.init(title: option.rawValueString(), style: .default) { [weak self] (action) in
                // -- add sort action handler code
                _ = self?.viewModel.sortTimeSeriesModelDict(with: action.title ?? "")
                DispatchQueue.main.async {
                    self?.intradayTableView.reloadData()
                }
            }
            alertActions.append(action)
        }
        // -- add cancel action
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertActions.append(cancelAction)
        return alertActions
    }
    
    //MARK: - Event handler methods
    @IBAction func sortBtnClicked(_ sender: Any) {
        /// present action sheet
        guard let sortOptionsSheet = sortOptionsSheet else { return }
        present(sortOptionsSheet, animated: false, completion: nil)
    }
    
    @IBAction func getInfoBtnClicked(_ sender: Any) {
        /// hide keyboard when user touches outside it
        view.endEditing(true)
        
        let symbol = symbolTextField.text ?? ""
        /// don't call api if symbol is empty
        if symbol.isEmpty {
            return
        }
        
        Utility.showActivityIndicatory((parent?.view)!)
        viewModel.fetchIntradayTimeSeries(for: symbol) { [weak self] msg in
            DispatchQueue.main.async {
                Utility.hideActivityIndicatory((self?.parent?.view)!)
                if msg.isEmpty {
                    self?.intradayTableView.reloadData()
                } else {
                    Utility.showAlert(self, title: "", message: msg)
                }
                
                /// hide or display no data label
                if !(self?.viewModel.getSortedTimeSeriesList().isEmpty ?? true) {
                    self?.noDataLabel.isHidden = true
                    /// scrolling tableview to top after some time as reloadData is in progress.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.intradayTableView.setContentOffset(.zero, animated: false)
                    }
                } else {
                    self?.noDataLabel.isHidden = false
                }
            }
        }
    }
}

/// Extension for UITextFieldDelegate methods
extension IntradayViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
           let currentText = textField.text ?? ""

        // attempt to read the range which user is trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else {
            handleGetInfoBtnUI(enabled: false)
            return true
        }

        // add user's new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        handleGetInfoBtnUI(enabled: updatedText.count > 0)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getInfoBtnClicked(getInfoBtn ?? UIButton())
        return true
    }
}

/// Extension for UITableViewDatasource methods
extension IntradayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSortedTimeSeriesList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "IntradayTableViewCell") as? IntradayTableViewCell
        
        /// create new cell if it is nil
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "IntradayTableViewCell") as? IntradayTableViewCell
        }
        
        /// get current timeseries
        let currentTimeSeries = viewModel.getSortedTimeSeriesList()[indexPath.row]
        cell?.setData(timeSeries: currentTimeSeries)
        
        return cell!
    }
}
