//
//  ServiceManager.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 06/04/23.
//

//This API class is going to house the Combine code we’re about to write. We’ve already added a cancellables collection to the API. This Set is going to hold onto cancellables; they’re references to subscribers that can be cancelled. They’ll also prevent the deallocation of pending Combine chains.

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

    //Data Task Publisher
//    The first publisher we’re using is URLSession.shared.dataTaskPublisher(for: url). This is essentially a data task from URLSession, which produces a Combine publisher instead of a plain data task object. It takes a URL as input, and returns a publisher. Once this publisher is connected to a subscriber, it’ll make a HTTP networking request and passes the response to the next operator in the chain.

    
    //Working with map()
    //In the above code, we’re transforming the data emitted by the DataTaskPublisher – a tuple of Data and URLResponse – to a Publisher.Map publisher that emits Data values.
    
    //Working with decode()
    //The next operator looks surprisingly familiar if you’ve worked with Codable before. This one:
    
//        .decode(type: [UserModel].self, decoder: JSONDecoder())
//
//        Just like the decode(_:from:) function on Codable’s JSONDecoder, the decode(type:decoder:) operator will transform JSON to native Swift objects. You provide the type of the objects you want to decode, and a decoder, and Combine takes care of the rest.


    //Working with replaceError()
//    The replaceError(with:) operator will replace errors from upstream with something else downstream. Like its name implies, we’re “hiding” errors by replacing them with another value. In this case, when errors occur, they’ll get replaced by an empty array of UserModel objects.
    
    //Working with eraseToAnyPublisher()
//    In Combine, as you chain Publishers to Operators, the return type becomes complicated very quickly since it includes specific detail about each publisher in the chain.

  //  For example a simple string Publisher with a filter and map Operator attached will have a return type of: <Filter<Map<Published<String, Error>>>>
    
    //eraseToAny uses a type eraser pattern to capture what's actually important about the return type. In the example given, adding an eraseToAnyPublisher will shorten the type to a more succinct <AnyPublisher<String, Error>>


enum APIFailureCondition: Error {
    case invalidServerResponse
}

struct Response<T> {
    
    let value: T
    let response: URLResponse
}

let APIManager = ServiceManager.shared

class ServiceManager {
    
    static let shared = ServiceManager()
    var cancellables = Set<AnyCancellable>()
    var posts = [UserModel]()
    
    
    //below is the example of non-generic
    
//    func getUserData(url: URL) -> AnyPublisher<[UserModel],Error> {
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap{ (data, response) -> Data in
//                guard let response = response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .decode(type: [UserModel].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//
//    }
    
    //below is the example of generic api call
    func callApi<T:Decodable>(url: URL, for type: T.Type)->AnyPublisher<T,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data,response) in
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    throw APIFailureCondition.invalidServerResponse
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func callApiUsingFuture<T:Decodable>(url : URL, for type: T.Type)-> Future<T, Error>  {
        return Future<T, Error>{[weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data,response) in
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        throw APIFailureCondition.invalidServerResponse
                    }
                    return data
                }
                .decode(type: type, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
            //this sink is for data task publisher
                .sink (receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                },  receiveValue: { promise(.success($0)) })
                .store(in: &cancellables)
        }
    }
    
    
    
//    func getUserData(url: URL) {
//
//    URLSession.shared.dataTaskPublisher(for: url)
//                    .receive(on: DispatchQueue.main)
//                    .tryMap({ (data, response) -> Data in
//                        guard
//                            let response = response as? HTTPURLResponse,
//                            response.statusCode >= 200 else {
//                            throw URLError(.badServerResponse)
//                        }
//
//                        return data
//                    })
//                    .decode(type: [UserModel].self, decoder: JSONDecoder())
//
//                    .sink(receiveCompletion: {(completion) in
//                        print(completion)
//                    }, receiveValue: {posts in
//                        self.posts = posts
//                    })
//                    .store(in: &cancellables)
//        print(posts)
//                    .flatMap({ (posts) -> AnyPublisher<UserModel, Error> in
//                        //Because we return an array of Post in decode(), we need to convert it into an array of publishers but broadcast as 1 publisher
//                        Publishers.Sequence(sequence: posts).eraseToAnyPublisher()
//                    })
//                    .compactMap({ post in
//                        //Loop over each post and map to a Publisher
//                        self.getComments(post: post)
//                    })
                    //.flatMap {$0} //Receives the first element, ie the Post
                    //.collect() //Consolidates into an array of Posts
//                    .sink(receiveCompletion: { (completion) in
//                        print("Completion:", completion)
//                    }, receiveValue: { (posts) in
//                        self.posts = posts
//                    })
                    //.store(in: &cancellables)
    //}
    
//    func callAPI<T: Decodable>(_ url: URL, for type: T.Type) -> AnyPublisher<Response<T>, Error> {
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { result -> Response<T> in
//
//                guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    print("status code for api response : \((result.response as? HTTPURLResponse)?.statusCode ?? 200)")
//                    throw APIFailureCondition.invalidServerResponse
//                }
//
//                let decoder = JSONDecoder()
//                let value = try decoder.decode(T.self, from: result.data)
//                return Response(value: value, response: result.response)
//        }
//        .receive(on: RunLoop.main)
//        .eraseToAnyPublisher()
//    }
}
