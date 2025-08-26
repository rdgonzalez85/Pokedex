import XCTest

final class PokemonMainFlowUITests: XCTestCase {
    var app: XCUIApplication!
    private let listAccessibilityIds = PokemonListAccessibilityIdentifiers()
    private let detailAccessibilityIds = PokemonDetailAccessibilityIdentifiers()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testMainPokemonFlow() throws {
        // Launch the app
        app.launch()
        
        // Wait for the Pokemon list to load
        let pokemonList = app.collectionViews[listAccessibilityIds.pokemonList]
        XCTAssertTrue(pokemonList.waitForExistence(timeout: 10.0), "Pokemon list should appear")
        
        // Verify navigation title
        let navigationTitle = app.navigationBars["Pokémon"]
        XCTAssertTrue(navigationTitle.exists, "Navigation title should be 'Pokémon'")
        
        // Wait for list items to load (there should be at least one)
        let firstCell = pokemonList.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10.0), "At least one Pokemon should be loaded")
                                
        // Get the text of the first cell to verify it later
        let firstCellText = firstCell.staticTexts.firstMatch.label
        XCTAssertFalse(firstCellText.isEmpty, "First cell should have text")
        
        // Tap on the first cell
        firstCell.tap()
        
        // Wait for detail view to appear
        let detailView = app.scrollViews[detailAccessibilityIds.pokemonDetailView]
        XCTAssertTrue(detailView.waitForExistence(timeout: 10.0), "Detail view should appear")
        
        // Verify navigation title changed to the Pokemon name
        let detailNavigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(detailNavigationBar.exists, "Detail navigation bar should exist")
        
        // Wait for Pokemon image to load
        let pokemonImage = app.images[detailAccessibilityIds.pokemonImage]
        XCTAssertTrue(pokemonImage.waitForExistence(timeout: 10.0), "Pokemon image should appear")
        
        // Wait for Pokemon name to appear in detail view
        let pokemonNameText = detailView.staticTexts[detailAccessibilityIds.pokemonName]
        XCTAssertTrue(pokemonNameText.waitForExistence(timeout: 5.0), "Pokemon name should appear")
        
        // Verify the name matches what we selected (accounting for capitalization)
        let displayedName = pokemonNameText.label.lowercased()
        let expectedName = firstCellText.lowercased()
        XCTAssertEqual(displayedName, expectedName, "Detail view should show the selected Pokemon")
        
        // Wait for height information to load
        let pokemonHeight = detailView.staticTexts[detailAccessibilityIds.pokemonHeight]
        XCTAssertTrue(pokemonHeight.waitForExistence(timeout: 5.0), "Pokemon height should appear")
        XCTAssertFalse(pokemonHeight.label.isEmpty, "Height should not be empty")
        
        // Verify back navigation works
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.exists, "Back button should exist")
        
        backButton.tap()
        
        // Verify we're back to the list
        XCTAssertTrue(pokemonList.waitForExistence(timeout: 5.0), "Should return to Pokemon list")
        XCTAssertTrue(navigationTitle.exists, "Should be back to main navigation")
    }
}

struct PokemonListAccessibilityIdentifiers {
    let pokemonList: String
    let loadingIndicator: String
    let retryButton: String
    let pokemonRow: String
    
    init() {
        self.pokemonList = "pokemon_list"
        self.loadingIndicator = "loading_indicator"
        self.retryButton = "retry_button"
        self.pokemonRow = "pokemon_row"
    }
    
    func pokemonRowIdentifier(for name: String) -> String {
        return "\(pokemonRow)_\(name)"
    }
}

struct PokemonDetailAccessibilityIdentifiers {
    let pokemonDetailView: String
    let pokemonImage: String
    let pokemonName: String
    let pokemonHeight: String
    let retryButton: String
    let loadingIndicator: String
    
    init() {
        self.pokemonDetailView = "pokemon_detail_view"
        self.pokemonImage = "pokemon_image"
        self.pokemonName = "pokemon_name"
        self.pokemonHeight = "pokemon_height"
        self.retryButton = "detail_retry_button"
        self.loadingIndicator = "detail_loading_indicator"
    }
}
