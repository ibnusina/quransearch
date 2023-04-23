//
//  Main.swift
//  QuranSearch
//
//  Created by ibnu on 14/04/23.
//

import UIKit
import SwiftUI

class MainVC: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(Color.primaryBlue)

        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.backgroundColor = UIColor(Color.primaryBlue)
        
        UITabBar.appearance().standardAppearance = tabBarApperance
        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
        self.tabBar.backgroundColor = UIColor(Color.primaryBlue)
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .lightGray
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchVC()
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        
        let bookmarkVC = BookmarkListVC()
        bookmarkVC.view.backgroundColor = .red
        bookmarkVC.tabBarItem.title = "Bookmark"
        bookmarkVC.tabBarItem.image = UIImage(systemName: "bookmark.circle")
        
        self.viewControllers = [searchVC, bookmarkVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
