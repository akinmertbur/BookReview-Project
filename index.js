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

// Route to handle showing review details for sp
// using Path Parameters.
app.get("/details/:id", async (req, res) => {
  const book_id = req.params.id;
  const result = await db.query(
    "SELECT book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id WHERE book.id = ($1)",
    [book_id]
  );
  const review_details = result.rows[0];
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

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
