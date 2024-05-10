"use strict";
import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import axios from "axios";
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
    return null;
  }
}

// Function to fetch details of a book including its reviews.
async function getBookDetails(book_id) {
  try {
    // Query the database to fetch review details for the specified book ID.
    const result = await db.query(
      "SELECT book.title, book.author, book.key_value, review.book_id, review.review, review.notes, review.date_read, review.recommendation_score FROM book INNER JOIN review ON book.id = review.book_id WHERE book.id = ($1)",
      [book_id]
    );

    // Return the details of the book and its reviews.
    return result.rows[0];
  } catch (error) {
    // Log the error if any occurred.
    console.error("Error fetching item from database:", error);
    return null;
  }
}

// Function to update review details of a book in the database.
async function updateBookDetails(review, notes, recommendation_score, book_id) {
  try {
    // Update the review details in the database.
    await db.query(
      "UPDATE review SET review = $1, notes = $2, recommendation_score = $3 WHERE book_id = $4;",
      [review, notes, recommendation_score, book_id]
    );
  } catch (error) {
    // Log the error if any occurred.
    console.error("Error updating item in database:", error);
    return null;
  }
}

// Function to delete a book and its associated reviews from the database.
async function deleteBook(id) {
  try {
    // Delete reviews associated with the book.
    await db.query("DELETE FROM review WHERE book_id = $1", [id]);
    // Delete the book itself.
    await db.query("DELETE FROM book WHERE id = $1", [id]);
  } catch (error) {
    // Log the error if any occurred.
    console.error("Error deleting item from database:", error);
    return null;
  }
}

// Function to fetch cover image for a book using its ISBN.
async function getCover(key_value) {
  try {
    // Fetch cover image for each book using its ISBN.
    const coverResponse = await axios.get(
      `https://covers.openlibrary.org/b/isbn/${key_value}-M.jpg`,
      { responseType: "arraybuffer" }
    );
    // Convert cover image data to base64 format.
    const coverData = Buffer.from(coverResponse.data, "binary").toString(
      "base64"
    );

    return coverData;
  } catch (error) {
    // Log error if fetching cover fails.
    console.error("Failed to fetch cover:", error.message);
    return null;
  }
}

// Function to fetch book covers from Open Library API.
async function getCovers() {
  try {
    // Use map instead of forEach to create an array of promises.
    const coverPromises = books.map(async (book) => {
      // Await the result of getCover inside the map function.
      const coverData = await getCover(book.key_value);
      return coverData;
    });

    // Wait for all promises to resolve.
    const covers = await Promise.all(coverPromises);

    return covers;
  } catch (error) {
    // Log error if fetching covers fails.
    console.error("Failed to make request:", error.message);
    return null;
  }
}

// Function to get the key value (ISBN) of a book by its ID.
async function getKeyValueById(id) {
  try {
    // Query the database to fetch the key value of the book with the given ID.
    const result = await db.query(
      "SELECT key_value FROM book WHERE id = ($1)",
      [id]
    );

    // Return the key value (ISBN) of the book.
    return result.rows[0].key_value;
  } catch (error) {
    // Log the error if any occurred.
    console.error("Error fetching item from database:", error);
    return null;
  }
}

// Route to render the homepage with the list of books and their covers.
app.get("/", async (req, res) => {
  try {
    // Call the getBooks function to fetch books based on sorting criteria.
    const result = await getBooks(req.query.sort);

    // Extract the rows from the query result.
    books = result.rows;

    // Fetch covers for the books.
    const covers = await getCovers();

    // Render the index page with the list of books and their covers.
    res.render("index.ejs", {
      bookList: books,
      covers: covers,
    });
  } catch (error) {
    // Log error and send internal server error response if something goes wrong.
    console.error("Error:", error);
    res.status(500).send("Internal Server Error");
  }
});

// Route to handle showing review details for a specific book using Path Parameters.
app.get("/details/:id", async (req, res) => {
  // Extract the book ID from the request parameters.
  const book_id = req.params.id;

  // Extract the review details for the specified book ID.
  const review_details = await getBookDetails(book_id);

  // Get the key value (ISBN) of the book.
  const key_value = await getKeyValueById(book_id);

  // Fetch cover data for the book.
  const coverData = await getCover(key_value);

  // Render the details page with the review details and cover data.
  res.render("details.ejs", {
    details: review_details,
    coverData: coverData,
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

// Route to render the page for editing book details.
app.get("/editBookPage", async (req, res) => {
  // Extract the book ID from the query parameters.
  const id = req.query.id;

  // Extract the review details for the specified book ID.
  const review_details = await getBookDetails(id);

  // Render the edit book page with the review details.
  res.render("edit_book.ejs", {
    details: review_details,
  });
});

// Route to handle the POST request for updating book details.
app.post("/editBook", async (req, res) => {
  // Extract data from the request body.
  const book_id = req.body.book_id;
  const review = req.body.review;
  const notes = req.body.notes;
  const recommendation_score = req.body.recommendation_score;

  // Update the review details of the book in the database.
  await updateBookDetails(review, notes, recommendation_score, book_id);

  // Redirect the user to the details page of the edited book.
  res.redirect(`/details/${encodeURIComponent(book_id)}`);
});

// Route to handle the POST request for deleting a book.
app.post("/delete", async (req, res) => {
  // Extract the ID of the book to be deleted from the request body.
  const book_id = req.body.delete;

  // Call the deleteBook function to delete the book and its reviews.
  await deleteBook(book_id);

  // Redirect the user to the homepage after deleting the book.
  res.redirect("/");
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
