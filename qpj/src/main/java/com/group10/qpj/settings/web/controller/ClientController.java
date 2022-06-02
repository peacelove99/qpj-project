package com.group10.qpj.settings.web.controller;

import com.group10.qpj.commons.contants.Contants;
import com.group10.qpj.commons.domain.ReturnObject;
import com.group10.qpj.commons.utils.MD5;
import com.group10.qpj.settings.domain.Client;
import com.group10.qpj.settings.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class ClientController {

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

    @RequestMapping("/settings/qx/user/clientLogin.do")
    public @ResponseBody Object clientLogin(String cName, String cPassword, String isRemPwd, HttpSession session, HttpServletRequest request, HttpServletResponse response){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("cName",cName);
        map.put("cPassword",MD5.encrypt(cPassword));

        //调用service层方法，查询用户
        Client client = clientService.selectUserByLoginActAndPwd(map);

        //根据查询结果，生成响应信息
        ReturnObject returnObject = new ReturnObject();
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
                session.setAttribute(Contants.SESSION_Client, client);

                //记住密码
                Cookie c1=new Cookie("cName",client.getcName());
                Cookie c2=new Cookie("cPassword",cPassword);
                if("true".equals(isRemPwd)){
                    //如果需要记住密码，则往外写cookied
                    c1.setMaxAge(10*24*60*60);
                    c2.setMaxAge(10*24*60*60);
                }else{
                    //把没有过期cookie删除
                    c1.setMaxAge(0);
                    c2.setMaxAge(0);
                }
                response.addCookie(c1);
                response.addCookie(c2);
            }
        }
        return returnObject;
    }

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

    @RequestMapping("/settings/qx/user/toRegister.do")
    public String toRegister(){
        //请求转发到注册页面
        return "settings/qx/user/register";
    }

}
