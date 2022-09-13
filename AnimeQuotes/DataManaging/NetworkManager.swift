import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getTenRandomQuotes(completition: @escaping([Model]) -> Void)
    func getAllAnimeTitles(completition: @escaping([String]) -> Void)
    func searchAnimeQuotesByTitle(title: String, completition: @escaping([Model]) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func getTenRandomQuotes(completition: @escaping([Model]) -> Void) {
        let stringURL = "https://animechan.vercel.app/api/quotes"
        
        let url = URL(string: stringURL)
        guard let url = url else { return }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) {data, response, error in
            DispatchQueue.global(qos: .background).async {
                guard let data = data else { return }
                
                do {
                    let quote = try JSONDecoder().decode([Model].self, from: data)
                    completition(quote)
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
    }
    
    func getAllAnimeTitles(completition: @escaping([String]) -> Void) {
        let url = URL(string: "https://animechan.vercel.app/api/available/anime")
        
        guard let url = url else { return }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) {data, response, error in
            DispatchQueue.global(qos: .background).async {
                guard let data = data else { return }
                
                do {
                    let anime = try JSONDecoder().decode([String].self, from: data)
                    completition(anime)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func searchAnimeQuotesByTitle(title: String, completition: @escaping([Model]) -> Void) {
        let encodedTitle = title.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://animechan.vercel.app/api/quotes/anime?title=\(encodedTitle.lowercased())")
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, responce, error in
            DispatchQueue.global(qos: .background).async {
                guard let data = data else { return }
                do {
                    let anime = try JSONDecoder().decode([Model].self, from: data)
                    completition(anime)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
