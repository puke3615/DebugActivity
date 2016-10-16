package ${packageName};

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

/**
 * @author zijiao
 * @version 16/10/16
 */
public class JumpActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView text = new TextView(this);
        text.setText("跳转Activity成功");
        setContentView(text);
    }
}
