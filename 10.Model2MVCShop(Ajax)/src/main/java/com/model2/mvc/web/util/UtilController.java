package com.model2.mvc.web.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/util/*")
public class UtilController {

	public UtilController() {
		// TODO Auto-generated constructor stub
	}

	// HandlerAdaptor가 HttpServletRequest랑 HttpServletResponse를 포함한 proxy 객체를 바탕으로 Controller 호출함
	@GetMapping("/history")
	public String history(HttpServletRequest request, Model model) {
		String histories = "";
		String historyNo = "";
		Cookie[] cookies = request.getCookies();

		System.out.println("=================");
		System.out.println("cookie 길이 = "+cookies.length);
		for (Cookie cookie : request.getCookies()) {
			System.out.println(cookie.getName()+" Cookie의 수명 = "+cookie.getMaxAge());
			if(cookie.getName().equals("histories")) {
				histories = cookie.getValue();
				System.out.println("histories = " + histories);
			}
			if(cookie.getName().equals("historyNo")) {
				historyNo = cookie.getValue();
				System.out.println("historyNo = " + historyNo);
			}
		}
		System.out.println("=================");

		model.addAttribute("histories", histories.split("-") );
		model.addAttribute("historyNo", historyNo.split("-") );
		
		return "forward:/history.jsp";
	}
}
