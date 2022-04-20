<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <jsp:useBean id="data" class="api.GpsTransfer"/>
    <jsp:setProperty property="*" name="data"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

${data}
<% data.transfer(data, 0); %>
${data}

<script type="text/javascript">

/*======================= date를 형식에 맞게 설정 ==============================*/
var date = new Date();
var year = date.getFullYear();
var month = ("0" + (1 + date.getMonth())).slice(-2); 
var day = ("0" + date.getDate()).slice(-2);
var hours = ("0" + date.getHours()).slice(-2);
var minutes =("0" + date.getMinutes()).slice(-2);

var time = hours + minutes;
var today = year + month + day;

//slice() : 배열을 복사하여 반환, 원본 배열의 수정X
//splice() : 원본 배열을 수정하여 반환
// 위 내용 관련 -> https://im-developer.tistory.com/103
// date 관련 -> https://dororongju.tistory.com/116

// json라이브러리 관련 -> https://bp666.tistory.com/6
/*=========================================================================*/

var xhr = new XMLHttpRequest();
var url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst'; /*초단기실황조회*/
var servicekey="F48VWLxsrGjMjh4xItJOAuKDOvT9Bbq2cgYIOjS9W%2B4ox5t0i78Z4HswmwfFD%2F%2Bj2VdzxpwjwLy5mMWiye2HWw%3D%3D";
var baseDate=today;
var baseTime=time;
var nx= ${data.xLat};
var ny= ${data.yLon};

var queryParams = '?' + encodeURIComponent('serviceKey') + '='+servicekey; /*Service Key*/
queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /*페이지번호*/
queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('1000'); /*한 페이지 결과 수*/
queryParams += '&' + encodeURIComponent('dataType') + '=' + encodeURIComponent('json'); /*데이터타입*/
queryParams += '&' + encodeURIComponent('base_date') + '=' + encodeURIComponent(baseDate); /*발표일자*/
queryParams += '&' + encodeURIComponent('base_time') + '=' + encodeURIComponent(baseTime); /*발표시각*/
queryParams += '&' + encodeURIComponent('nx') + '=' + encodeURIComponent(nx); /*예보지점 x좌표*/
queryParams += '&' + encodeURIComponent('ny') + '=' + encodeURIComponent(ny); /*예보지점 y좌표*/
xhr.open('GET', url + queryParams);
xhr.onreadystatechange = function () {
    if (this.readyState == 4) {
        
    	//json데이터 파싱준비
    	var jsonInfo = JSON.parse(this.responseText);
    	
        for(var i in jsonInfo.response.body.items.item) {//item의 길이(8)만큼 반복
        	
            var category = jsonInfo.response.body.items.item[i].category;
            var value =jsonInfo.response.body.items.item[i].obsrValue;
            
           //카테고리에 맞는 value와 단위를 구분하여 출력
            switch (category) {
			case "T1H":
				console.log("기온 : "+ value +"℃");
				break;
			case "RN1":
				console.log("1시간 강수량 : "+ value +"mm");
				break;
			case "UUU":
				console.log("동서바람 성분 : "+ value +"m/s");
				break;
			case "VVV":
				console.log("남북바람 성분 : "+ value +"m/s");
				break;
			case "REH":
				console.log("습도 : "+ value +"%");
				break;
			case "PTY":
				console.log("강수형태 : "+ value);
				break;
			case "VEC":
				console.log("풍향 : "+ value +"deg");
				break;
			case "WSD":
				console.log("풍속 : "+ value +"m/s");
				break;

			}
          }
        
    }
};

xhr.send('');

/* Status: 200
 * nHeaders: "content-language: ko-KR\r\ncontent-length: 275\r\ncontent-type: application/json;charset=UTF-8\r\n"
 * nBody: {"response":{"header":{"resultCode":"00","resultMsg":"NORMAL_SERVICE"},
 *"body":{"dataType":"JSON","items":
	{"item":[{"baseDate":"20220302","baseTime":"0600","category":"PTY","nx":55,"ny":127,"obsrValue":"0"}, 강수형태
		{"baseDate":"20220302","baseTime":"0600","category":"REH","nx":55,"ny":127,"obsrValue":"73"}, 습도
		{"baseDate":"20220302","baseTime":"0600","category":"RN1","nx":55,"ny":127,"obsrValue":"0"}, 
		{"baseDate":"20220302","baseTime":"0600","category":"T1H","nx":55,"ny":127,"obsrValue":"-3.1"},
		{"baseDate":"20220302","baseTime":"0600","category":"UUU","nx":55,"ny":127,"obsrValue":"-0.6"},
		{"baseDate":"20220302","baseTime":"0600","category":"VEC","nx":55,"ny":127,"obsrValue":"100"},
		{"baseDate":"20220302","baseTime":"0600","category":"VVV","nx":55,"ny":127,"obsrValue":"0.1"},
		{"baseDate":"20220302","baseTime":"0600","category":"WSD","nx":55,"ny":127,"obsrValue":"0.7"}]},
		"pageNo":1,"numOfRows":1000,"totalCount":8}}} 시간 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)*/
</script>
</body>
</html>