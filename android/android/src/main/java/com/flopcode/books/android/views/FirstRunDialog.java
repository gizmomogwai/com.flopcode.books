package com.flopcode.books.android.views;

import android.app.Activity;
import android.os.Bundle;
import android.widget.EditText;
import butterknife.Bind;
import butterknife.OnClick;
import com.flopcode.books.android.BooksApplication;
import com.flopcode.books.android.R;

import static butterknife.ButterKnife.bind;

public class FirstRunDialog extends Activity {
  @Bind(R.id.user_account)
  EditText userAccount;

  @Bind(R.id.books_server)
  EditText booksServer;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.first_run_dialog);
    bind(this);
  }

  @OnClick(R.id.startUseButton)
  public void startUse() {
    BooksApplication.storeUserAccount(FirstRunDialog.this, userAccount.getText().toString());
    BooksApplication.storeBooksServer(FirstRunDialog.this, booksServer.getText().toString());
    finish();
  }

}
