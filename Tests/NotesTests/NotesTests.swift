import XCTest
@testable import notes

final class notesTests: XCTestCase {
    func testPersistence() throws {
        let persistence = Persistence()
//		persistence.noteData?.append(Note(title: "Title", text: [""], date: "date"))
//		try persistence.save()
		print(persistence.noteData[0].text)
    }
}
