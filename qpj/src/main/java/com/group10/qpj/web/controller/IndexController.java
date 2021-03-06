package com.group10.qpj.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Enumeration;

@Controller
public class IndexController {
    /*
        理论上，给Controller方法分配url：http://127.0.0.1:8080/crm/
        为了简便，协议://ip:port/应用名称必须省去，用/代表应用根目录下的/
     */
    @RequestMapping("/")
    public String index(HttpServletRequest request){
        //请求转发
        return "index";
    }
}
