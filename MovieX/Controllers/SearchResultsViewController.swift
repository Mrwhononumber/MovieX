//
//  SearchResultsViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/13/22.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    //MARK: - Properties
    
    var titles:[Title] = [Title]()
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/3) - 14 , height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.idintifier)
        return collectionView
    }()

    //MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupSearchResultCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    //MARK: - Helper Functions

    func configureUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
    }
    
    func setupSearchResultCollectionView() {
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.idintifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let title = titles[indexPath.row]
        let titlePoster = title.poster_path ?? ""
        cell.configureImage(with: titlePoster)
        
                return cell
    }
    
    
    
    
    
}
