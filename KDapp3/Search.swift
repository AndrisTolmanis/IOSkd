import UIKit
import SwiftyJSON
import Firebase

class Search: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tvwList: UITableView!
    @IBOutlet var txtSearchTerm: UITextField!
    @IBOutlet var btnSearch: UIButton!
    var page:Int = 0
    var omdbKey:String = "53399a6f"
    var searchTerm:String = ""
    var jsonData = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvwList.rowHeight = 60
    }
    // React when the search term is changed
    @IBAction func txtSearchChanged(_ sender: Any) {
        page = 0
        btnSearch.setTitle("Search", for: .normal)
    }
    // Execute when the search button is pressed
    @IBAction func btnSearchClick(_ sender: UIButton) {
        self.jsonData.removeAll()
        search()
        sleep(1)
        tvwList.reloadData()
        btnSearch.setTitle("Next page", for: .normal)
    }
    // Get the row count of the table view and show an popup if there are no search results
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Getting row count!")
        if self.jsonData.count == 0 && page > 0{
            self.showToast(message: "Try different search terms")
        }
        return jsonData.count
    }
    // Populate the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Filling the table")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableItemThing", for: indexPath) as! ListCell
        let row = indexPath.row
        let url = jsonData[row]["Poster"] ?? "Movie X"
        let title = jsonData[row]["Title"] ?? "Movie X"
        cell.title = title
        cell.link = url
        cell.decorate()
        return cell
    }
    // Search for the entered term on the OMDB api
    func search(){
        page = page + 1
        if let search = txtSearchTerm.text{
            if search == ""{
                showToast(message: "Please enter a valid search term!")
                return
            }
            searchTerm = search
            searchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: .regularExpression, range: nil)
            print(searchTerm)
        }else{
            return
        }
        let session = URLSession.shared
        let omdbUrl = URL(string:"http://www.omdbapi.com/?apikey=\(omdbKey)&s=\(searchTerm)&page=\(page)")!
        print(omdbUrl)
        let task = session.dataTask(with: omdbUrl, completionHandler: { data, response, error in
            if error != nil{
                self.showToast(message: "Error loading movies")
            }else{
                if let json = try? JSON(data: data!){
                    for (_,subJson):(String, JSON) in json {
                        for (_,subsubJson):(String, JSON) in subJson {
                            self.jsonData.append(["Title": subsubJson["Title"].string!, "Poster": subsubJson["Poster"].string!])
                        }
                    }
                }
            }
        })
        task.resume()
    }
}

class ListCell: UITableViewCell{
    var dbStuff: DatabaseReference!
    let userID = Auth.auth().currentUser!.uid
    @IBOutlet var listImage: UIImageView!
    @IBOutlet var listTitle: UILabel!
    var title:String = "John"
    var link:String = "Johnny"
    @IBAction func btnSaveMovie(_ sender: UIButton) {
        dbStuff = Database.database().reference()
        print("Saving movie")
        dbStuff.child("userData").child(userID).childByAutoId().setValue([ "Title": title, "Poster": link])
    }
    func decorate() {
        self.listTitle.text = title
        listImage.downloaded(from: link)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
