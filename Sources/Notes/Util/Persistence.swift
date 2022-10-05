import Foundation

final class Persistence {
	
	private enum Error: Swift.Error {
		case directoryNotFound, jsonDecodingError
	}
	
	var noteData = [Note]()
	
	func checkForDuplicate(_ title: String) -> Bool {
		for note in noteData {
			if note.title == title {
				return true
			}
		}
		return false
	}
	
	func query(_ title: String) -> Note? {
		for note in noteData {
			if note.title == title {
				return note
			}
		}
		return nil
	}
	
	func edit(_ note: Note) {
		for (index, oldNote) in noteData.enumerated() {
			if oldNote.title == note.title {
				noteData[index] = note
				do {
					try save()
				} catch {
					print("Failed to save note")
				}
				return
			}
		}
	}
	
	func create(title: String, text: [String], date: Date) {
		let newNote = Note(title: title, text: text, date: date.description)
		noteData.append(newNote)
		do {
			try save()
			print("Note saved as \"\(title)\"")
		} catch {
			print("Failed to save note")
		}
	}
	
	func delete(_ title: String) {
		for (index, note) in noteData.enumerated() {
			if note.title == title {
				noteData.remove(at: index)
				do {
					try save()
				} catch {
					print("Failed to save note")
				}
				return
			}
		}
		print("Could not find \"\(title)\"")
	}
	
	private func save() throws {
		guard let jsonString = String(data: try JSONEncoder().encode(noteData),
									  encoding: String.Encoding.utf8)
		else {
			throw Error.jsonDecodingError
		}
		
		let documentDirectory = FileManager.default.homeDirectoryForCurrentUser
		let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
		do {
			try jsonString.write(to: pathWithFilename,
								 atomically: true,
								 encoding: .utf8)
		} catch {
			print(error)
		}
		
	}
	
	private func fetchPersistentData() throws -> [Note] {
		
		let documentDirectory: URL = FileManager.default.homeDirectoryForCurrentUser
		
		let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
		
		var decodedData = [Note]()
		
		do {
			
			let data = try Data(contentsOf: pathWithFilename, options: [])
			
			decodedData = try JSONDecoder().decode([Note].self, from: data)
			
		} catch {
			try save()
			noteData = try fetchPersistentData()
		}
		
		return decodedData
		
	}
	
	init() {
		do {
			noteData = try fetchPersistentData()
		} catch {
			print("Error: \(error)")
		}
	}
	
}

