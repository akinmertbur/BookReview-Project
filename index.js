"use strict";
import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import dotenv from "dotenv";
dotenv.config();

const app = express();
const port = 3000;

// Establish a connection to the database.
const db = new pg.Client({
  user: process.env.user,
  host: process.env.host,
  database: process.env.database,
  password: process.env.password,
  port: process.env.port,
});
// Connect to the database.
db.connect();

// Middleware for parsing URL-encoded bodies and extended options.
app.use(bodyParser.urlencoded({ extended: true }));
// Middleware to serve static files from the "public" directory.
app.use(express.static("public"));

// Initialize an empty array to store books.
let books = [];

// Function to fetch books based on sorting criteria.
async function getBooks(sort) {
  try {
    let result;
    // Check if there is a sorting parameter provided.
    if (sort) {
      // Determine the sorting criteria.
      if (sort === "rating") {
        // Sort by rating in descending order.
        result = await db.query(
          "SELECT book.id, book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id ORDER BY review.recommendation_score DESC;"
        );
      } else if (sort === "date") {
        // Sort by date read in descending order.
        result = await db.query(
          "SELECT book.id, book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id ORDER BY review.date_read DESC;"
        );
      } else {
        // Sort by title in ascending order.
        result = await db.query(
          "SELECT book.id, book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id ORDER BY book.title ASC;"
        );
      }
    } else {
      // If no sorting parameter is provided, fetch all books.
      result = await db.query(
        "SELECT book.id, book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id"
      );
    }
    return result;
  } catch (error) {
    console.error("Error fetching items from database:", error);
    // Optionally, handle the error by retrying the operation or returning a default value.
    return [];
  }
}

// Function to get the ID of a book based on its title.
async function getBookId(title) {
  try {
    const result = await db.query("SELECT id FROM book WHERE title=$1", [
      title,
    ]);
    // Return the ID of the book.
    return result.rows[0].id;
  } catch (error) {
    // Log the error if any occurred.
    console.error("Error fetching item from database:", error);
    // Optionally, handle the error by retrying the operation or notifying the user.
    return null;
  }
}

// Function to add a new book along with its review to the database.
async function addBook(
  title,
  author,
  review,
  notes,
  recommendation_score,
  key_value
) {
  try {
    // Insert the book details into the 'book' table.
    await db.query(
      "INSERT INTO book (title,key_value,author) VALUES ($1,$2,$3);",
      [title, key_value, author]
    );

    // Get the ID of the newly added book.
    const book_id = await getBookId(title);

    // Insert the review details into the 'review' table.
    await db.query(
      "INSERT INTO review (book_id,review,notes,date_read,recommendation_score) VALUES ($1,$2,$3,$4,$5)",
      [book_id, review, notes, new Date(), recommendation_score]
    );
  } catch (error) {
    // Log the error if any occurred.
    console.error("Error adding item to database:", error);
    // Optionally, handle the error by retrying the operation or notifying the user.
    return null;
  }
}

// Route for the homepage.
app.get("/", async (req, res) => {
  // Call the getBooks function to fetch books based on sorting criteria.
  const result = await getBooks(req.query.sort);

  // Extract the rows from the query result.
  books = result.rows;

  // Render the index page with the list of books.
  res.render("index.ejs", {
    bookList: books,
  });
});

// Route to handle showing review details for a specific book using Path Parameters.
app.get("/details/:id", async (req, res) => {
  // Extract the book ID from the request parameters.
  const book_id = req.params.id;

  // Query the database to fetch review details for the specified book ID.
  const result = await db.query(
    "SELECT book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id WHERE book.id = ($1)",
    [book_id]
  );

  // Extract the review details from the query result.
  const review_details = result.rows[0];

  // Render the details page with the review details.
  res.render("details.ejs", {
    details: review_details,
  });
});

// using Query Parameters.
/*
app.get("/details", async (req, res) => {
  const id = req.query.id;
  console.log(id);
  res.redirect("/");
});
*/

// Route to render the page for adding a new book.
app.get("/addBookPage", async (req, res) => {
  res.render("new_book.ejs");
});

// Route to handle the POST request for adding a new book.
app.post("/addBook", async (req, res) => {
  // Extract data from the request body.
  const title = req.body.title;
  const author = req.body.author;
  const review = req.body.review;
  const notes = req.body.notes;
  const recommendation_score = req.body.recommendation_score;
  const key_value = req.body.key_value;

  // Add the new book and its review to the database.
  await addBook(title, author, review, notes, recommendation_score, key_value);

  // Redirect the user to the homepage after adding the book.
  res.redirect("/");
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
