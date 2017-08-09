<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud
 -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 修改Modal -->
	<div class="modal fade" id="empupdateModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工添加</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								<p class="form-control-static" id="empName_update_static"></p>

							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control"
									id="email_update_input" placeholder="email@atguigu.com">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_update_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_update_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">deptName</label>
							<div class="col-sm-4">
								<!-- 部门提交部门id即可 -->
								<select class="form-control" name="dId" id="dept_add_select">

								</select>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 新增Modal -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工添加</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 control-label">empName</label>
							<div class="col-sm-10">
								<input type="text" name="empName" class="form-control"
									id="empName_add_input" placeholder="empName"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">email</label>
							<div class="col-sm-10">
								<input type="text" name="email" class="form-control"
									id="email_add_input" placeholder="email@atguigu.com"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">gender</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_add_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_add_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">deptName</label>
							<div class="col-sm-4">
								<!-- 部门提交部门id即可 -->
								<select class="form-control" name="dId" id="dept_add_select">

								</select>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th><input type="checkbox" id="check_all" /></th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>

				</table>
			</div>
		</div>

		<!-- 显示分页信息 -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-12 " id="page_info_area"></div>

			<!-- 分页条信息 -->
			<div class="col-md-6 col-md-offset-6" id="page_nav_area"></div>
		</div>

	</div>
	<script type="text/javascript">
		var totalPageNum, currentPage;
		//1.页面加载完成后，直接发送一个ajax请求，要到分页数据
		$(function() {
			to_page(1);
		});

		function to_page(pn) {
			$.ajax({
				url : "${APP_PATH}/emps",
				data : "pn=" + pn,
				type : "get",
				success : function(result) {
					//console.log(result)
					//1.解析并显示json员工数据
					bulid_emps_table(result);
					//2.解析并显示分页信息
					build_page_info(result);

					build_page_nav(result);

				}
			})
		}

		function bulid_emps_table(result) {
			//清空
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;

			$
					.each(
							emps,
							function(index, item) {

								//item就是emps
								var checkBox = $("<td><input type='checkbox' class='check_item'/></td>");
								var empIdTd = $("<td></td>").append(item.empId);
								var empNameTd = $("<td></td>").append(
										item.empName);
								var genderTd = $("<td></td>").append(
										item.gender == "M" ? "男" : "女");
								var emailTd = $("<td></td>").append(item.email);
								var deptNameTd = $("<td></td>").append(
										item.department.deptName);
								var editBtn = $("<button></button>")
										.addClass(
												"btn btn-primary btn-sm edit_btn ")
										.append(
												$("<span></span>")
														.addClass(
																"glyphicon glyphicon-pencil"))
										.append("编辑");
								editBtn.attr("edit-id", item.empId);
								var delBtn = $("<button></button>")
										.addClass(
												"btn btn-danger btn-sm delete_btn")
										.append(
												$("<span></span>")
														.addClass(
																"glyphicon glyphicon-trash"))
										.append("删除");
								delBtn.attr("del-id", item.empId);
								var btnTd = $("<td></td>").append(editBtn)
										.append(" ").append(delBtn);

								//append方法执行完成以后还是返回原来的元素
								$("<tr></tr>").append(checkBox).append(empIdTd)
										.append(empNameTd).append(genderTd)
										.append(emailTd).append(deptNameTd)
										.append(btnTd).appendTo(
												"#emps_table tbody");
							})
		}
		//解析分页信息
		function build_page_info(result) {
			//清空
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前" + result.extend.pageInfo.pageNum + "页,总共"
							+ result.extend.pageInfo.pages + "页,共"
							+ result.extend.pageInfo.total + "条记录");
			totalPageNum = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}
		//解析分页条
		function build_page_nav(result) {
			//清空
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");

			//构建元素
			var firstPageLi = $("<li></li>").append(
					$("<a></a>").append("首页").attr("href", "#"))
			var prePageLi = $("<li></li>").append(
					$("<a></a>").append("&laquo;"))
			if (result.extend.pageInfo.hasPreviousPage == false) {
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			} else {
				//为元素添加点击翻页的事件
				firstPageLi.click(function() {
					to_page(1);
				})
				prePageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				})
			}

			var lastPageLi = $("<li></li>").append(
					$("<a></a>").append("末页").attr("href", "#"))
			var nextPageLi = $("<li></li>").append(
					$("<a></a>").append("&raquo;"))
			if (result.extend.pageInfo.hasNextPage == false) {
				lastPageLi.addClass("disabled");
				nextPageLi.addClass("disabled");
			} else {
				//为元素添加点击翻页的事件
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				})
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				})
			}

			//添加首页
			ul.append(firstPageLi).append(prePageLi);
			$.each(result.extend.pageInfo.navigatepageNums, function(index,
					item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				//点击跳转
				numLi.click(function() {
					to_page(item);
				})

				ul.append(numLi);
			});
			//添加页码
			ul.append(nextPageLi).append(lastPageLi);
			//添加末页
			var nav = $("<nav></nav>").append(ul);
			nav.appendTo("#page_nav_area");
		}

		function reset_form(ele) {
			$(ele)[0].reset();
			//清空表单样式
			//$(ele).find("*").removeClass()("has-error has-success");
			$(ele).find(".help-block").text("");
		}

		//点击新增按钮弹出模态框
		$("#emp_add_modal_btn").click(function() {
			//清除表单数据
			reset_form("#empAddModal form");
			//$("#empAddModal form")[0].reset();
			//发送ajax请求，查处部门信息并显示
			getDepts("#empAddModal select");
			//弹出
			$("#empAddModal").modal({
				backdrop : "static"
			});
		})
		//发送ajax并显示
		function getDepts(ele) {
			//清空之前下拉列表的值
			$(ele).empty();
			$.ajax({
				url : "${APP_PATH}/depts",
				type : "GET",
				success : function(result) {
					//console.log(result);
					$.each(result.extend.depts, function() {
						var optionEle = $("<option value></option>").append(
								this.deptName).attr("value", this.deptId);
						optionEle.appendTo(ele)
					});

				}
			})
		}
		//校验表单数据
		function validate_add_form() {
			//获取校验数据,使用正则表达式进行校验
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
			if (!regName.test(empName)) {
				//alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
				show_validate_msg("#empName_add_input", "error",
						"用户名可以是2-5位中文或者6-16位英文和数字的组合1");
				/*$("#empName_add_input").parent().addClass("has-error");
				$("#empName_add_input").next("span").text("用户名可以是2-5位中文或者6-16位英文和数字的组合")*/
				return false;
			} else {
				show_validate_msg("#empName_add_input", "success", "");
			}
			;

			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regEmail.test(email)) {
				//alert("邮箱格式不正确");
				//应该清空之前的样式
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
				/*$("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next("span").text("邮箱格式不正确")*/
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
			}
			;
			return true;
		};

		//显示校验结果的提示信息
		function show_validate_msg(ele, status, msg) {
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if ("success" == status) {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if ("error" == status) {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		$("#emp_save_btn")
				.click(
						function() {
							//1.模态框中填写的表单数据提交给服务器进行保存
							//校验数据
							if (!validate_add_form()) {
								return false;
							}
							if ($(this).attr("ajax-va") == "error") {
								return false;
							}
							//请求保存员工
							$
									.ajax({
										url : "${APP_PATH}/emp",
										type : "POST",
										data : $("#empAddModal form")
												.serialize(),
										success : function(result) {
											//alert(result.msg);
											if (result.code == 100) {
												//员工保存成功；
												//1、关闭模态框
												$("#empAddModal").modal('hide');

												//2、来到最后一页，显示刚才保存的数据
												//发送ajax请求显示最后一页数据即可
												to_page(totalRecord);
											} else {
												//显示失败信息
												//console.log(result);
												//有哪个字段的错误信息就显示哪个字段的；
												if (undefined != result.extend.errorFields.email) {
													//显示邮箱错误信息
													show_validate_msg(
															"#email_add_input",
															"error",
															result.extend.errorFields.email);
												}
												if (undefined != result.extend.errorFields.empName) {
													//显示员工名字的错误信息
													show_validate_msg(
															"#empName_add_input",
															"error",
															result.extend.errorFields.empName);
												}
											}
										}
									})
						})

		//校验用户名是否可用
		$("#empName_add_input").change(
				function() {
					//发送ajax请求校验用户名是否可用
					var empName = this.value;
					$.ajax({
						url : "${APP_PATH}/checkuser",
						data : "empName=" + empName,
						type : "POST",
						success : function(result) {
							if (result.code == 100) {
								show_validate_msg("#empName_add_input",
										"success", "用户名可用");
								$("#emp_save_btn").attr("ajax-va", "success");
							} else {
								show_validate_msg("#empName_add_input",
										"error", result.extend.va_msg);
								$("#emp_save_btn").attr("ajax-va", "error");
							}
						}
					});
				});
		//批量删除

		//单个删除
		$(document).on("click", ".delete_btn", function() {
			//1.弹出是否确认删除对话框,获取员工姓名 delete_btn
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del-id");
			if (confirm("确认删除【" + empName + "】?")) {
				$.ajax({
					url : "${APP_PATH}/emp/" + empId,
					type : "DELETE",
					success : function(result) {
						//alert(restult.msg);
						to_page(currentPage);
					}
				})
			}
		})
		//1、我们是按钮创建之前就绑定了click，所以绑定不上。
		//1）、可以在创建按钮的时候绑定。    2）、绑定点击.live()
		//jquery新版没有live，使用on进行替代
		$(document).on("click", ".edit_btn", function() {
			//alert("edit");

			//1、查出部门信息，并显示部门列表
			getDepts("#empupdateModal select");
			//2、查出员工信息，显示员工信息,根据员工id
			getEmp($(this).attr("edit-id"));

			//3、把员工的id传递给模态框的更新按钮
			$("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
			$("#empupdateModal").modal({
				backdrop : "static"
			});
		});

		function getEmp(id) {
			$.ajax({
				url : "${APP_PATH}/emp/" + id,
				type : "GET",
				success : function(result) {
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_input").val(empData.email);
					$("#empupdateModal input[name=gender]").val(
							[ empData.gender ]);
					$("#empupdateModal select").val([ empData.dId ]);
				}
			})
		}

		//点击更新，更新员工信息
		$("#emp_update_btn").click(function() {
			//验证邮箱是否合法
			var email = $("#email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regEmail.test(email)) {
				show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
				return false;
			} else {
				show_validate_msg("#email_update_input", "success", "");
			}
			;

			//发送ajax，保存更新
			$.ajax({
				//$(this.attr("edit-id"))获取员工id
				url : "${APP_PATH}/emp/" + $(this).attr("edit-id"),
				type : "PUT",
				data : $("#empupdateModal form").serialize(),
				success : function(result) {
					//alert(result.msg);
					$("#empupdateModal").modal("hide");
					to_page(currentPage);
				}
			})
		})
		//全选/不选
		$("#check_all").click(function() {
			//attr获取check是undefined
			//dom原生的属性推荐用prop，attr获取的是自定义属性值
			//prop修改和读取dom原生属性的值
			$(".check_item").prop("checked", $(this).prop("checked"))
		})
		//check_item
		$(document)
				.on(
						"click",
						".check_item",
						function() {
							var flag = $(".check_item:checked").length == $(".check_item").length;
							$("#check_all").prop("checked", flag);
						})

		//点击全部删除
		$("#emp_delete_all_btn").click(
				function() {
					var empNames = "";
					var empIds = "";
					$.each($(".check_item:checked"), function() {
						//获取选取的员工名
						empNames += $(this).parents("tr").find("td:eq(2)")
								.text()
								+ ",";
						//获取员工id
						empIds += $(this).parents("tr").find("td:eq(1)")
						.text()
						+ "-";
					})
					empNames = empNames.substring(0, empNames.length - 1);
					empIds = empIds.substring(0, empIds.length - 1);
					if (confirm("确认删除【" + empNames + "】?")) {
						//发送ajax请求
						$.ajax({
							//$(this.attr("edit-id"))获取员工id
							url : "${APP_PATH}/emp/" + empIds,
							type : "DELETE",
							success : function(result) {
								//alert(result.msg);	
								to_page(currentPage);
							}
						})
					}
				})
	</script>
</body>
</html>