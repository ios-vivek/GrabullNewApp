//
//  StateSelectionPopupVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 03/06/26.
//

import UIKit

protocol StateSelectionDelegate: AnyObject {
    func didSelectState(_ state: String)
}

class StateSelectionPopupVC: UIViewController {
    
    weak var delegate: StateSelectionDelegate?
    
    let usStates = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
        "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
        "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
        "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
        "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
        "New Hampshire", "New Jersey", "New Mexico", "New York",
        "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
        "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
        "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    var filteredStates: [String] = []
    var tableView: UITableView!
    var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredStates = usStates
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupUI()
    }
    
    private func setupUI() {
        // Container view
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        // Header with title and close button
        let headerView = UIView()
        headerView.backgroundColor = themeBackgrounColor
        containerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Select State"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("✕", for: .normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        headerView.addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeBtn.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            closeBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: 30),
            closeBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Search TextField
        searchTextField = UITextField()
        searchTextField.placeholder = "Search state..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
        containerView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // TableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StateCell")
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
}

extension StateSelectionPopupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "StateCell")
        cell.textLabel?.text = filteredStates[indexPath.row]
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedState = filteredStates[indexPath.row]
        delegate?.didSelectState(selectedState)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension StateSelectionPopupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let searchText = text.replacingCharacters(in: range, with: string)
            
            if searchText.isEmpty {
                filteredStates = usStates
            } else {
                filteredStates = usStates.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
            
            tableView.reloadData()
        }
        return true
    }
}
