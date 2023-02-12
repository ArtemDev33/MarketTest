//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

final class QuotesListViewController: UIViewController {
    
    private var segmentControlView: UISegmentedControl!
    private var quotesTableView: UITableView!
    
    private let storageManager: StorageService = DiskStorageManager()
    private let networkManager: NetworkManager = NetworkManager()
    private var market:Market? = nil
    
    var quotes: [Quote] = []
    var favouriteQuotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        storageManager.subscribeForUpdates(observer: self)
        favouriteQuotes = storageManager.quotes
        
        networkManager.fetchQuotes { quotes, error in
            guard let quotes = quotes else { return }
            self.quotes = quotes
            self.updateQuotes()
        }
    }
    
    deinit {
        storageManager.unsubscribeFromUpdates(observer: self)
    }
}

// MARK: - Private

private extension QuotesListViewController {
    
    enum SegmentContent: Int {
        case all
        case favorites
    }
    
    var currentSegmentContent: SegmentContent {
        SegmentContent(rawValue: segmentControlView.selectedSegmentIndex) ?? .all
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        createSegmentControlView()
        createQuotesTableView()
    }
    
    func configureNavigationBar() {
        title = "Quotes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func createSegmentControlView() {
        segmentControlView = UISegmentedControl(items: ["All quotes", "Favourites"])
        
        view.addSubview(segmentControlView)
        
        segmentControlView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            segmentControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            segmentControlView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
        ])
        
        segmentControlView.selectedSegmentIndex = 0
        segmentControlView.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        quotesTableView.reloadData()
    }
    
    func createQuotesTableView() {
        quotesTableView = UITableView(frame: view.frame)
        quotesTableView.backgroundColor = .clear
        quotesTableView.register(QuoteTableViewCell.nib(), forCellReuseIdentifier: QuoteTableViewCell.identifier)
        quotesTableView.estimatedRowHeight = 60
        quotesTableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(quotesTableView)
        
        quotesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quotesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quotesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quotesTableView.topAnchor.constraint(equalTo: segmentControlView.bottomAnchor, constant: 20),
            quotesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
    }
    
    func openDetailsViewController(quote: Quote) {
        let quoteDetailsVC = QuoteDetailsViewController(quote: quote)
        quoteDetailsVC.storageManager = storageManager
        navigationController?.pushViewController(quoteDetailsVC, animated: true)
    }
    
    func updateQuotes() {
        DispatchQueue(label: "utilityQueue.addition", qos: .userInteractive).async {
            let updatedQuotes = self.quotes.map { quote in
                let isFavourite = self.favouriteQuotes.contains(where: { $0.name == quote.name })
                var updatedQuote = quote
                updatedQuote.isFavourite = isFavourite
                return updatedQuote
            }
            
            DispatchQueue.main.async {
                self.quotes = updatedQuotes
                self.quotesTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableView Delegate & Datasource

extension QuotesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSegmentContent {
        case .all: return quotes.count
        case .favorites: return favouriteQuotes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = quotesTableView.dequeueReusableCell(withIdentifier: QuoteTableViewCell.identifier) as? QuoteTableViewCell else {
            fatalError("Unable to dequeue a reusable cell with identifier \"\(QuoteTableViewCell.identifier)\"")
        }
        
        switch currentSegmentContent {
        case .all:
            cell.quote = quotes[indexPath.row]
        case .favorites:
            cell.quote = favouriteQuotes[indexPath.row]
        }
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quote = currentSegmentContent == .all ? quotes[indexPath.row] : favouriteQuotes[indexPath.row]
        openDetailsViewController(quote: quote)
    }
}

// MARK: - StorageManager Observer

extension QuotesListViewController: StorageManagerObserver {
    
    func storageManagerDidUpdate(with newQuotes: [Quote]) {
        favouriteQuotes = storageManager.quotes
        updateQuotes()
    }
    
    func storageManagerDidRemoveQuote(_ quote: Quote?, at indexPath: IndexPath?) {
        favouriteQuotes = storageManager.quotes
        DispatchQueue(label: "utilityQueue.removal", qos: .userInteractive).async {
            guard var updatedQuote = quote,
                  let index = self.quotes.firstIndex(where: { $0.name == updatedQuote.name }) else {
                return
            }
            
            updatedQuote.isFavourite = false
            DispatchQueue.main.async {
                self.quotes[index] = updatedQuote
                self.quotesTableView.reloadData()
            }
        }
    }
}

// MARK: - QuoteTableViewCellDelegate

extension QuotesListViewController: QuoteTableViewCellDelegate {
    
    func quoteCelldidTapLikeButton(_ cell: QuoteTableViewCell, _ quote: Quote) {
        let favouriteStatus = (quote.isFavourite == true)
        
        do {
            if favouriteStatus {
                try storageManager.removeQuote(quote)
            } else {
                try storageManager.addQuote(quote)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
