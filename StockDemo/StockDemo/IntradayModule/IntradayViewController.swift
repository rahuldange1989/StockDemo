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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// hide keyboard when user touches outside it
        view.endEditing(true)
    }
    
    //MARK: - Internal methods
    fileprivate func handleGetInfoBtnUI(enabled: Bool) {
        getInfoBtn.isEnabled = enabled
        getInfoBtn.alpha = enabled ? 1.0 : 0.5
    }
    
    private func setupUI() {
        /// to hide extra lines
        intradayTableView.tableFooterView = UIView()
        /// add left view to symbolTextField
        symbolTextField.leftViewMode = .always
        symbolTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 20))
    }
    
    //MARK: - Event handler methods
    @IBAction func sortBtnClicked(_ sender: Any) {
    
    }
    
    @IBAction func getInfoBtnClicked(_ sender: Any) {
        Utility.showActivityIndicatory((parent?.view)!)
        viewModel.fetchIntradayTimeSeries(for: symbolTextField.text ?? "") { [weak self] msg in
            DispatchQueue.main.async {
                Utility.hideActivityIndicatory((self?.parent?.view)!)
                if msg.isEmpty {
                    self?.intradayTableView.reloadData()
                } else {
                    Utility.showAlert(self, title: "Error", message: msg)
                }
                
                /// hide or display no data label
                if !(self?.viewModel.getSortedKeys().isEmpty ?? true) {
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
}

/// Extension for UITableViewDatasource methods
extension IntradayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSortedKeys().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "IntradayTableViewCell") as? IntradayTableViewCell
        
        /// create new cell if it is nil
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "IntradayTableViewCell") as? IntradayTableViewCell
        }
        
        /// get current key i.e. date string
        let currentKey = viewModel.getSortedKeys()[indexPath.row]
        let currentInfoModel = viewModel.getTimeSeriesModelDict()[currentKey]
        cell?.setData(key: currentKey, value: currentInfoModel)
        
        return cell!
    }
}
