//
//  ViewController.swift
//  MVVMAPICalling
//
//  Created by Arpit iOS Dev. on 14/06/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = QuoteViewModel()
    var quotes: [WelcomeElement] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let count = textField.text else {
            print("Please Enter Count")
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel.fetchRandomMovieQuotes(count: count) { result in
                switch result {
                case .success(let quotes):
                    self?.quotes = quotes
                case .failure(let error):
                    print("Error fetching quotes: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - TableView Dalegate & Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.quoteLbl.text = quotes[indexPath.row].quote
        cell.authorLbl.text = quotes[indexPath.row].author
        cell.categoryLbl.text = quotes[indexPath.row].category
        
        return cell
    }
}
