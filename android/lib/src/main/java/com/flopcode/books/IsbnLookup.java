package com.flopcode.books;

import com.flopcode.books.models.Book;
import com.google.common.base.Joiner;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.google.gson.Gson;
import okhttp3.ResponseBody;
import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.core.Persister;
import retrofit2.Call;
import retrofit2.Converter;
import retrofit2.Converter.Factory;
import retrofit2.Retrofit;
import retrofit2.http.GET;
import retrofit2.http.Query;

import java.io.IOException;
import java.io.StringReader;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

import static com.flopcode.books.BooksApi.retrofitWithLogging;

public interface IsbnLookup {
  Call<Book> find(String isbn);

  class IsbnDb {
    public interface LookupService {
      @GET("/api/books.xml?access_key=LYBVW18H&index1=isbn")
      Call<Book> find(@Query("value1") String isbn);
    }

    public static IsbnLookup create() {
      Retrofit rf = retrofitWithLogging(null)
        .baseUrl("http://isbndb.com")
        .addConverterFactory(isbndbFactory())
        .build();

      final LookupService service = rf.create(LookupService.class);
      return new IsbnLookup() {
        @Override
        public Call<Book> find(String isbn) {
          return service.find(isbn);
        }
      };
    }


    private static Factory isbndbFactory() {
      return new Factory() {
        @Override
        public Converter<ResponseBody, Book> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
          return isbndbConverter();
        }
      };
    }

    static class ISBNdb {
      @Element(name = "BookList")
      BookList bookList;
    }

    static class BookList {
      @Element(name = "BookData")
      BookData bookData;
    }

    static class BookData {
      @Attribute
      String isbn13;
      @Element(name = "Title")
      String title;
      @Element(name = "AuthorsText")
      String authors;
    }


    private static Converter<ResponseBody, Book> isbndbConverter() {
      return new Converter<ResponseBody, Book>() {
        @Override
        public Book convert(ResponseBody value) throws IOException {
          Serializer s = new Persister();
          try {
            ISBNdb isbnDb = s.read(ISBNdb.class, value.string(), false);
            final BookData bookData = isbnDb.bookList.bookData;
            System.out.println("isbnDbBook = " + bookData.title);
            System.out.println("isbnDbBook = " + bookData.authors);
            System.out.println("isbnDbBook = " + bookData.isbn13);
            return new Book(bookData.isbn13, bookData.title, bookData.authors);
          } catch (Exception e) {
            throw new IOException(e);
          }
        }
      };
    }

  }

  class GoogleBooks {

    public interface LookupService {
      @GET("books/v1/volumes")
      Call<Book> find(@Query("q") String isbn);
    }

    public static IsbnLookup create() {
      final Retrofit rf = retrofitWithLogging(null)
        .baseUrl("https://www.googleapis.com")
        .addConverterFactory(googleJsonFactory())
        .build();

      final LookupService service = rf.create(LookupService.class);
      return new IsbnLookup() {
        @Override
        public Call<Book> find(String isbn) {
          return service.find("isbn: " + isbn);
        }
      };
    }

    static Factory googleJsonFactory() {
      return new Factory() {
        @Override
        public Converter<ResponseBody, Book> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
          return googleJsonConverter();
        }
      };
    }

    static Converter<ResponseBody, Book> googleJsonConverter() {
      return new Converter<ResponseBody, Book>() {
        @Override
        public Book convert(ResponseBody responseBody) throws IOException {
          Map m = new Gson().fromJson(new StringReader(responseBody.string()), Map.class);
          final List items = (List) m.get("items");
          if (!items.isEmpty()) {
            Map firstItem = (Map) items.iterator().next();
            Map volumeInfo = (Map) firstItem.get("volumeInfo");
            String title = (String) volumeInfo.get("title");
            String authors = Joiner.on(", ").join((List) volumeInfo.get("authors"));
            Map isbnMap = (Map) Iterables.find((List) volumeInfo.get("industryIdentifiers"),
              new Predicate() {
                @Override
                public boolean apply(Object o) {
                  Map m = (Map) o;
                  return m.get("type").equals("ISBN_13");
                }
              });
            String isbn = (String) isbnMap.get("identifier");
            return new Book(isbn, title, authors);
          }
          return null;
        }
      };
    }
  }
}
