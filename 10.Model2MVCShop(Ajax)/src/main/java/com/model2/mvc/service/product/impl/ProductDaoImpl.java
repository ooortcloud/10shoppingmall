package com.model2.mvc.service.product.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductDao;

// annotation 기반 metadata 작성법을 쓰지 않으면, 각각의 도메인에 대한 DI metadata 관리 파일까지 따로 구현해야만 함...
@Repository("productDaoImpl")
public class ProductDaoImpl implements ProductDao {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession; 

	public ProductDaoImpl() {
		// TODO Auto-generated constructor stub
	}

	/*
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	*/

	/*
	 *  순수 JDBC 기반 DAO 개발 로직 복기 ::
	 *  1. Connection Pool로부터 Connection instance 가져옴
	 *  2. sql 문장 정의
	 *  3. connection instance로부터 해당 sql 문장을 갖는 PreparedStatement instance 생성. '?'에 넣을 인자들 setter로 정의
	 *  4.  preparedStatement instance의 execute 관련 메소드를 사용하여 DB에 쿼리 발사
	 *  5. DB의 리턴값을 받아서 처리 (ResultSet의 경우 VO객체에 값들 주입해서 리턴함)
	 */
	public int insertProduct(Product product) throws Exception {
		// Mybatis framework 사용 시 DAO 개발 로직 :: 
		// SqlSession instance의 crud 메소드 호출. 필요에 따라 받아온 값 그대로 리턴. -끝-
		// SqlSession에는 metadata에서 정의한 preparedStatement 기반의 sql 문장들을 전부 로드하고 있기 때문에 이런 플레이가 가능해짐.
		return sqlSession.insert("ProductMapper.addProduct", product);
	}

	public Product findProduct(int prodNo) throws Exception {
		return sqlSession.selectOne("ProductMapper.findProduct", prodNo);
	}

	public List<Product> getProductList(Search search) throws Exception {
		return sqlSession.selectList("ProductMapper.getProductList", search);
	}

	public int updateProduct(Product product) throws Exception {
		return sqlSession.update("ProductMapper.updateProduct", product);
	}

	@Override
	public int getTotalCount(Search search) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("ProductMapper.getTotalCount", search);
	}

	@Override
	public int deleteProduct(Integer prodNo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("ProductMapper.deleteProduct", prodNo);
	}

	@Override
	public List<Product> getProductListAutoComplete(String prodName) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("ProductMapper.getProductListAutoComplete", prodName);
	}
}
