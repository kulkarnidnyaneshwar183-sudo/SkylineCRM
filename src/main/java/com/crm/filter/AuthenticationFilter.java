package com.crm.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String loginURI = httpRequest.getContextPath() + "/login";
        String registerURI = httpRequest.getContextPath() + "/register";
        String indexURI = httpRequest.getContextPath() + "/";

        boolean loggedIn = session != null && session.getAttribute("userId") != null;
        boolean loginRequest = httpRequest.getRequestURI().equals(loginURI);
        boolean registerRequest = httpRequest.getRequestURI().equals(registerURI);
        boolean indexRequest = httpRequest.getRequestURI().equals(indexURI);
        
        // Static resources (CSS, JS, images) or login/register pages
        boolean staticResource = httpRequest.getRequestURI().contains("/uploads/") || 
                                 httpRequest.getRequestURI().endsWith(".css") ||
                                 httpRequest.getRequestURI().endsWith(".js");

        if (loggedIn || loginRequest || registerRequest || indexRequest || staticResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {}
}