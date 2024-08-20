//
//  NetworkManager.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

protocol APIMethod {
    func get<T: Decodable>(url: URL, authToken: String) async -> Result<T, Error>
    func post<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async -> Result<T, Error>
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error>
    func patch<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async -> Result<T, Error>
    func delete<T: Decodable>(url: URL, authToken: String) async -> Result<T, Error>
}

class NetworkClient: APIMethod {
    
    /// GET (쿼리로 데이터 전달)
    func get<T: Decodable>(url: URL, authToken: String) async -> Result<T, Error> {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.urlError(error as! URLError))
        }
    }
    
    /// POST (Authorization)
    func post<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async -> Result<T, Error> {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.urlError(error as! URLError))
        }
    }
    
    /// POST (login)
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error> {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.urlError(error as! URLError))
        }
    }
    
    /// PATCH
    func patch<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async -> Result<T, Error> {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.urlError(error as! URLError))
        }
    }
    
    /// DELETE
    func delete<T: Decodable>(url: URL, authToken: String) async -> Result<T, Error> {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.urlError(error as! URLError))
        }
    }
}
