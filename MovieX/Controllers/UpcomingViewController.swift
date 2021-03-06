//
//  UpcomingViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    //MARK: - Properties
    
    private var titles:[Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.idintifier)
        return table
    }()
    
    //MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUpcomingTable()
        configureUI()
        fetchTitles()
    }
    
    override func viewDidLayoutSubviews() {
        upcomingTable.frame = view.bounds
    }
    
    //MARK: - Helper methods
    
    private func configureUI(){
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .systemBackground
        view.addSubview(upcomingTable)
    }
    
    private func setupUpcomingTable(){
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    private func fetchTitles(){
        APICaller.shared.fetchTitleData(with: Constants.upcomingMoviesURL) { [weak self] result in
            switch result{
            case .success (let trending):
                (self?.titles = trending)
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - TableView implementation

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.idintifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTitle = titles[indexPath.row]
        let previewVC = TitlePreviewViewController()
        previewVC.currentTitle = selectedTitle
        navigationController?.pushViewController(previewVC, animated: true)
    }
}
