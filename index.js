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

// Route for the homepage.
app.get("/", async (req, res) => {
  const result = await db.query("SELECT * FROM book");
  books = result.rows;
  res.render("index.ejs", {
    bookList: books,
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
