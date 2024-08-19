//
//  NetworkManager.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

protocol APIMethod {
    func get<T: Decodable>(url: URL, authToken: String) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
    func patch<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async throws -> T
    func delete<T: Decodable>(url: URL, authToken: String) async throws -> T
}

class NetworkClient: APIMethod {
    
    /// GET (쿼리로 데이터 전달)
    func get<T: Decodable>(url: URL, authToken: String) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("GET 요청 실패: \(response)")
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("GET 요청 오류 발생: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// POST (Authorization)
    func post<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("POST 요청 실패: \(response)")
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("POST 요청 오류 발생: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// POST (login)
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("POST 요청 실패: \(response)")
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("POST 요청 오류 발생: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// PATCH
    func patch<T: Decodable, U: Encodable>(url: URL, body: U, authToken: String) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("PATCH 요청 실패: \(response)")
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("PATCH 요청 오류 발생: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// DELETE
    func delete<T: Decodable>(url: URL, authToken: String) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("DELETE 요청 실패: \(response)")
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("DELETE 요청 오류 발생: \(error.localizedDescription)")
            throw error
        }
    }
}
