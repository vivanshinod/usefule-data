AppDelegate

func checkUserDefualt(window: UIWindow?) {
    
    if BaseVC.sharedInstance.isExistUserDefaultKey(DefaultKey.isUserLogedIn.rawValue) {
        
        if currentUserType == .user {
            guard let rootVC = User_STORY_BOARD.instantiateViewController(withIdentifier: "TabbarVC") as? TabbarVC else {
                return
            }
            
            let navigationController = UINavigationController(rootViewController: rootVC)
            navigationController.setNavigationBarHidden(true, animated: false)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    } else {
        
    }
