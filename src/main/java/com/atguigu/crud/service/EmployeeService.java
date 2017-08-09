package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;

	/**
	 * 查询所有员工
	 * 
	 * @return
	 */
	public List<Employee> getAll() {
		// TODO Auto-generated method stub
		return employeeMapper.selectByExampleWithDept(null);
	}

	/**
	 * 保存
	 * 
	 * @return
	 */
	public void saveEmp(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.insertSelective(employee);
	}

	/**
	 * 用户名校验
	 * 
	 * @return
	 * 
	 */
	public boolean checkUser(String empName) {
		// TODO Auto-generated method stub
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}

	public Employee getEmp(Integer id) {
		// TODO Auto-generated method stub
		Employee emp = employeeMapper.selectByPrimaryKey(id);
		return emp;
	}

	//更新
	public void update(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	
	//删除
	public void deleEmp(Integer id) {
		// TODO Auto-generated method stub
		employeeMapper.deleteByPrimaryKey(id);
	}
	
	//批量删除
	public void deleteBatch(List<Integer> str) {
		// TODO Auto-generated method stub
		EmployeeExample example = new EmployeeExample();
		//生成删除语句
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(str);
		employeeMapper.deleteByExample(example);
	}

}
