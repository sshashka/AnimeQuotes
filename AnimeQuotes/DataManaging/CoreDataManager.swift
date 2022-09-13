import Foundation
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    func saveContext(for anime: Model)
}

class CoreDataManager: CoreDataManagerProtocol {
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "AnimeModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func saveContext (for anime: Model) {
        let context = persistentContainer.viewContext
        let model = AnimeModel(context: context)
        model.identifier = UUID()
        model.anime = anime.anime
        model.character = anime.character
        model.quote = anime.quote
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getData() -> [AnimeModel]? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AnimeModel")
        fetch.returnsObjectsAsFaults = false
        guard let data = try? viewContext.fetch(fetch) as? [AnimeModel], !data.isEmpty else { return nil}
        print(data)
        return data
    }
}
