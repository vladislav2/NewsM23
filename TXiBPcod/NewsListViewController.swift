//
//  NewsListViewController.swift
//  TXiBPcod
//
//  Created by user on 30.12.2020.
//

import UIKit

protocol PickedValueTransfer: class {
  func pickerDataTransfer(value: String, tag: Int)
}

class NewsListViewController: UIViewController, UIPopoverPresentationControllerDelegate{
  
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
  private var isSearching = false
  private var page = 1
  private var newsArray = [Article]()
  
  private var timer: Timer?
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  private let refreshControl: UIRefreshControl = {
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
    searchBar.showsCancelButton = true
    getNews()
    tableView.refreshControl = refreshControl
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 128
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    guard let detailVC = segue.destination as? NewsVC else { return }
    guard let index = tableView.indexPathForSelectedRow?.row else { return }
    guard let articleUrl = newsArray[index].url else { return }
    detailVC.articleURL = articleUrl
  }
  
  // MARK: - @IBActions
  
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
  
  private func setupSpinner() {
    view.addSubview(spinner)
    spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
  }
  
  private func getNews() {
    if isLoadingNews == true {
      self.spinner.startAnimating()
      networkService.fetchNews(country: country, category: category, searchTerm: searchBar.text ?? "", page: page) { [weak self] (newsResponse) in
        guard let fetchedNews = newsResponse else { return }
        self?.newsArray += fetchedNews.articles
        //print("Count newsArray = \(String(describing: self?.newsArray.count))")
        //print(fetchedNews.articles.description)
        self?.spinner.stopAnimating()
        self?.tableView.reloadData()
        if fetchedNews.articles.count < 20{
          self?.page = 1
          self?.isLoadingNews = false
          return
        }
        self?.isLoadingNews = true
      }
    }
  }
  
  private func trottle()  {
      self.page = 1
      self.getNews()
  }
  
  // UIRefreshControl
  @objc private func refresh(sender: UIRefreshControl){
    isLoadingNews = true
    page = 1
    getNews()
    sender.endRefreshing()
  }
}

// MARK: - UISearchBarDelegate

extension NewsListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    newsArray = []
    isLoadingNews = true
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
      self.trottle()
    })
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
    getNews()
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
    isLoadingNews = true
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    isSearching = false
    searchBar.resignFirstResponder()
  }
}

// MARK: - UITableViewDataSource

extension NewsListViewController: UITableViewDataSource {
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

extension NewsListViewController: UITableViewDelegate {
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
    searchBar.resignFirstResponder()
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension NewsListViewController: PickedValueTransfer {
  private func changeCategoryOrCountry() {
    isLoadingNews = true
    page = 1
    newsArray = []
    getNews()
  }
}
