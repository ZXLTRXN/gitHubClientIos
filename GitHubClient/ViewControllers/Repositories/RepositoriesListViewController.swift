//
//  RepositoriesListViewController.swift
//  GitHubClient
//
//  Created by Ilya Shevtsov on 23.06.2022.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class RepositoriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: ErrorView!
    @IBOutlet private weak var activityIndicator: MDCActivityIndicator!
    
    private let appRepo = AppRepository.shared
    
    private var repos: Array<Repo> = []
    private let cellIdentifier = "RepositoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setUI()
        getData()
    }
    
    private func setUI() {
        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        activityIndicator.setColor()
        activityIndicator.radius = 28
        
        title = NSLocalizedString("REPOSITORIES_TITLE", comment: "")
        navigationItem.backButtonTitle = ""
        setExitButton()
    }
    
    private func getData() {
        loadingStart()
        appRepo.getRepositories { [weak self] repos, error in
            self?.activityIndicator.hide()
            if let repos = repos {
                self?.hideErrorView(self?.errorView)
                self?.repos = repos
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
                return
            }
            
            if let error = error {
                self?.showErrorView(self?.errorView, error: error) { self?.getData() }
            }
        }
    }
    
    private func loadingStart() {
        hideErrorView(errorView)
        tableView.isHidden = true
        activityIndicator.show()
    }
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepositoryTableViewCell
        cell.setData(repo: repos[indexPath.row])
        return cell
    }
    //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = RepositoryDetailInfoViewController(repo: repos[indexPath.row], nibName: "RepositoryDetailInfoViewController", bundle: nil)
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
