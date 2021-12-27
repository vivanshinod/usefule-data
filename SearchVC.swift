//
//  SearchViewController.swift
//  Spark Bazaar
//
//  Created by Vivan on 18/06/21.
//
import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var sBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    var searchReq = SearchRequest()
    var currentVal = [SearchResponse]()
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isToolbarHidden = true
        searchTable.delegate = self
        searchTable.dataSource = self
        getData()
        setupSearch()
        searchTable.allowsSelection = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

//        self.resultSearchController = ({
//
//        let controller = UISearchController(searchResultsController: nil)
//
//        controller.searchResultsUpdater = self
//
//        controller.dimsBackgroundDuringPresentation = false
//
//        controller.searchBar.sizeToFit()
//
//        self.searchTable.tableHeaderView = controller.searchBar
//
//        return controller
//
//        })()
        self.sBar.endEditing(true)
        self.sBar.showsCancelButton = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        gesture.cancelsTouchesInView = true
//        searchTable.addGestureRecognizer(gesture)
    }
    
    @objc func hideKeyboard(){
        searchTable.endEditing(true)
    }
    
    
    func setupSearch(){
        sBar.delegate = self
        sBar.backgroundColor = .white
        sBar.autocapitalizationType = .none
        sBar.searchTextField.textColor = .black
//        sBar.showsCancelButton = true
//        sBar.showsSearchResultsButton = true
        sBar.endEditing(true)
     //   searchTable.isHidden = true

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        let vc = UIStoryboard(name: "Main", bundle: nil)
//            .instantiateViewController(identifier: "ViewController") as! ViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        sBar.text = ""
        sBar.showsCancelButton = false
        sBar.endEditing(true)
        sBar.resignFirstResponder()
    }
    
    private func getData(){
        var semaphore = DispatchSemaphore (value: 0)
        
        let parameters = "key=start"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://xxxxxxx.in")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do{
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                    print(json)
                    self.searchReq = SearchRequest.init(fromDictionary: json)
                    
                    print(self.searchReq)
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.searchTable.reloadData()
                     
                    }
                    
                    
                }
            }catch let error as NSError {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
              print(String(describing: error))
              semaphore.signal()
              return
            }
            
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }

   
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchReq.allName.count
//        if(self.resultSearchController.isActive){
//            return self.filteredTableData.count
//        } else {
//            return self.searchReq.allName.count
//        }
        
        return currentVal.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell

        cell.lblName.text = currentVal[indexPath.row].name
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
        
//        if(self.resultSearchController.isActive){
//            cell.lblName.text = filteredTableData[indexPath.row].title
//            return cell
//        } else {
//            cell.lblName.text = searchReq.allName[indexPath.row].name
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
//        let rotationAngleRadian = 90.0 * CGFloat(Double.pi/180.0)
//        let rotationTransform =
//            CATransform3DMakeRotation(rotationAngleRadian, 0, 0, 1)
//        cell.layer.transform = rotationTransform
//        UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})
     
        UIView.animate(withDuration: 1.0, animations: {cell.alpha=1})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name2 = currentVal[indexPath.row].name
        let story = UIStoryboard(name: "Main", bundle: nil)
               let vc = story.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
        vc.name = name2 as! String

       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentVal = searchReq.allName
//            searchTable.reloadData()
            return
        }
        currentVal = searchReq.allName.filter({ (animal) -> Bool in
            animal.name.lowercased().contains(searchText.lowercased())
        })
        searchTable.reloadData()
    }
    
}
