//
//  Collections+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/22.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
