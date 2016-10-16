package ${packageName};

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Toast;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

/**
 * Debug测试类,快速调试Demo工程<hr />
 * 使用姿势:<br />
 * 1. 新建一个子类继承该类<br />
 * 2. 跳转Activity: 在子类配置{@link Jump}注解, 然后在注解中配置跳转Activity的类型<br />
 * 3. 点击按钮触发方法: 在子类声明一个名称以"_"开头的方法(支持任意修饰符),最终生成按钮的文字便是改方法截去"_"<br />
 * 4. 方法参数支持缺省参数和单个参数<br />
 * 5. 如果是单个参数,参数类型必须是Button或Button的父类类型,当方法执行时,该参数会被赋值为该Buttom对象<br />
 * <p>
 *
 * @author zijiao
 * @version 16/10/16
 */
public abstract class DebugActivity extends Activity {

    protected static final String FIXED_PREFIX = "_";
    private final String TAG = getClass().getName();
    private final List<ButtonItem> buttonItems = new ArrayList<>();
    protected LinearLayout linearLayout;
    protected Context context;

    @Target(ElementType.TYPE)
    @Retention(RetentionPolicy.RUNTIME)
    public @interface Jump {
        Class<? extends Activity>[] value() default {};
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.context = this;
        ScrollView scrollView = new ScrollView(this);
        setContentView(scrollView);
        this.linearLayout = new LinearLayout(this);
        this.linearLayout.setOrientation(LinearLayout.VERTICAL);
        scrollView.addView(linearLayout);
        try {
            resolveConfig();
            createButton();
        } catch (Throwable e) {
            error(e.getMessage());
        }
    }

    private void createButton() {
        for (ButtonItem buttonItem : buttonItems) {
            linearLayout.addView(buildButton(buttonItem));
        }
    }

    protected View buildButton(final ButtonItem buttonItem) {
        final Button button = new Button(this);
        button.setText(buttonItem.name);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (buttonItem.target != null) {
                    to(buttonItem.target);
                } else {
                    Method method = buttonItem.method;
                    method.setAccessible(true);
                    Class<?>[] parameterTypes = method.getParameterTypes();
                    int paramSize = parameterTypes.length;
                    switch (paramSize) {
                        case 0:
                            try {
                                method.invoke(DebugActivity.this);
                            } catch (Throwable e) {
                                e.printStackTrace();
                                error(e.getMessage());
                            }
                            break;
                        case 1:
                            if (parameterTypes[0].isAssignableFrom(Button.class)) {
                                try {
                                    method.invoke(DebugActivity.this, button);
                                } catch (Throwable e) {
                                    e.printStackTrace();
                                    error(e.getMessage());
                                }
                                break;
                            }
                        default:
                            error(method.getName() + "方法参数配置错误.");
                            break;
                    }
                }
            }
        });
        return button;
    }

    private void resolveConfig() {
        Class<?> cls = getClass();
        //读取跳转配置
        if (cls.isAnnotationPresent(Jump.class)) {
            Jump annotation = cls.getAnnotation(Jump.class);
            for (Class<? extends Activity> activityClass : annotation.value()) {
                buttonItems.add(buildJumpActivityItem(activityClass));
            }
        }
        //读取方法
        for (Method method : cls.getDeclaredMethods()) {
            handleMethod(method);
        }
    }

    protected void handleMethod(Method method) {
        String methodName = method.getName();
        if (methodName.startsWith(FIXED_PREFIX)) {
            methodName = methodName.replaceFirst(FIXED_PREFIX, "");
            ButtonItem buttonItem = new ButtonItem();
            buttonItem.method = method;
            buttonItem.name = methodName;
            buttonItems.add(buttonItem);
        }
    }

    protected ButtonItem buildJumpActivityItem(Class<? extends Activity> activityClass) {
        ButtonItem buttonItem = new ButtonItem();
        buttonItem.name = "跳转到" + activityClass.getSimpleName();
        buttonItem.target = activityClass;
        return buttonItem;
    }

    public void L(Object s) {
        Log.i(TAG, s + "");
    }

    public void error(String errorMessage) {
        T("[错误信息]\n" + errorMessage);
    }

    public void T(Object message) {
        Toast.makeText(context, String.valueOf(message), Toast.LENGTH_SHORT).show();
    }

    public void to(Class<? extends Activity> target) {
        try {
            startActivity(new Intent(this, target));
        } catch (Exception e) {
            e.printStackTrace();
            error(e.getMessage());
        }
    }

    public void T(String format, Object... values) {
        T(String.format(format, values));
    }

    protected static class ButtonItem {
        public String name;
        public Method method;
        public Class<? extends Activity> target;
    }

}
