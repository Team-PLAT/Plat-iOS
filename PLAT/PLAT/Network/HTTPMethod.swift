//
//  HTTPMethod.swift
//  PLAT
//
//  Created by 김민준 on 9/7/24.
//

import Foundation

protocol HTTPMethod {
    func get<T: Decodable>(url: URL) async -> Result<T, Error>
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
    func patch<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
    func delete<T: Decodable>(url: URL) async -> Result<T, Error>
}

//protocol APIMethod {
//    func get<T: Decodable>(url: URL, authToken: String) async -> Result<T, Error>
//    func post<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async -> Result<T, Error>
//    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
//    func patch<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async -> Result<T, Error>
//    func delete<T: Decodable>(url: URL, authToken: String) async -> Result<T, Error>
//}
