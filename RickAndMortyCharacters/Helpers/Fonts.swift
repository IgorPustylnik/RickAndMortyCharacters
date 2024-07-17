//
//  Fonts.swift
//  RickAndMortyCharacters
//
//  Created by Игорь Пустыльник on 17.07.2024.
//

import UIKit

extension UIFont {
    private enum IBMPlexSansTypes {
        static let regular = "IBMPlexSans-Regular"
        static let medium = "IBMPlexSans-Medium"
        static let semiBold = "IBMPlexSans-SemiBold.ttf"
        static let bold = "IBMPlexSans-Bold"
    }
    
    enum IBMPlexSans {
        static func regular(size: CGFloat) -> UIFont {
            guard let font = UIFont(name: IBMPlexSansTypes.regular, size: size) else {
                print("Font \(IBMPlexSansTypes.regular) not found")
                return .systemFont(ofSize: size)
            }
            return font
        }
        
        static func medium(size: CGFloat) -> UIFont {
            guard let font = UIFont(name: IBMPlexSansTypes.medium, size: size) else {
                print("Font \(IBMPlexSansTypes.medium) not found")
                return .systemFont(ofSize: size)
            }
            return font
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            guard let font = UIFont(name: IBMPlexSansTypes.semiBold, size: size) else {
                print("Font \(IBMPlexSansTypes.semiBold) not found")
                return .systemFont(ofSize: size)
            }
            return font
        }
        
        static func bold(size: CGFloat) -> UIFont {
            guard let font = UIFont(name: IBMPlexSansTypes.bold, size: size) else {
                print("Font \(IBMPlexSansTypes.bold) not found")
                return .systemFont(ofSize: size)
            }
            return font
        }
    }
}
