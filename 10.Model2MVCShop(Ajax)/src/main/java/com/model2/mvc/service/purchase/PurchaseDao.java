package com.model2.mvc.service.purchase;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;

public interface PurchaseDao {
	
	public int insertPurchase(Purchase purchase) throws Exception;
	
	public Purchase findPurchase(int tranNo) throws Exception;
	
	public Map<String, Object> getPurchaseList(Map<String ,Object> map) throws Exception;

	public int updateTranCode(Purchase purchase) throws SQLException;
	
	public int updatePurchase(Purchase purchase) throws Exception;
	
	public Product getProduct(int prodNo) throws SQLException;
	
	public User getUser(String userId) throws Exception;
}
