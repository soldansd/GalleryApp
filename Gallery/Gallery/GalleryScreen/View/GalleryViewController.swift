//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

protocol GalleryViewProtocol: AnyObject {
    func update()
}

final class GalleryViewController: UIViewController, GalleryViewProtocol, UITableViewDataSource {
    
    let presenter: GalleryPresenterProtocol
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    init(presenter: GalleryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        presenter.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { nil }
    
    func update() {
        tableView.reloadData()
    }
}

extension GalleryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration( )
        config.text = presenter.photos[indexPath.row].userName
        config.secondaryText = presenter.photos[indexPath.row].imageURL
    
        cell.contentConfiguration = config
        
        return cell
    }
}
