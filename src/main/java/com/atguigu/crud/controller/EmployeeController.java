package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 处理员工CRUD请求
 * 
 * @author lfy
 * 
 */
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 单个删除
	 * 批量删除：1-2-3
	 * 单个删除：1
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmpById(@PathVariable("empId")String ids){
		//批量删除
		if(ids.contains("-")){
			List<Integer> del_ids = new ArrayList<>();
			String[] str = ids.split("-");
			//组装id集合
			for(String a : str){
				del_ids.add(Integer.parseInt(a));
			}
			employeeService.deleteBatch(del_ids);
		}else{
			Integer id = Integer.parseInt(ids);
			employeeService.deleEmp(id);
		}
		
		return Msg.success();
	}

	/**
	 * 员工更新 
	 * 
	 * 如果直接发送ajax=PUT请求
	 * 封装数据
	 * 
	 * 问题：
	 * 请求体有数据，但是Employee中封装不上
	 * 
	 * 原因:
	 * tomcat将请求体中的数据，封装成一个map
	 * request.getparameter("empName")就会从这个map中取值
	 * springMVC封装POJO对象的时候，会把POJO中的每个属性的值，request.getParameter("email")
	 * 
	 * 解决方案：
	 * 1.我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
	 * 2.配置上HttpPutFormContentFilter
	 * 3.他的作用：将请求体中的数据解析包装成一个map
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee){
		employeeService.update(employee);
		return Msg.success();
	}
	
	/**
	 * 根据id查询用户
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("empId")Integer id){
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	/**
	 * 用户名校验
	 */
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkuser(@RequestParam("empName") String empName) {
		// 先判断用户名是否合法表达式
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)";
		if (!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "用户名可以是2-5位中文或者6-16位英文和数字的组合名2");
		}
		;
		// 数据库用户名重复校验
		boolean b = employeeService.checkUser(empName);
		if (b) {
			return Msg.success();
		} else {
			return Msg.fail().add("va_msg", "用户名不可用");
		}
	}

	/**
	 * 员工保存 1.支持JSR303校验 2.导入Hibernate-Validator包
	 * 
	 * @return
	 */
	@RequestMapping(value = "/emp", method = RequestMethod.POST)
	@ResponseBody
	// 封装校验@Valid BindingResult result
	public Msg saveEmp(@Valid Employee employee, BindingResult result) {
		Map<String,Object> map = new HashMap<>();
		if (result.hasErrors()) {
			//校验失败，应该返回失败，在模态框中显示校验失败的错误信息
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors){
				System.out.println("错误的字段名:"+fieldError.getField());
				System.out.println("错误信息:"+fieldError.getDefaultMessage());
				map.put(fieldError.getField(),fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		} else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}

	/**
	 * 导入jsckson包
	 * 
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	// 自动将返回对象转变成json
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 这不是一个分页查询；
		// 引入PageHelper分页插件
		// 在查询之前只需要调用，传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);

		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();

		// 使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
		// 封装了详细的分页信息,包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		// 据用通用性的msg
		return Msg.success().add("pageInfo", page);

	}

	/**
	 * 查询员工数据（分页查询）
	 * 
	 * @return
	 */
	// @RequestMapping("/emps")
	public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {

		// 这不是一个分页查询；
		// 引入PageHelper分页插件
		// 在查询之前只需要调用，传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);

		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();

		// 使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
		// 封装了详细的分页信息,包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		model.addAttribute("pageInfo", page);
		return "list";
	}

}
