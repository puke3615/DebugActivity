package ${packageName};

@DebugActivity.Jump({
<#if addJumpActivity>
    JumpActivity.class,
<#else>

</#if>
})
public class ${activityClass} extends DebugActivity {

<#if addExample>
    private int number = 0;

    public void _无参方法调用() {
    	T("无参方法调用");
    }

    public void _有参方法调用(Button button) {
        button.setText("number is " + number++);
    }

    //代码执行不到,直接弹出toast提示报错
    public void _错误参数调用(String msg) {
        T("test");
    }

    //方法名没有以"_"开头,按钮无法创建成功
    public void 无效调用() {
        T("test");
    }

    //crash会被会被catch住,以toast方式弹出
    public void _Crash测试() {
        int a = 1 / 0;
    }

</#if>

}
