//
//  ViewController.swift
//  TXiBPcod
//
//  Created by user on 30.12.2020.
//

import UIKit

protocol PickedValueTransfer: class {
  func pickerDataTransfer(value: String, tag: Int)
}

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate{
  
  private var networkService = NetworkDataFetcher()
  private var category: String = "" {
    didSet {
      changeCategoryOrCountry()
    }
  }
  private var country = "ua" {
    didSet {
      changeCategoryOrCountry()
    }
  }
  private var isLoadingNews = true
  private var totalResults = 0
  private var page = 1
  private var newsArray = [Article]()
  
  private var timer: Timer?
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  let refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    return refreshControl
  }()
  
  @IBOutlet private weak var categoryPickerButton: UIButton!
  @IBOutlet private weak var countryPickerButton: UIButton!
  @IBOutlet private weak var rightBarItem: UIBarButtonItem!
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    getNews()
    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 128
    //tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
  }
  
  private func setupSpinner() {
    view.addSubview(spinner)
    spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
  }
  
  private func getNews() {
    if isLoadingNews == true {
      networkService.fetchNews(country: country, category: category, searchTerm: searchBar.text ?? "", page: page) { [weak self] (newsResponse) in
        guard let fetchedNews = newsResponse else { return }
        self?.newsArray += fetchedNews.articles
        print("Count newsArray = \(String(describing: self?.newsArray.count))")
        print(fetchedNews.articles)
        //self?.tableView.tableFooterView?.isHidden = true
        self?.tableView.reloadData()
        if fetchedNews.articles.count < 20 {
          self?.page = 1
          self?.isLoadingNews = false
          return
        }
        self?.isLoadingNews = true
      }
    }
    //tableView.tableFooterView?.isHidden = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  // UIRefreshControl
  @objc private func refresh(sender: UIRefreshControl){
    isLoadingNews = true
    page = 1
    getNews()
    sender.endRefreshing()
  }
  
  @IBAction func countryButton(_ sender: UIButton) {
    performSegue(withIdentifier: "countryPicker", sender: sender)
  }
  
  func pickerDataTransfer(value: String, tag: Int) {
    switch tag {
    case 0: category = value == "All" ? "" : value
      categoryPickerButton.setTitle("Category: \(value)", for: .normal)
    case 1: country = value
      countryPickerButton.setTitle("Country: \(value)", for: .normal)
    default:
      break
    }
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let detailVC = segue.destination as? NewsVC else { return }
    guard let index = tableView.indexPathForSelectedRow?.row else { return }
    guard let articleUrl = newsArray[index].url else { return }
    detailVC.articleURL = articleUrl
    if segue.identifier == "countryPicker" {
      guard let buttonPressed = sender as? UIButton else { return }
      let tag = buttonPressed.tag
      let popoverViewController = segue.destination as? CountryPickerViewController
      popoverViewController?.modalPresentationStyle = .popover
      popoverViewController?.popoverPresentationController?.delegate = self
      popoverViewController?.popoverPresentationController?.sourceView = buttonPressed
      popoverViewController?.tagButton = tag
      popoverViewController?.delegate = self
    }
  }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    self.spinner.startAnimating()
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
      //            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
      //                guard let fetchedPhotos = searchResults else { return }
      //                self?.spinner.stopAnimating()
      //                self?.photos = fetchedPhotos.results
      //                self?.collectionView.reloadData()
      //                self?.refresh()
      //            }
      self.page = 1
      self.networkService.fetchNews(country: self.country, category: self.category, searchTerm: searchText, page: self.page) { [weak self] (searchResults) in
        guard let fetchedNews = searchResults else { return }
        self?.spinner.stopAnimating()
        self?.newsArray = fetchedNews.articles
        self?.tableView.reloadData()
      }
    })
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell {
      cell.setData(data: newsArray[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (newsArray.count - 1) == indexPath.row {
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(144))
      if isLoadingNews == true {
        page += 1
        getNews()
      }
      //self.tableView.tableFooterView = spinner
      //self.tableView.tableFooterView?.isHidden = false
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ViewController: PickedValueTransfer {
  private func changeCategoryOrCountry() {
    isLoadingNews = true
    page = 1
    newsArray = []
    getNews()
  }
}
