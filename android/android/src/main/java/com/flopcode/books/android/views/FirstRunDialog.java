package com.flopcode.books.android.views;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import butterknife.Bind;
import butterknife.OnClick;
import com.flopcode.books.android.BooksApplication;
import com.flopcode.books.android.R;
import com.flopcode.books.android.views.books.BooksActivity;

import static butterknife.ButterKnife.bind;
import static com.flopcode.books.android.BooksApplication.LOG_TAG;
import static com.flopcode.books.android.BooksApplication.showError;

public class FirstRunDialog extends Activity {
  @Bind(R.id.user_account)
  EditText userAccount;

  @Bind(R.id.books_server)
  EditText booksServer;

  @Bind(R.id.startUseButton)
  Button startUseButton;

  public BooksApplication getBooksApplication() {
    return (BooksApplication) getApplication();
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.first_run_dialog);
    bind(this);
    userAccount.setText(getBooksApplication().getEsrGoogleAccount());
  }

  @OnClick(R.id.startUseButton)
  public void startUse() {
    if (userAccount.getText().toString().isEmpty())
    {
      Log.i(LOG_TAG, "Username is empty");
      getBooksApplication().showStartScreenError(FirstRunDialog.this, "Please enter your username");
      return;
    }
    startUseButton.setActivated(false);
    serverIsAlive();
    // getBooksApplication().checkServerOnFirstStart(FirstRunDialog.this);
  }

  public void serverIsAlive() {
    Log.i(LOG_TAG, "Server is alive, first check passed");
    BooksApplication.storeUserAccount(FirstRunDialog.this, userAccount.getText().toString());
    BooksApplication.storeBooksServer(FirstRunDialog.this, booksServer.getText().toString());
    finish();
  }

  public void serverNotAlive() {
    Log.i(LOG_TAG, "Server is not alive, first check failed");
    startUseButton.setActivated(true);
  }
}
