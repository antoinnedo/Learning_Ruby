// === DATA & BOOK CONSTRUCTOR ===

// The main array to store all of our book objects
let myLibrary = [];

// The constructor function for creating book objects
function Book(title, author, pages, read) {
  this.title = title;
  this.author = author;
  this.pages = pages;
  this.read = read;
}

Book.prototype.toggleRead = function() {
  this.read = !this.read;
}

function addBookToLibrary(title, author, pages, read) {
  const newBook = new Book(title, author, pages, read);
  myLibrary.push(newBook);
  renderLibrary(); // Re-display the library with the new book
}

/**
 * Loops through the myLibrary array and displays each book on the page.
 */
function renderLibrary() {
  const libraryContainer = document.getElementById('library-container');
  libraryContainer.innerHTML = ''; // Clear the container before re-rendering

  myLibrary.forEach((book, index) => {
    // Create the book card element
    const bookCard = document.createElement('div');
    bookCard.classList.add('book-card');
    bookCard.setAttribute('data-index', index); // Set a data attribute for the index

    // Create the content for the card
    bookCard.innerHTML = `
      <p><strong>Title:</strong> ${book.title}</p>
      <p><strong>Author:</strong> ${book.author}</p>
      <p><strong>Pages:</strong> ${book.pages}</p>
      <p><strong>Status:</strong> ${book.read ? 'Read' : 'Not Read Yet'}</p>
      <button class="toggle-read-btn">Toggle Read</button>
      <button class="remove-btn">Remove Book</button>
    `;

    // Add the card to the container
    libraryContainer.appendChild(bookCard);
  });
}

// === EVENT LISTENERS ===

// Get references to our HTML elements
const newBookBtn = document.getElementById('new-book-btn');
const formContainer = document.getElementById('new-book-form-container');
const bookForm = document.getElementById('new-book-form');

// Event listener for the "Add New Book" button to show the form
newBookBtn.addEventListener('click', () => {
  formContainer.classList.remove('hidden');
});

// Event listener for the form submission
bookForm.addEventListener('submit', (event) => {
  event.preventDefault(); // Prevent the form from actually submitting

  // Get values from the form
  const title = document.getElementById('title').value;
  const author = document.getElementById('author').value;
  const pages = document.getElementById('pages').value;
  const read = document.getElementById('read').checked;

  console.log("Data from form:", title, author, pages, read);

  addBookToLibrary(title, author, pages, read);

  console.log("Book should be added and rendered now.");
  // Clear the form and hide it
  bookForm.reset();
  formContainer.classList.add('hidden');
});

// Event listener for the entire library container to handle clicks on dynamic buttons
document.getElementById('library-container').addEventListener('click', (event) => {
  // Get the book card and its index
  const card = event.target.closest('.book-card');
  if (!card) return; // Exit if the click was not inside a card

  const bookIndex = parseInt(card.getAttribute('data-index'));
  const book = myLibrary[bookIndex];

  // Handle Remove Button click
  if (event.target.classList.contains('remove-btn')) {
    myLibrary.splice(bookIndex, 1); // Remove book from array
    renderLibrary(); // Re-render the library
  }

  // Handle Toggle Read Button click
  if (event.target.classList.contains('toggle-read-btn')) {
    book.toggleRead(); // Use our prototype method
    renderLibrary(); // Re-render to show the new status
  }
});


// === INITIAL RENDER ===

// Add a few books manually to start so the library isn't empty
addBookToLibrary('The Hobbit', 'J.R.R. Tolkien', 295, true);
addBookToLibrary('A Game of Thrones', 'George R.R. Martin', 694, false);
