//
//  GithubViewController.swift
//  MVVMAPICalling
//
//  Created by Arpit iOS Dev. on 14/06/24.
//

import UIKit
import SDWebImage

class GithubViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = GithubViewModel()
    var githubImage = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let text = searchTextField.text else {
            print("Please Enter text")
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel.fetchRandomGithubData(query: text) { result in
                switch result {
                case .success(let data):
                    self?.githubImage = data.items
                case .failure(let error):
                    print("Error fetching quotes: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - TableView Dalegate & Datasource
extension GithubViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return githubImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GithubTableViewCell") as! GithubTableViewCell
        let item = githubImage[indexPath.row]
        cell.avtarImageView.sd_setImage(with: URL(string: item.avatarURL), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173
    }
}
