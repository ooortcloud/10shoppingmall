package com.model2.mvc.web.product;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.common.util.CommonUtil;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService service;
	
	/// root WebApplicationContext�� ����� properties �� �ε�...
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	public ProductController() {
		// TODO Auto-generated constructor stub
		System.out.println("���� Controller Bean load...");
	}
	
	/*
	 *  @ModelAttribute�� HttpServletRequest�� getParameter()�� Ȱ���Ͽ� auto binding�� ���ִ� annotation�̴�.
	 *  	query parameter?
	 *  	GET :: url ���� query string
	 *  	POST :: body ���� query string  
	 */
	@PostMapping("/addProduct")
	public String addProduct(@ModelAttribute Product  product, Model model) throws Exception {
		String[] temp = product.getManuDate().split("-");
		product.setManuDate(temp[0] + temp[1] + temp[2]);  // manufacture_day �Է� ���(custom) :: yyyymmdd
		service.addProduct(product);
		model.addAttribute("product", product);
		return "forward:/product/addProduct.jsp";
	}
	
	@GetMapping("/addProduct")
	public String addProduct(Model model) {
		return "forward:/product/addProductView.jsp";
	}
	
	// HandlerAdapter���� proxy��ü ���·� HttpServletRequest�� HttpServletResponse ��ü�� �Ѱ���
	@GetMapping("/getProduct")
	public String getProduct(@RequestParam Integer prodNo, @RequestParam String menu, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Product product = service.getProduct(prodNo);
		model.addAttribute("product", product);

		System.out.println("client���� cookie(history, ��ǰ��.��ǰ��ȣ)�� �����մϴ�.");
		
		/// history ��� ����
		Cookie[] cookies = request.getCookies();
		boolean flag = true;  // �ߺ� üũ
		boolean first = true; // �ߺ� üũ �������� ù��° ��� ���� ó��
		String historyCookie = "";  // historyNo ��ȸ ���� history�� �������� �ȵǴϱ� ������ ���� ����
		String historyNo = "";  // ��ǰID�� ���
		String histories = "";  // ��ǰID�� ��ǰ�� �Բ� ���  << ��ǰ���� ������ ��ǰ�� ���� �ߺ� �˻縦 �ϱ� ����
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals("historyNo")) {
				first=false;
				String[] searchArr = cookie.getValue().split("-");
				// prodNo �ߺ� �˻�  -- ���� �̸��̾ prodNo�� �ٸ��� ���� �ٸ��ϱ� ��ȣ�� ��
				for (String searchItemNo : searchArr) {
					if(searchItemNo.equals(String.valueOf(prodNo))) {
						flag=false;
						break;
					}
				}
				// �ߺ� ���� ��� history�� �߰�
				if(flag) {
					// �Ϻ� Ư�� ���ڸ� ��Ű�� ����� �� �ֽ��ϴ�. ���� ��� ������(-), ������ھ�(_), ��ħǥ(.) ���� �ֽ��ϴ�.
					// ��ǰ��.��ǰ��ȣ-��ǰ��.��ǰ��ȣ ~~~
					historyNo = cookie.getValue()+"-" + String.valueOf(prodNo);
					Cookie historyNoCookie = new Cookie("historyNo", historyNo);
					historyNoCookie.setPath("/");
					response.addCookie( historyNoCookie );
					System.out.println("����� historyNo : "+historyNo);
				} else {
					System.out.println("�̹� �˻��� ��ǰ�Դϴ�.");
				}
			} else if (cookie.getName().equals("histories")) {
				historyCookie = cookie.getValue();
				System.out.println("historyCookie = " + historyCookie);
			}
		}
		
		// cookie�� ������ ���� �� �����Ƿ�, ������ ���͸��ؼ� �۾��ϱ�
		String[] temp = product.getProdName().trim().split(" ");
		String prodName = "";
		for (String t : temp)
			prodName += (t + "_");
		if(flag & !first) {  // �ݺ��� �ۿ��� �ߺ��� �ƴϸ� �߰�����
			String[] searchArr = historyCookie.split("-");
			// �Ϻ� Ư�� ���ڸ� ��Ű�� ����� �� �ֽ��ϴ�. ���� ��� ������(-), ������ھ�(_), ��ħǥ(.) ���� �ֽ��ϴ�.
			histories = historyCookie+"-" + prodName+ "."+ String.valueOf(prodNo);
			Cookie historiesCookie = new Cookie("histories", histories);
			historiesCookie.setPath("/");
			response.addCookie( historiesCookie );
			System.out.println("����� histories : "+ histories );
		}
		
		if(first) {  // ���� ��ȸ�� ��Ű�� ����
			// addCookie�� ���� ������ �⺻ cookie ���� = -1  :: client�� browser ���� �� �ڵ� ����
			histories = prodName + "."+ String.valueOf(prodNo);
			historyNo = String.valueOf(prodNo);
			Cookie historiesCookie =  new Cookie("histories", histories);
			historiesCookie.setPath("/");
			response.addCookie( historiesCookie );					
			Cookie historyNoCookie = new Cookie("historyNo", historyNo);
			historyNoCookie.setPath("/");
			response.addCookie( historyNoCookie );	
			System.out.println("history ��Ű�� ��� ���� �����߽��ϴ�.");
		}

		/// user�� ��ǰ �˻����� navigation ó��
		if(menu.equals("search")) {
		return "forward:/product/getProduct.jsp?menu=search";
		} 
		/// admin�� ��ǰ �������� navigation
		else {  
			return "forward:/product/updateProductView.jsp?&menu=manage";
		}	
	}

	// list������ ��ȸ �� �˻��� ��� ����.
	/*
	 *  @RequestParam :: requestObject���� �ε�
	 *  @ModelAttribute :: requestObject �� QueryString�� ��� �ε�  >> ��, domain ��ü�� Querystring�� �ε� �ȵǴ���.
	 *  		binding :: domain ��ü�� auto binding�� �� ������ ����. (default = true)
	 *  @PathVariable :: ��𿡵� load���� �ʴ´�...
	 */
	@RequestMapping("/listProduct/{menu}")
	public String listProduct(@ModelAttribute(binding=true) Search search, @PathVariable String menu, Model model) throws Exception {
		
		System.out.println("menu ="+menu );
		
		// ���� ���� �� Query Parameter�� currentPage���� null�� �� 1���������� �����ϵ��� ����
		if(search.getCurrentPage() == 0)
			search.setCurrentPage(1);
		// 1������ ���Ŀ��� �˻� �� 1���������� ������ϵ��� ����
		else if( !CommonUtil.null2str(search.getSearchKeyword()).isEmpty() && search.getCurrentPage() != 1 )
			search.setCurrentPage(1);
		search.setPageSize(pageSize);
		Map<String, Object> map = service.getProductList(search);
		
		Page myPage = new Page(search.getCurrentPage(), (Integer) map.get("totalCount"),pageUnit, pageSize);
		
		//  1������ ���Ŀ��� �˻� �� 1���������� ������ϵ��� ����
		if( (search.getCurrentPage() > myPage.getPageUnit() ) && !CommonUtil.null2str(search.getSearchKeyword()).isEmpty() )
			myPage.setBeginUnitPage(1);
		
		model.addAttribute("search", search);  // �˻� ���� ������ ���� requestScope�� ���� �Ѱ���...
		model.addAttribute("list", map.get("list") );
		model.addAttribute("resultPage", myPage);
		model.addAttribute("menu", menu);
		model.addAttribute("title", "product");
		
		// ������ ��忡 ���� ���� Query String�� ����
		if(menu.contains("search"))
			return "forward:/product/listProduct.jsp?menu=search";  
		else
			return "forward:/product/listProduct.jsp?menu=manage";
	}
	
	@GetMapping("/updateProduct")
	public String updateProduct(@RequestParam Integer prodNo, Model model) throws Exception {
		model.addAttribute("product", service.getProduct(prodNo) );
		return "forward:/user/updateProductView.jsp";
	}
	
	@PostMapping("/updateProduct")
	public String updateProduct(@ModelAttribute Product product) throws Exception {
		service.updateProduct(product);
		return "forward:/product/updateProduct.jsp";
	}
	
	@GetMapping("/deleteProduct")
	public String deleteProduct(@RequestBody Integer prodNo) throws Exception {
		service.deleteProduct(prodNo);
		return "forward:/product/listProduct?menu=manage";
	}
	
}
