# Tractian Challenge

<img src="/docs/preview.gif" width="200px"/>

This project was developed to manage companies, locations, and assets using a Clean Architecture-based approach with Flutter. It emphasizes separation of responsibilities, adhering to SOLID principles, focusing on scalability and testability.

### Architecture

1. Layers

**Presentation (Presenter):** Manages user interaction with Widgets and Controllers that trigger use cases. 
**Domain:** Contains business logic, including Use Cases and Repository interfaces. 
**Data**: Accesses APIs and local database (SQLite) via implemented repositories.

2. Asynchronous Processing

Isolates are used for heavy processing, such as converting API data before storing it in the database, ensuring a responsive interface.

3. State Management

State is manually managed with setState() or ValueNotifier, keeping it simple but ready for scalability with solutions like Bloc or Riverpod, if needed.

4. Database

SQLite is used via the sqflite package, with support for batch processing to handle bulk operations efficiently.

5. Error Handling

Errors are managed using a Resource pattern, encapsulating failures and successes, following a functional approach to ensure predictability.

### Technologies

- Flutter (3.22.3): Framework for building the user interface.
- Sqflite: Library for SQLite database interaction.
- Dio: Library for HTTP requests.
- Isolates: For background processing.
- GetIt: For dependency injection.

### Execution and Configuration

Clone the repository:

`git clone https://github.com/marinagosson/treeview.git`

Install dependencies:

`flutter pub get`

Run the application:

`flutter run`

### Future Improvements

- **State Management:** Could be enhanced by implementing a more robust solution like Riverpod or Bloc, depending on the scalability needs of the project.

- **Testing**: More extensive unit and integration tests can be implemented across all layers.

- **Advanced Caching**: Implement intelligent caching logic to optimize performance, synchronizing data with the API when needed.

- **Theme System:** Implement a dynamic theme system to allow real-time changes to the display mode (light/dark) and brightness adjustment. This would bring more flexibility and customization options for users, enabling them to adjust the app's look according to their preferences.

- **Internationalization (i18n):** Introduce internationalization (i18n) to support multiple languages. Currently, the text is hardcoded and does not support other regions. This improvement would make the app accessible to a global audience, increasing its inclusiveness and expanding its reach.

- **Optimization of the Asset Tree Construction Logic:** Improve the current logic of building the asset and location tree to directly query the database, avoiding loops like for that consume more time and resources. This change would result in better performance when handling large amounts of data, especially when the number of assets and locations is significant.

- **Tree Layout**: Enhance the animation when clicking the tree node.

- **API Gateway:** Adapt it to handle other request methods (e.g., PUT, DELETE, POST) and handle errors in a general manner.
