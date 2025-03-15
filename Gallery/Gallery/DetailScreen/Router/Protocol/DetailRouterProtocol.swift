//
//  DetailRouterProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

protocol DetailRouterProtocol: AnyObject {
    func openDetailScreen(photo: Photo)
    func closeDetailScreen()
}
