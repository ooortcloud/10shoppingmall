package com.model2.mvc.web.user;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.model2.mvc.common.Message;
import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.user.UserService;


//==> 회원관리 RestController
@RestController  // default Content-Type :: application/json
@RequestMapping("/rest/user/*")  // DispatcherServlet에서 설정한 LogonCheckIntercepter를 피하기 위함
public class UserRestController {
	
	///Field
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	//setter Method 구현 않음... spring container로부터 auto DI 받기 때문.
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
		
	public UserRestController(){
		System.out.println(this.getClass());
	}
	
	// 일반 App에게는 UI 전달이 불필요함. 이미 UI를 갖고 있으니까.
	/*
	 *  @ModelAttribute :: HTTP request msg의 header 부분의 query string를 auto parsing :: GET이면 url, POST이면 body
	 *  @RequestBody :: HTTP request msg의 body 부분을 auto parsing (query string은 제외)
	 */
	@PostMapping("/json/addUser")
	public Message addUser(@RequestBody User user) throws Exception {
		
		int result = userService.addUser(user);
		
		// 그냥 String으로 return하면 날라가긴 하는데, 이것의 content-type을 모르겠음.
		if(result == 1) 
			return new Message("성공적으로 회원가입을 완료하였습니다!");
		else
			return new Message("회원가입 실패...");
	}
	
	@RequestMapping( value="json/getUser/{userId}", method=RequestMethod.GET )
	public User getUser( @PathVariable String userId ) throws Exception{
		
		System.out.println("/user/json/getUser : GET");
		
		//Business Logic
		return userService.getUser(userId);
	}
	
	// GET과 POST를 구분해야 적절한 auto binder를 사용할 수 있다...
	// Map으로 return하면 그것대로 알아서 inner JSON 형성해서 key-value 형태로 generate해줌
	@GetMapping("/json/listUser")
	public Map<String, Object> getListUser() throws Exception {
		
		// GET을 사용하는 유일한 경우는 left.jsp를 통해 첫 페이지로 들어올 때 뿐... 나머지는 모두 POST임
		Search search = new Search();
		search.setCurrentPage(1);
		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=userService.getUserList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		Map<String, Object> jsonMap = new HashMap<>();
		jsonMap.put("list", map.get("list"));
		jsonMap.put("resultPage", resultPage);
		jsonMap.put("search", search);
		// jsonMap.put("title", "user");
		
		return jsonMap;
	}
	
	@PostMapping("/json/listUser")
	public Map<String, Object> postListUser(@RequestBody Search search) throws Exception {

		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=userService.getUserList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		Map<String, Object> jsonMap = new HashMap<>();
		jsonMap.put("list", map.get("list"));
		jsonMap.put("resultPage", resultPage);
		jsonMap.put("search", search);
		// jsonMap.put("title", "user");
		
		return jsonMap;
	}
	
	@PostMapping("/json/updateUser")
	public Message updateUser(@RequestBody User user, HttpSession session) throws Exception {
		//Business Logic
		int result = userService.updateUser(user);
		Message returnMsg = new Message();
		if(result == 1)
			returnMsg.setMsg("성공적으로 회원 정보가 변경되었습니다!");
		else
			returnMsg.setMsg("회원 정보 변경 실패...");
		
		// 현재 session이 존재하지 않으므로 조회 시 NullPointerException이 뜬다...
//		String sessionId=((User)session.getAttribute("user")).getUserId();
//		if(sessionId.equals(user.getUserId())){
//			session.setAttribute("user", user);
//		}
		
		// 생각해보니 view를 보낼 필요가 없구나? 그냥 data만 보내면 끝이니 redirect할 필요가 없네 ㅇㅇ.
		// @RestController에서는 template를 사용하지 않으므로 "redirect:" 형식으로 navigation 처리가 불가능하다...
		return returnMsg;
//		return ResponseEntity.ok().location( UriComponentsBuilder
//																			.fromPath("/rest/user/json/getUser/" + user.getUserId() )
//																			.build().toUri() ).body(returnMsg);
//		response.sendRedirect("/rest/user/json/getUser/" + user.getUserId() );
		/*
		 *  @RestController에서 navigation하는 방법
		 *  1. @Controller로 변환시키고, REST API가 필요한 method에 대해서만 @ResponseBody 적용
		 *  2. HttpServletResponse를 DI받고 response.sendRedirect() 사용
		 *  3. ResponseEntity의 location 사용하며 return
		 */
	}
	
	@GetMapping("/json/checkDuplication/{userId}")
	public Map<String, Object> checkDuplication(@PathVariable String userId) throws Exception {
		boolean result=userService.checkDuplication(userId);

		Map<String, Object> jsonMap = new HashMap<>();
		jsonMap.put("result", new Boolean(result));
		jsonMap.put("userId", userId);
		
		return jsonMap;
	}

	// @RequestBody :: HTTP request msg의 Body 부분에 있는 data를 Content-Type에 맞게 parsing하여 domain 객체에 auto binding
	@RequestMapping( value="json/login", method=RequestMethod.POST )
	public User login(	@RequestBody User user, HttpSession session ) throws Exception{
	
		System.out.println("/user/json/login : POST");
		//Business Logic
		System.out.println("::"+user);
		User dbUser=userService.getUser(user.getUserId());
		
		// session 체크 로직을 interceptor로 옮겨보자...
		if( user.getPassword().equals(dbUser.getPassword())){
			session.setAttribute("user", dbUser);
		}
		
		return dbUser;
	}
	
	@GetMapping("/logout")
	public Message logout(HttpSession session) throws Exception {
		session.invalidate();
		
		return new Message("logout에 성공하였습니다.");
	}
}