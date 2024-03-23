package com.model2.mvc.service.product.test;

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
import com.model2.mvc.service.product.ProductService;


/*
 *	FileName :  ProductServiceTest.java
 * ㅇ JUnit4 (Test Framework) 과 Spring Framework 통합 Test( Unit Test)
 * ㅇ Spring 은 JUnit 4를 위한 지원 클래스를 통해 스프링 기반 통합 테스트 코드를 작성 할 수 있다.
 * ㅇ @RunWith : Meta-data 를 통한 wiring(생성,DI) 할 객체 구현체 지정
 * ㅇ @ContextConfiguration : Meta-data location 지정
 * ㅇ @Test : 테스트 실행 소스 지정
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:config/context-*.xml" })
public class ProductServiceTest {

	//==>@RunWith,@ContextConfiguration 이용 Wiring, Test 할 instance DI
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public void setProductService(ProductService productService) {
		this.productService = productService;
	}

	// @Test
	public void testAddProduct() throws Exception {
		
		Product product = new Product();
		product.setProdName("test");
		product.setProdDetail("test");
		product.setManuDate("43214321");
		product.setPrice(12345);
		product.setFileName("test");
		// product.setRegDate(null);
		
		productService.addProduct(product);
		
		Product result = productService.getProduct(12345);

		//==> API 확인
		Assert.assertEquals(product.getProdNo(), result.getProdNo());
		Assert.assertEquals(product.getProdName(), result.getProdName());
		Assert.assertEquals(product.getProdDetail(), result.getProdDetail());
		Assert.assertEquals(product.getManuDate(), result.getManuDate());
		Assert.assertEquals(product.getPrice(), result.getPrice());
		Assert.assertEquals(product.getFileName(), result.getFileName());
	}
	
	@Test
	public void testGetProduct() throws Exception {
		Product product = productService.getProduct(10040);
		Assert.assertEquals(Integer.valueOf(10040), product.getProdNo());
	}
	
	// @Test
	public void testGetProductList() throws Exception {

		Search search = new Search();
		search.setCurrentPage(1);
		search.setPageSize(5);
		search.setPriceMin(0);
		search.setPriceMax(2147483647);

		Map<String, Object> resultMap = productService.getProductList(search);
		@SuppressWarnings("unchecked")
		List<Product> list =  (List<Product>)resultMap.get("list");
		Assert.assertEquals(5, list.size());
	}
	
	@Test
	public void testGetProductListByProdName() throws Exception {

		Search search = new Search();
		search.setCurrentPage(1);
		search.setPageSize(5);
		search.setPriceMin(0);
		search.setPriceMax(2147483647);
		String keyword = "update";
		search.setSearchKeyword(keyword);

		Map<String, Object> result = productService.getProductList(search);
		@SuppressWarnings("unchecked")
		List<Product> list =  (List<Product>)result.get("list");
		Assert.assertEquals(1, list.size());
	}
	
	// @Test
	public void testUpdateProduct() throws Exception {
		Product product = new Product();
		product.setProdNo(12345);
		product.setProdName("update");
		product.setProdDetail("test");
		product.setManuDate("12341212");
		product.setPrice(12345);
		product.setFileName("test");
		
		Assert.assertEquals(1, productService.updateProduct(product));
		
		Product updatedProduct = productService.getProduct(12345);
		Assert.assertEquals(product.getProdName(), updatedProduct.getProdName());
	}
}