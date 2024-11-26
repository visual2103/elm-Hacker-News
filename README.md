# HackerNews Clone in Elm

This project is a **HackerNews clone** built using the **Elm programming language**, showcasing the power of functional programming and the Elm Architecture. It dynamically fetches and displays a list of posts from the HackerNews API, offering various features for customization and interactivity.

## Features

- **Customize the View**
  - Filter posts by type (e.g., job posts, text-only posts).
  - Adjust the number of posts displayed per page.

- **Sort Posts**
  - Sort posts based on criteria such as **score** or **date posted**.

- **Relative Timestamps**
  - Display how long ago each post was submitted in a human-readable format (e.g., "2 days ago").

- **Dynamic Data Loading**
  - Posts are fetched and rendered dynamically.
  - The application gracefully manages loading states.

## Highlights

This project demonstrates:
- **Functional Programming Principles**:
  - Immutability and pure functions.
  - Declarative data transformations using Elm's `List` and `Maybe` utilities.
- **Elm Architecture**:
  - A clean separation of model, view, and update functions.
  - Handling dynamic updates with structured state management.
- **Interactive User Interface**:
  - Simple, intuitive controls for filtering, sorting, and displaying data.

## How to Run

1. Clone the repository :
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the Project Directory:  
  ```bash
    cd Elm-Project
  ```
3. Install Dependencies: npm install :
  ```bash
    npm install
  ```
4. Start the Development Server:
  ```bash
    npm start
  ```
5. View the Application:

  Open <http://localhost:8000> in your browser.


## Project Structure

- **Model**: Defines the data structure and state.
- **Update**: Handles messages and updates the model accordingly.
- **View**: Renders the user interface based on the current model state.

## Technologies Used

- **Elm**: A functional programming language for building front-end applications.
- **HackerNews API**: Provides the data for posts displayed in the application.
- **JavaScript**: For testing and integration.

## Future Improvements

- Add user authentication for personalized views.
- Implement pagination for larger datasets.
- Enhance error handling for API requests.


