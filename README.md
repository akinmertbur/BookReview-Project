# Book Review Management System

This project is a Book Review Management System built using Node.js and Express. It allows users to add, edit, delete, and view details of books along with their reviews. The system utilizes a PostgreSQL database to store book and review information. Additionally, the application integrates with external APIs to enhance functionality, such as fetching book covers from the Open Library API when adding new books.

## Features

- Add new books along with reviews.
- View details of individual books including their reviews.
- Edit existing book details and reviews.
- Delete books and their associated reviews.
- Sort books based on rating, date read, or title.

## Installation

1. Clone the repository:

   ```bash
   https://github.com/akinmertbur/BookReview-Project.git
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Set up environment variables: Create a `.env` file in the root directory and define the following variables:

   ```bash
   user=<your-database-user>
   host=<your-database-host>
   database=<your-database-name>
   password=<your-database-password>
   port=<your-database-port>
   ```

4. Set up the PostgreSQL database: Create a database in PostgreSQL and execute the SQL commands provided in the `db/mydb.sql` file to create the necessary tables.

5. Start the server:

   ```bash
   npm start
   ```

6. Open your web browser and navigate to `http://localhost:3000` to access the application.

## Usage

### Adding a New Book

* Click on the "Add New Book" button on the homepage.
* Fill in the details of the book including title, author, review, notes, recommendation score, and ISBN (key value).
* Click on the "Submit" button to add the book.

### Viewing Book Details

* Click on the 'My Notes' button for each book on the homepage to view its details.
* The details page includes the book's title, author, review, notes, date read, recommendation score, and cover image.

### Editing Book Details

* Click on the "Edit" button on the details page of the book you want to edit.
* Update the necessary details and click on the "Submit" button to save the changes.

### Deleting a Book

* Click on the "Delete" button on the details page of the book you want to delete.
* Confirm the deletion when prompted.

### Sorting Books

* Use the sorting buttons on the homepage to sort books based on rating, date read, or title.

## Dependencies

* Express.js: Web application framework for Node.js
* Body-parser: Middleware for parsing incoming request bodies
* pg: PostgreSQL client for Node.js
* axios: Promise-based HTTP client for Node.js
* dotenv: Loads environment variables from a .env file

## License
This project is licensed under the `MIT License`.
