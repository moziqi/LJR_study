<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@  include file="/jsp/header.jsp" %>
<div role="dialog" aria-labelledby="myModalLabel"> 
   <div class="modal-dialog"> 
    <div class="modal-content"> 
     <div class="modal-body">
      <form id="add-form-dialog" class="form-horizontal" role="form">
       <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right font" for="name"> 文章标题： </label> 
        <div class="col-sm-9"> 
         <input type="text" id="title" class="col-xs-8"  value="${bean.title }"  <c:if test="${update eq 'update'}">readonly="readonly"</c:if>/><div id="name-tip"></div>
        </div> 
       </div> 
        <div class="form-group">
        <label class="col-sm-3 control-label no-padding-right font" for="name"> 文章内容： </label> 
        <div class="col-sm-9"> 
         <textarea rows="15" cols="29" id="content" >${bean.content }</textarea>
        </div> 
       </div> 
       <div class="form-group"> 
        <label class="col-sm-3 control-label no-padding-right font" for="state">类型： </label> 
        <div class="col-sm-9"> 
          <select class="chosen-select" data-placeholder="请选择" id="typeId"></select>
        </div> 
       </div> 
       <!-- 警告框 -->
       <div id="warning-block"></div>
       <input type="hidden" id="typeId_update" value="${bean.tbSubjectType.id }">
       <input type="hidden" id="update" value="${update }">
       <input type="hidden" id="id" value="${bean.id }">
      </form> 
     </div> 
     <div class="modal-footer"> 
      <button type="button" class="btn btn-primary btn-sm"  id="ok" autocomplete="off"  data-loading-text="正在处理中..." ><i class="icon-ok bigger-110" ></i>确定</button> 
      <button type="button" class="btn btn-success btn-sm" name="backid" id="backid">返回列表</button>
     </div> 
    </div> 
   </div> 
  </div>
</body>
<script>
    $(function () {       
		$('#backid').click(function(){
				window.location.href="jsp/article/index.jsp";
		 });
		
		$("#typeId").empty();
    	$typeId=$("#typeId_update").val();
    	$.ajax({
            type: "get",
            url: "subjecttype/list.html",
            cache:false,
            success: function(data) {
		   		var html = "";
    	    	$.each(data.list, function(i, item) {
    	    		if(parseInt($typeId) == item.id){
        	    		html +="<option value='"+item.id+"' selected='selected'>"+item.name+"</option>";
            	    }else{
    	    			html +="<option value='"+item.id+"' >"+item.name+"</option>";
                	}
    		    });
    	    	$("#typeId").append(html);
    	    	$("#typeId").chosen();
    			$("#typeId_chosen").css("width","130px");
            }
        });
    	
		$("#ok").on('click',function() { //提交事件
			var surl ="article/add";
			var result = JSON.stringify({"title":$("#title").val(),
														"content":$("#content").val(),
														"typeId": $("#typeId").val()
								});
			console.log(result);
			//但是修改的时候
			if("update" == $("#update").val()){
				surl="article/edit";
				result= JSON.stringify({"title":$("#title").val(),
													"content":$("#content").val(),
													"id":$("#id").val(),
													"typeId": $("#typeId").val()
							});
			}
	        $.ajax({
	            type: "POST",
	            url: surl,
	            headers : {
			                'Accept' : 'application/json',
			                'Content-Type' : 'application/json;charset=utf-8'
		         } ,
	            data: result,
	            success: function(data) {
	            	if(data.success == true){
			            $("#warning-block").html('<div class="alert alert-block alert-success">'+
			                    '<button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>'+
			                    '<div class="success bold-center">'+data.msg+',<a href="jsp/classrooms/index.jsp" class="green">'+
			                    '<span id="mysecond" class="green">'+5+
			                    '</span>秒自动跳转</a><div></div>');
		            	 countDown(5, "jsp/article/index.jsp");
			        }
			        else{
					    $("#warning-block").html('<div class="alert alert-block alert-danger">'+
			                    '<button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>'+
			                    '<div class="danger bold-center">'+data.msg+'</div></div>');
				    }
	            },
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	                alert(XMLHttpRequest.status + "-" + XMLHttpRequest.readyState + "-" + textStatus);
	            }
	        });//ajax
 	   });//提交事件
    });
</script>
</html>