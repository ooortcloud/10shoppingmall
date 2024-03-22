package com.model2.mvc.service.purchase.test;

import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.purchase.PurchaseService;



@RunWith(SpringJUnit4ClassRunner.class)  // metatdata를 보고 DI해주는 구현체 선택
@ContextConfiguration(locations = "classpath:config/context-*.xml")  // parsing할 metadata 경로 지정
public class PurchaseServiceTest {
	
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;

	public PurchaseServiceTest() {
		// TODO Auto-generated constructor stub
	}
	
	public void setPurchaseService(PurchaseService purchaseService) {
		this.purchaseService = purchaseService;
	}
	
	// @Test
	public void testAddPurchase() throws Exception {
		Purchase purchase = new Purchase();
		Product product = new Product();
		product.setProdNo(12345);
		purchase.setPurchaseProd(product);
		User user = new User();
		user.setUserId("testUserId");
		purchase.setBuyer(user);
		purchase.setPaymentOption("0");
		purchase.setReceiverName("test");
		purchase.setReceiverPhone("010-1234-1234");
		purchase.setDivyAddr("testtest");
		purchase.setDivyRequest("testtttt");
		purchase.setTranCode("0");
		purchase.setOrderDate(Date.valueOf("2222-12-12"));
		
		Assert.assertEquals(1, purchaseService.addPurchase(purchase));
	}
	
	// @Test
	public void testGetPurchase() throws SQLException, Exception {
		Purchase purchase = purchaseService.getPurchase(55555);
		System.out.println(purchase);
		// Assert.assertEquals(purchase.getOrderDate().toString(), result.getOrderDate().toString());
		Assert.assertEquals(55555, purchase.getTranNo());
	}
	
	// @Test
	public void testGetPurchaseList() throws Exception {
		
		Map<String, Object> map = new HashMap<>();
		map.put("buyerId", "testUserId");
		Search search = new Search();
		search.setCurrentPage(1);
		search.setPageSize(5);
		map.put("search", search);
		map.put("startRowNum", (search.getCurrentPage() - 1)*search.getPageSize() + 1 );
	 	map.put("endRowNum", search.getCurrentPage()*search.getPageSize() );
	 	
	 	Map<String, Object> resultMap = purchaseService.getPurchaseList(map);
		@SuppressWarnings("unchecked")
		List<Purchase> result = (List<Purchase>) resultMap.get("list");
		for(Purchase p : result)
			System.out.println(p);
		
		Assert.assertEquals(1, result.size());
	}
	
	// @Test
	public void testUpdateTranCode() throws Exception {
		// tran_status_code의 초기값은 "0"임.
		Purchase purchase = new Purchase();
		Product product = new Product();
		
		/// prodNo로 수정하는 경우 :: user :: 상품 구매
		product.setProdNo(12345);
		purchase.setPurchaseProd(product);
		purchase.setTranNo(-1);
		purchase.setTranCode("1");
		purchaseService.updateTranCode(purchase);
		// DB로부터 추출된 공백을 중간에 제거하는 것은 비효율적이어서(list에 대해 작업한다고 생각해보라...) 여기서 trim으로 제거하고 비교연산 해야 함
		Assert.assertEquals("1", purchaseService.getPurchase(55555).getTranCode().trim());
		
		/// tranNo로 수정하는 경우 :: admin :: 상품 배송 시작
		product.setProdNo(-1);
		purchase.setPurchaseProd(product);
		purchase.setTranNo(55555);
		purchase.setTranCode("2");
		purchaseService.updateTranCode(purchase);
		Assert.assertEquals("2", purchaseService.getPurchase(55555).getTranCode().trim());
		
	}
}
