//
//  ViewController.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import UIKit

struct NYPost: Codable {
    let id: Int
    let desc: String
    let author: String
    let dateTime: String
    let imagePath: String
    
    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case id
        case desc
        case author
        case dateTime
        case imagePath
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
        return NYRequestData(path: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/"+"\(NYK.Sections.All)"+"/"+"\(NYK.Period.week)"+".json?apikey=sample-key")
    }
}

class ViewController: UIViewController {
    var nyPosts = [NYPost]()
    fileprivate let NYPostCellIndentifier = "NYPostCellReuseIdentifier"
    fileprivate let NYDetailPostSegueIndentifier = "NYDetailPostSegueIndentifier"
    
    @IBOutlet weak var tblNYPosts: UITableView!
    let imageCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var searchNYPostsBar: UISearchBar!
    var filteredNYPosts = [NYPost]()
    
    var selectedPost: NYPost?
    var selectedPostImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblNYPosts.rowHeight = UITableView.automaticDimension
        tblNYPosts.estimatedRowHeight = 90
        //fetchAPI()
        
        // For testing...
        let post1 = NYPost(id: 1,
                           desc: "Its my NY post and first demo for Excercise 1.",
                           author: "Irfan Khatik & Sarah Mahmood",
                           dateTime: "25th Aug 2018",
                           imagePath: "http://www.imageassets.com/image.png")
        
        let post2 = NYPost(id: 1,
                           desc: "Its my NY post and first demo for Excercise 2.",
                           author: "Irfan Khatik & Sarah Mahmood",
                           dateTime: "25th Aug 2018",
                           imagePath: "http://www.imageassets.com/image.png")
        
        nyPosts.append(post1)
        nyPosts.append(post2)
        self.tblNYPosts.reloadData()
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
    // Network Call
    
    func fetchAPI() {
        GetNYPosts().execute(onSuccess: {[weak self] (NYPosts : [NYPost]) in
            if let strongSelf = self {
                strongSelf.imageCache.removeAllObjects()
                strongSelf.tblNYPosts.reloadData()
            }
            print("\(NYPosts)")
            
        }) { (error: Error) in
            //
            print("\(error.localizedDescription)")
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
            return post.desc.lowercased().contains(searchText.lowercased())
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
        
        if let imagePath = selectedPost?.imagePath {
            guard let url = URL(string:imagePath) else {
                self.performSegue(withIdentifier:NYDetailPostSegueIndentifier, sender: self)
                return
            }
            
            if let cachedImage = imageCache.object(forKey: NSString(string: (url.lastPathComponent))) {
                selectedPostImage = cachedImage
            }
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
        
        if post.desc.count > 0 {
            cell.lblDesc.text = post.desc
        }
        
        if post.author.count > 0 {
            cell.lblAuthor.text = post.author
        }
        
        if post.dateTime.count > 0 {
            cell.lblDate.text = post.dateTime
        }
        
        if post.imagePath.count > 0 {
            guard let url = URL(string:post.imagePath) else {
                return cell
            }
            
            if let cachedImage = imageCache.object(forKey: NSString(string: (url.lastPathComponent))) {
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
                            self.imageCache.setObject(image, forKey: NSString(string:(url.lastPathComponent)))
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

