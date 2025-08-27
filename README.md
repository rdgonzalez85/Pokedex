# Pokedex iOS App

A SwiftUI-based iOS application that displays a list of Pokemon and their details using the PokeAPI. The app demonstrates modern iOS development practices with clean architecture, async/await networking, and comprehensive testing.

## Features

- Browse a list of Pokemon from the PokeAPI
- View detailed information for each Pokemon including name, height, and image
- Full accessibility support
- Comprehensive unit and UI tests

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture with protocol-oriented design for testability.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rdgonzalez85/pokedex.git
   ```
2. Open `Pokedex.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

The app will automatically fetch Pokemon data from the PokeAPI on launch.

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.5+

## Dependencies

The project uses only system frameworks:
- SwiftUI for UI
- Foundation for networking and data handling
- XCTest for testing
- Combine for reactive programming

## Project Structure

### Core Components

**Views** - SwiftUI views for the user interface
- `PokemonListView`: Displays the list of Pokemon
- `PokemonDetailView`: Shows detailed Pokemon information
- `PokemonRowView`: Individual row component for the list

**ViewModels** - Handle business logic and state management
- `PokemonListViewModel`: Manages Pokemon list state
- `PokemonDetailViewModel`: Manages Pokemon detail state

**Models** - Data structures
- `PokemonListResponse`: API response for Pokemon list
- `PokemonDetail`: Detailed Pokemon information
- `Pokemon`: UI-friendly Pokemon model
- `NamedAPIResource`: Generic API resource reference

**Networking** - API communication layer
- `APIService`: Main service for API requests
- `APIServiceProtocol`: Protocol for dependency injection
- `Request`: Generic request configuration

**Constants** - UI configuration
- `PokemonListViewConstants`: List view styling constants
- `PokemonDetailViewConstants`: Detail view styling constants
- `APIConstants`: Network configuration

**Accessibility** - Identifier management
- `PokemonListAccessibilityIdentifiers`: List view accessibility IDs
- `PokemonDetailAccessibilityIdentifiers`: Detail view accessibility IDs

### Testing Infrastructure

**Unit Tests** - Comprehensive testing of ViewModels and API layer
- `PokemonListViewModelTests`: List functionality tests
- `PokemonDetailViewModelTests`: Detail functionality tests
- `APIServiceTests`: Network layer tests

**UI Tests** - End-to-end user journey testing
- `PokemonMainFlowUITests`: Complete app flow validation

**Test Support** - Mock objects and test utilities
- `MockAPIService`: API service mock for unit testing
- `MockURLSession`: URLSession mock for network testing
- `TestDataFactory`: Test data generation utilities

## API Integration

The app integrates with the [PokeAPI](https://pokeapi.co/) to fetch Pokemon data:

- **List Endpoint**: `https://pokeapi.co/api/v2/pokemon`
- **Detail Endpoint**: `https://pokeapi.co/api/v2/pokemon/{name}`

The networking layer features:
- Protocol-oriented design for testability
- Async/await for modern concurrency
- Generic request handling
- Comprehensive error handling

## Running Tests

```bash
# Run all tests
⌘ + U
```

## Error Handling

The app includes robust error handling:
- Network connectivity issues
- API response parsing errors
- Loading states with retry functionality
- User-friendly error messages

## Accessibility

Full accessibility support includes:
- VoiceOver compatibility
- Semantic accessibility labels
- Structured accessibility identifiers
- Comprehensive accessibility hints

## Code Organization Principles

The codebase follows these principles:
- Protocol-oriented design for testability
- Separation of concerns with clear layer boundaries
- Consistent naming conventions
- Constants extraction for maintainability
- Comprehensive documentation and testing

## TODO
- Pagination support
- Caching results
- Image caching
