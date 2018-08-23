<%@page import="com.ggzy.common.constant.UtilConstant"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<title>电力DHCP项目-登录</title>
<link href="<%=basePath%>resources/css/page/login2.css" rel="stylesheet"
	type="text/css">
<script src="<%=basePath%>resources/js/jquery/jquery-1.8.1.min.js"></script>
<script src="<%=basePath%>resources/js/core/json2.js"></script>
<script src="<%=basePath%>resources/js/core/common2.js"></script>
<script src="<%=basePath%>resources/js/rsa.js"></script>
<script src="<%=basePath%>resources/js/SHA-512.js"></script>
<style type="text/css">

 .message1
{    
    position:absolute;
    bottom:272px;
    left:140px;
    color:red;
    font-weight:bold;
}
</style>
<script type="text/javascript">
		var basePath = "<%=basePath%>";
		window.history.forward(-1); //禁止浏览器的前进与后退
		$(function() {
			//登录操作
			$("#login").click(function() {
			   var conSpe = RegExp(/[(\~)(\!)(\@)(\#)(\$)(\%)(\^)(\&)(\*)(\()(\))(\-)(\_)(\+)(\=)(\[)(\])(\{)(\})(\|)(\\)(\;)(\:)(\')(\")(\,)(\.)(\/)(\<)(\>)(\?)]+/);
				if($("#usn").val()==null||$("#usn").val()==""){
				   $("#msgBox").html("<font color='red'>用户名不能为空！</font>");
				   return;
				}
				if(conSpe.test($("#usn").val())){
					$("#msgBox").html("<font color='red'>用户名不符合规范</font>");
					return;
				}
				if($("#usn").val()==null||$("#usn").val()==""){
				   $("#msgBox").html("<font color='red'>密码不能为空！</font>");
				   return;
				}
			 	/* if(!/(?=.*[a-z])(?=.*\d)(?=.*[#@!~%^&*.?])[a-z\d#@!~%^&*.?]/i.test($("#usn").val())){
					$("#msgBox").html("<font color='red'>密码不符合规范</font>");
					return;
				} */ 
				/* if($("#randomCode").val()==null||$("#randomCode").val()==""){
				   $("#msgBox").html("<font color='red'>验证码不能为空！</font>");
				   return;
				} */
			    login();
			});
			
			/**
			  * 登陆
			 **/	
			function login(){
			var value=$("#usn").val()+"&&"+$("#usp").val();
			
			getPublicKeys();//获取公钥
			var miyao = $("#publicKey").val();
	        var cipherText =RSA(value);//传输加密
	        var jmData=sha512(value);
	        var firstjm = jmData.substring(0, 64);
	        var lastjm = jmData.substring(64);
	        var firstData = RSA(firstjm);
	        var lastData = RSA(lastjm);
	        var datas = cipherText;
				//提交用户名密码
				$.ajax({
			 		type: "POST",
			 		async:false, 
			 		cache:false,
			 		dataType: 'json',
			 		data:{
			 			data:datas,
			 			firstData:firstData,
			 			lastData:lastData,
			 			publicKey:$("#publicKey").val(),
						randomCode:$("#randomCode").val()
			 		},
			 		url: '<%=basePath%>sysUser/loginSysUser.do',
			 		success:function(data){
			 			if (data.code == '0') {
							$("#msgBox").html("<font color='red'>"+data.message+"</font>");
							refresh();
						} else {
							window.location.href = data.url;
						}
			 		},
			 		error : function(xhr, status, errMsg) {
			 			refresh();
			 			$("body").diglog({
							type : 'error',
							content : '登陆失败！'+errMsg
						});
						
					}
				});
			}
			
			//取消按钮事件
			$("#clear").click(function() {
				$("#usn").val("");
				$("#usn").val("");
			});
			//enter事件
			document.onkeydown = function(event) {
				var e = event || window.event || arguments.callee.caller.arguments[0];
				if (e && e.keyCode == 13) { // enter 键
					$("#login").click();
				}
			};
			
			
			if(self.frameElement&&self.frameElement.tagName=="IFRAME"){
				window.parent.location.href = "<%=basePath%>loginSys.jsp";
			}
			
			
		});
		
		function refresh() {
	        $("#randcodeImg")[0].src = "<%=basePath%>sysUser/getRandcode.do?"+Math.random();
	    }
	    function cleanMsg() {
	        $("#msgBox").html("");
	    }
	    
	    //获取公钥
	    function getPublicKeys(){
			$.ajax({
				url : basePath + "sysUser/queryPublicKey.do",
				type: "POST",
		 		async:false, 
		 		cache:false,
				success : function(result){
		             $("#publicKey").val(result);
				}
			});
		};   
	</script>
</head>
<body class="bj">
<input type="hidden" id="publicKey" value=""> 
	<div class="main">
		<div class="left"></div>
		<div class="right">
			<div class="message1" id="msgBox"></div>
			<div class="form">
				<input type="text" id="usn" placeholder="用户名" class="txt txt1" /><br />
				<input type="password" id="usp" placeholder="密码"
					class="txt txt2" /><br />  <input type="text" placeholder="验证码"
					id="randomCode" class="txt3"> <img id="randcodeImg"
					title="点击更换" class="input_btn" width="125px"
					style="border: 1px  #EFEFEF;vertical-align:middle"
					onclick="javascript:refresh();"
					src="<%=basePath%>sysUser/getRandcode.do" /><br />  
				<input type="button" value="登录" id="login" class="btn" />
			</div>
		</div>
	</div>
</body>
</html>