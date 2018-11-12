//
//  ViewController.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import UIKit

struct NYPost: Codable {
    let id: Int?
    let source: String?
    let title: String?
    let abstract: String?
    let byline: String?
    let published_date: String?
    let media: [NYPostMedia]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case title
        case abstract
        case byline
        case published_date
        case media
    }
}

struct NYPostMedia: Codable {
    let type: String?
    let subtype: String?
    let caption: String?
    let copyright: String?
    let metadata: [NYPostMediaMetaData]?
    
    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright, metadata = "media-metadata"
    }
}

struct NYPostMediaMetaData: Codable {
    let url: String?
    let format: String?
    let height: Int?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case url, format, height, width
    }
}

struct NYK {
    struct Sections {
        static let All = "all-sections"
    }
    
    struct Period {
        static let today    = "1"
        static let week     = "7"
        static let month    = "30"
    }
}

struct GetNYPosts: NYRequestType {
    typealias NYResponseType = [NYPost]
    var data: NYRequestData {
        return NYRequestData(path: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/"+"\(NYK.Sections.All)"+"/"+"\(NYK.Period.week)"+".json?apikey=1d9ed0e2b31c4a32b1df123e04791be0")
    }
}

class ViewController: UIViewController {
    var nyPosts = [NYPost]()
    fileprivate let NYPostCellIndentifier = "NYPostCellReuseIdentifier"
    fileprivate let NYDetailPostSegueIndentifier = "NYDetailPostSegueIndentifier"
    
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tblNYPosts: UITableView!
    let imageCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var searchNYPostsBar: UISearchBar!
    var filteredNYPosts = [NYPost]()
    
    var selectedPost: NYPost?
    var selectedPostImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tblNYPosts.addSubview(refreshControl)
        
        tblNYPosts.rowHeight = UITableView.automaticDimension
        tblNYPosts.estimatedRowHeight = 90
        fetchAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = "NY Times Most Popular"
        selectedPost = nil
        selectedPostImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        fetchAPI()
    }
    
    // Network Call
    
    func fetchAPI() {
        GetNYPosts().execute(onSuccess: {[weak self] (NYPosts : [NYPost]) in
            if let strongSelf = self {
                strongSelf.nyPosts = NYPosts
                strongSelf.imageCache.removeAllObjects()
                strongSelf.tblNYPosts.reloadData()
                strongSelf.refreshControl.endRefreshing()
            }
        }) {[weak self] (error: Error) in
            if let strongSelf = self {
                strongSelf.refreshControl.endRefreshing()
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                strongSelf.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Search Methods
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    // MARK: - Private instance methods
    fileprivate func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchNYPostsBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNYPosts = nyPosts.filter({( post : NYPost) -> Bool in
            return (post.title?.lowercased().contains(searchText.lowercased()))!
        })
        tblNYPosts.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if NYDetailPostSegueIndentifier == segue.identifier {
            let destinationVC: DetailTableViewController = segue.destination as! DetailTableViewController
            destinationVC.selectedPost = selectedPost
            destinationVC.selectedPostImage = selectedPostImage
        }
    }
    
    @IBAction func menuOption(_ sender: AnyObject) {
        // TODO: Remain to implement
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFiltering() {
            selectedPost = filteredNYPosts[indexPath.row]
        } else {
            selectedPost = nyPosts[indexPath.row]
        }
        
        guard let id = selectedPost?.id else {
            self.performSegue(withIdentifier:NYDetailPostSegueIndentifier, sender: self)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: String(id))) {
            selectedPostImage = cachedImage
        }
        
        self.performSegue(withIdentifier:NYDetailPostSegueIndentifier, sender: self)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltering() {
            return filteredNYPosts.count
        } else {
            return nyPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NYPostCell = tableView.dequeueReusableCell(withIdentifier: NYPostCellIndentifier) as! NYPostCell
        let post: NYPost
        if self.isFiltering() {
            post = filteredNYPosts[indexPath.row]
        } else {
            post = nyPosts[indexPath.row]
        }
        
        if let title = post.title {
            cell.lblDesc.text = title
        }
        
        if let byline = post.byline {
            cell.lblAuthor.text = byline
        }
        
        if let published_date = post.published_date {
            cell.lblDate.text = published_date
        }
        cell.imgNYPost.image = UIImage()
        if let imagePath = post.media?.first?.metadata?.first?.url {
            guard let url = URL(string:imagePath) else {
                return cell
            }
            
            guard let id = post.id else {
                return cell
            }
            
            if let cachedImage = imageCache.object(forKey: NSString(string: String(id))) {
                cell.imgNYPost.image = cachedImage
            } else {
                // Download image into background thread and set it once downloads completed
                // Store same image in Cache for future use...
                DispatchQueue.global(qos: .background).async {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        let image: UIImage = UIImage(data: imageData)!
                        DispatchQueue.main.async {
                            // This is not a retain cycle, because self doesn't own DispatchQueue.main.
                            // The block does keep self alive until it is executed, though.
                            self.imageCache.setObject(image, forKey: NSString(string:String(id)))
                            cell.imgNYPost.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

