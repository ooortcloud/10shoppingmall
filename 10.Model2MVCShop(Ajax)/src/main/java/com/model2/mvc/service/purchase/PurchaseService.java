package com.model2.mvc.service.purchase;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;


public interface PurchaseService {

	public int addPurchase(Purchase pruchase) throws Exception;
	
	public Purchase getPurchase(int tranNo) throws SQLException, Exception;
	
	public Map<String, Object> getPurchaseList(Map<String, Object> map) throws Exception;
		
	public int updateTranCode(Purchase pruchase) throws SQLException;
	
	public int updatePurchase(Purchase purchase) throws Exception;
	
	public Product getProduct(int prodNo) throws SQLException;
	
	public User getUser(String userId) throws Exception;
}
