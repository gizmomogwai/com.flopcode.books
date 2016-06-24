package com.flopcode.books.android.test;

import com.flopcode.books.IsbnLookup.GoogleBooks;
import com.flopcode.books.IsbnLookup.IsbnDb;
import com.flopcode.books.IsbnLookup;
import com.flopcode.books.models.Book;
import org.junit.Ignore;
import org.junit.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class IsbnLookupTest {

  public static Book[] TEST_BOOKS = {
    new Book("9780201616224", "The pragmatic programmer", "Andrew Hunt, David Thomas"),
    new Book("9780321445612", "The Rails way", "Obie Fernandez"),
    new Book("9780615314464", "xkcd: volume 0", "Randall Munroe, "),
    new Book("9780764567582", "Search engine optimization for dummies", "Peter Kent")
  };

  @Test
  public void testBooksWithIsbnDb() throws Exception {
    withIsbnLookup(IsbnDb.create());
  }

  private void withIsbnLookup(IsbnLookup uut) throws java.io.IOException {
    for (Book b: TEST_BOOKS) {
      Book res = uut.find(b.isbn).execute().body();
      assertThat(res.isbn).isEqualTo(b.isbn);
      assertThat(res.title).isEqualTo(b.title);
      assertThat(res.authors).isEqualTo(b.authors);
    }
  }

  @Ignore
  @Test
  public void testBooksWithGoogleBooks() throws Exception {
    withIsbnLookup(GoogleBooks.create());
  }
}
