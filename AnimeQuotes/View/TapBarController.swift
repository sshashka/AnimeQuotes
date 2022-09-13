import UIKit

class TapBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        tabBar.tintColor = .label
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: HomeScreenViewController(), title: "Home", image: UIImage(systemName: "house")!, navTitle: "Home"),
            createNavController(for: Builder().createAllAnimeModule(), title: "Search", image: UIImage(systemName: "magnifyingglass")!, navTitle: "Search"),
            createNavController(for: Builder().createRandomModule(), title: "Random", image: UIImage(systemName: "shuffle")!, navTitle: "Random quotes"),
            //createNavController(for: SettingsViewController(), title: "Settings", image: UIImage(systemName: "gear")!, navTitle: "Settings")
        ]
        
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, navTitle: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.isTranslucent = true
        navController.navigationBar.backgroundColor = .systemGroupedBackground
        rootViewController.navigationItem.title = navTitle
        return navController
    }
}
