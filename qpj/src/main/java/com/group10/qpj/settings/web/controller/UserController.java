package com.group10.qpj.settings.web.controller;

import com.group10.qpj.commons.contants.Contants;
import com.group10.qpj.commons.domain.ReturnObject;
import com.group10.qpj.commons.utils.MD5;
import com.group10.qpj.commons.utils.UUIDUtils;
import com.group10.qpj.settings.domain.Client;
import com.group10.qpj.settings.service.ClientService;
import com.wf.captcha.GifCaptcha;
import com.wf.captcha.SpecCaptcha;
import com.wf.captcha.base.Captcha;
import com.wf.captcha.utils.CaptchaUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private ClientService clientService;

    /**
     * url要和controller方法处理完请求之后，响应信息返回的页面的资源目录保持一致
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        //请求转发到登录页面
        return "settings/qx/user/login";
    }

    /**
     * 分角色登录
     * @param Name
     * @param Password
     * @param isRemPwd
     * @param role
     * @param session
     * @param response
     * @return
     */
    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String Name, String Password, String isRemPwd, String role,String code,
                                      HttpSession session,HttpServletRequest request, HttpServletResponse response){


        //封装参数
        Map<String,Object> map = new HashMap<>();
        //根据查询结果，生成响应信息
        ReturnObject returnObject = new ReturnObject();        //对比验证码
        // 获取session中的验证码
        String sessionCode = (String) request.getSession().getAttribute("captcha");
        // 判断验证码
        if (code==null || !sessionCode.equals(code.trim().toLowerCase())) {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("验证码不正确");
            return returnObject;
        }
        //分角色登录
        switch (role) {
            case "client":
                //封装参数
                map.put("cName",Name);
                map.put("cPassword",MD5.encrypt(Password));
                Client client = clientService.selectUserByLoginActAndPwd(map);
                if (client == null){
                    //登录失败,用户名或者密码错误
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("用户名或者密码错误");
                }else {
                    //进一步判断账号是否合法
                    if (2 == client.getcRight()){
                        //登录失败,状态被锁定
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("账号被封禁");
                    }else {
                        //登录成功
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                        //把client加入session
                        client.setcRole("client");
                        session.setAttribute(Contants.SESSION_User, client);

                        //记住密码
                        Cookie c1=new Cookie("Name",client.getcName());
                        Cookie c2=new Cookie("Password",Password);
                        Cookie c3=new Cookie("role",role);
                        if("true".equals(isRemPwd)){
                            //如果需要记住密码，则往外写cookied
                            c1.setMaxAge(10*24*60*60);
                            c2.setMaxAge(10*24*60*60);
                            c3.setMaxAge(10*24*60*60);
                        }else{
                            //把没有过期cookie删除
                            c1.setMaxAge(0);
                            c2.setMaxAge(0);
                            c3.setMaxAge(0);
                        }
                        response.addCookie(c1);
                        response.addCookie(c2);
                        response.addCookie(c3);
                    }
                }
            case "driver":
                //xxxxx
            case "admin":
                //xxxxx
        }
        return returnObject;
    }

    /**
     * 登出
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response, HttpSession session){
        //清空cookie
        Cookie c1=new Cookie("cName","1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2=new Cookie("cPassword","1");
        c2.setMaxAge(0);
        response.addCookie(c2);
        //销毁session
        session.invalidate();
        //跳转到首页 重定向
        return "redirect:/";
    }

    /**
     * 跳转到注册界面
     * @return
     */
    @RequestMapping("/settings/qx/user/toRegister.do")
    public String toRegister(){
        //请求转发到注册页面
        return "settings/qx/user/register";
    }

    /**
     * 分角色注册
     * @param name
     * @param pwd
     * @param phone
     * @param email
     * @param role
     * @return
     */
    @RequestMapping("/settings/qx/user/register.do")
    public @ResponseBody Object register(String name, String pwd, String phone, String email, String role){
        ReturnObject returnObject=new ReturnObject();
        switch (role){
            case "client":
                System.out.println("客户注册");
                //封装参数
                Client client = new Client();
                client.setcId(UUIDUtils.getUUID());
                client.setcName(name);
                client.setcPassword(MD5.encrypt(pwd));
                client.setcPhone(phone);
                client.setcEmail(email);
                client.setcRight(0);
                try {
                    //调用service层方法，保存注册的客户信息
                    int ret = clientService.saveRegisterClient(client);

                    if(ret>0){
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                    }else{
                        returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙,请稍后重试....");
                    }
                }catch (Exception e){
                    e.printStackTrace();

                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙,请稍后重试....");
                }
            case "driver":
                //xxxxx
            case "admin":
                //xxxxx
        }

        return returnObject;
    }

    /**
     * 生成验证码
     * 官方文档:https://gitee.com/ele-admin/EasyCaptcha
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/settings/qx/user/captcha.do")
    public void captcha(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 设置请求头为输出图片类型
        response.addHeader("Cache-Control", "no-store, must-revalidate");
        response.addHeader("Expires", "Thu, 01 Jan 1970 00:00:01 GMT");

        // 三个参数分别为宽、高、位数
        SpecCaptcha specCaptcha = new SpecCaptcha(130, 48, 1);
        // 设置字体
        specCaptcha.setFont(new Font("Verdana", Font.PLAIN, 32));  // 有默认字体，可以不用设置
        // 设置类型，纯数字、纯字母、字母数字混合
        specCaptcha.setCharType(Captcha.TYPE_ONLY_NUMBER);

        // 验证码存入session
        request.getSession().setAttribute("captcha", specCaptcha.text().toLowerCase());

        // 输出图片流
        specCaptcha.out(response.getOutputStream());

    }

}
