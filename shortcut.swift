	// set array 
    var gridResponse = GridRequest()


	// decode JSON File
      do{
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                    print(json)
                    self.gridResponse = GridRequest.init(fromDictionary: json)
                    
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.col2.reloadData()
                    }
                }
            }catch let error as NSError {
                print(error.localizedDescription)
            }






// Below code is use to fetch single detail from JSON

   do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else {return}
                mainOrderID = json["order_uid"] as! String
                raaID = json["raz_order_id"] as! String
                
                startPayment(oid: mainOrderID,razOID: raaID)

           } catch let err as NSError {
               print("JSON Error \(err.localizedDescription)")
           }




         //   below code is use to set imageview 

            let str = "\(gridResponse.list[indexPath.item].image!)"
            let strWithNoSpace = str.replacingOccurrences(of: " ", with: "%20")
            let searchURL : URL = URL(string: strWithNoSpace)!

            cell.imgGrid.sd_setImage(with: searchURL, placeholderImage: UIImage(named: "splash"), options: .lowPriority, context: nil)


            // This is how to declare List

            class AreaRequest: NSObject, NSCoding {
    
    var list : [AreaResponse]!
        var message : String!
        var status : Int!

    override init() {
        list = [AreaResponse]()
    }

        /**
         * Instantiate the instance using the passed dictionary values to set the properties values
         */
        init(fromDictionary dictionary: [String:Any]){
            message = dictionary["message"] as? String
            status = dictionary["status"] as? Int
            list = [AreaResponse]()
            if let listArray = dictionary["list"] as? [[String:Any]]{
                for dic in listArray{
                    let value = AreaResponse(fromDictionary: dic)
                    list.append(value)
                }
            }
        }

        /**
         * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
         */
        func toDictionary() -> [String:Any]
        {
            var dictionary = [String:Any]()
            if message != nil{
                dictionary["message"] = message
            }
            if status != nil{
                dictionary["status"] = status
            }
            if list != nil{
                var dictionaryElements = [[String:Any]]()
                for listElement in list {
                    dictionaryElements.append(listElement.toDictionary())
                }
                dictionary["list"] = dictionaryElements
            }
            return dictionary
        }

        /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
        @objc required init(coder aDecoder: NSCoder)
        {
            list = aDecoder.decodeObject(forKey: "list") as? [AreaResponse]
            message = aDecoder.decodeObject(forKey: "message") as? String
            status = aDecoder.decodeObject(forKey: "status") as? Int
        }

        /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
        @objc func encode(with aCoder: NSCoder)
        {
            if list != nil{
                aCoder.encode(list, forKey: "list")
            }
            if message != nil{
                aCoder.encode(message, forKey: "message")
            }
            if status != nil{
                aCoder.encode(status, forKey: "status")
            }
        }
    
    
}


	//	 Below is method to declare model for list

	import Foundation
class AreaResponse: NSObject, NSCoding {
    
    var area : String!

    override init() {
        
    }

        /**
         * Instantiate the instance using the passed dictionary values to set the properties values
         */
        init(fromDictionary dictionary: [String:Any]){
            area = dictionary["area"] as? String
        }

        /**
         * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
         */
        func toDictionary() -> [String:Any]
        {
            var dictionary = [String:Any]()
            if area != nil{
                dictionary["area"] = area
            }
            return dictionary
        }

        /**
         * NSCoding required initializer.
         * Fills the data from the passed decoder
         */
        @objc required init(coder aDecoder: NSCoder)
        {
            area = aDecoder.decodeObject(forKey: "area") as? String
        }

        /**
         * NSCoding required method.
         * Encodes mode properties into the decoder
         */
        @objc func encode(with aCoder: NSCoder)
        {
            if area != nil{
                aCoder.encode(area, forKey: "area")
            }
        }
}



