package com.flopcode.android.books;

import com.google.common.base.Joiner;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.google.gson.Gson;
import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import okhttp3.logging.HttpLoggingInterceptor;
import okhttp3.logging.HttpLoggingInterceptor.Level;
import retrofit2.Call;
import retrofit2.Converter;
import retrofit2.Converter.Factory;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

import java.io.IOException;
import java.io.StringReader;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

public class BooksApi {


  private static final String FLUNDER_HOME = "192.168.1.100";
  private static final String OFFICE = "172.31.2.34";
  private static final String BLACKBOX = "192.168.1.16";
  public static final String BOOKS_SERVER_IP = FLUNDER_HOME;

  interface BooksService {
    @GET("users.json")
    Call<List<Books.User>> listUsers();

    @GET("books/{id}.json")
    Call<Book> book(@Path("id") String id);

    @GET("books.json")
    Call<List<Book>> index();

    @FormUrlEncoded
    @POST("books.json")
    Call<Book> createBook(@Field("book[isbn]") String isbn, @Field("book[title]") String title, @Field("book[authors]") String authors);
  }

  public static BooksService createBooksService() {
    Retrofit rf = retrofitWithLogging()
      .baseUrl("http://" + BOOKS_SERVER_IP + ":3000")
      .addConverterFactory(GsonConverterFactory.create())
      .build();
    return rf.create(BooksService.class);
  }

  private static Retrofit.Builder retrofitWithLogging() {
    HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
    logging.setLevel(Level.BODY);
    OkHttpClient httpClient = new OkHttpClient.Builder()
      .addInterceptor(logging)
      .build();
    return new Retrofit.Builder().client(httpClient);
  }

  public interface IsbnLookupService {
    @GET("books/v1/volumes")
    Call<Book> find(@Query("q") String isbn);
  }

  public static IsbnLookupService createIsbnLookupService() {
    Retrofit rf = retrofitWithLogging()
      .baseUrl("https://www.googleapis.com")
      .addConverterFactory(googleJsonFactory())
      .build();

    return rf.create(IsbnLookupService.class);
  }

  private static Factory googleJsonFactory() {
    return new Factory() {
      @Override
      public Converter<ResponseBody, Book> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
        return googleJsonConverter();
      }
    };
  }

  private static Converter<ResponseBody, Book> googleJsonConverter() {
    return new Converter<ResponseBody, Book>() {
      @Override
      public Book convert(ResponseBody responseBody) throws IOException {
        Map m = new Gson().fromJson(new StringReader(responseBody.string()), Map.class);
        Map firstItem = (Map) ((List) m.get("items")).iterator().next();
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
        return new Book(null, isbn, title, authors);
      }
    };
  }
        /*new Factory() {
        @Override
        public Converter<ResponseBody, ?> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
          return new Converter<ResponseBody, Book>() {
            @Override
            public Book convert(ResponseBody responseBody) throws IOException {
              System.out.println("responseBody.string() = " + responseBody.string());
              Map b = new Gson().fromJson(responseBody.string(), Map.class);
              System.out.println("b.get(\"items\").class = " + b.get("items").getClass());
              return null;
            }
          };
        }
      }*/
  /*
  interface IsbnLookupService {
    @GET("api/books?jscmd=data&format=json")
    Call<Book> find(@Query("bibkeys") String isbn);
  }
*/
/*
  public static IsbnLookupService createIsbnLookupService() {
    Retrofit rf = retrofitWithLogging()
      .baseUrl("https://openlibrary.org")
      .addConverterFactory(new Factory() {
        @Override
        public Converter<ResponseBody, ?> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
          return new Converter<ResponseBody, Book>() {
            @Override
            public Book convert(ResponseBody responseBody) throws IOException {
              Map b = new Gson().fromJson(responseBody.string(), Map.class);
              String isbn = ((String) b.keySet().iterator().next()).split(":")[1];
              Map book = (Map) b.values().iterator().next();
              String title = (String) book.get("title");
              String authors = Joiner.on(", ").join(Collections2.transform((List) book.get("authors"), new Function<Map, String>() {
                @Override
                public String apply(Map map) {
                  return (String) map.get("name");
                }
              }));
              return new Book(null, isbn, authors, title);
            }
          };
        }
      })
      .build();
    return rf.create(IsbnLookupService.class);
  }
*/
}
