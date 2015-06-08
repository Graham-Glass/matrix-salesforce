var loginUsernameTemp = '';
var loginPasswordTemp = '';

window.addEventListener("message", function(event) {
	var data = JSON.parse(event.data);
    receiveExternalMessage(data, event.origin);
});

function receiveExternalMessage(data, origin){
	switch (data.method) {
		case 'logIn':
			if (data.action == 'login') {
				if (loginUsernameTemp.length && loginPasswordTemp.length) {
					var result = sforce.apex.execute("matrixlms.UserUtilities", "updateMatrixCredentials", {
						salesforce_userid: data.salesforce_userid,
						matrix_userid: data.user_id,
						school_id: data.school_id,
						username: loginUsernameTemp,
						password: loginPasswordTemp,
						api_key: data.api_key
					});
				}
			}
			break;
		case 'logOut':
			if (data.action == 'logout') {
				var result = sforce.apex.execute("matrixlms.UserUtilities", "deleteMatrixCredentials", {salesforce_userid: data.salesforce_userid});
			}
			break;
		case 'loginCredentials':
			if (typeof data.username != 'undefined') {
				loginUsernameTemp = data.username;
				loginPasswordTemp = data.password;
			}
			break;
		case 'setSchoolDomain':
			if (data.domain !== '') {
				var schoolDomain = origin.replace('http://', '');
				schoolDomain = schoolDomain.replace('https://', '');
				var result = sforce.apex.execute("matrixlms.UserUtilities", "saveMatrixURL", {salesforce_userid: data.salesforce_userid, portal_url: "https://" + schoolDomain + "/?salesforce=true"});
			}
			break;
    }
}

function addMatrixUser(salesforce_userid){
	if(confirm('Are you sure? This will create a new user in the MATRIX database.')){
		var result = sforce.apex.execute("matrixlms.UserUtilities", "addMatrixUser", {salesforce_userid: salesforce_userid}, {
			onSuccess: function(){
				document.getElementById('addMatrixLink').onclick = '';
				document.getElementById('addMatrixLink').innerHTML = 'Please reload the page.';
			},
			onFailure: function(data){
				alert('Error adding user: '+data);
			}
		});
	}
}

function createCORSRequest(method, url) {
	var xhr = new XMLHttpRequest();
	if ("withCredentials" in xhr) {
		// XHR for Chrome/Firefox/Opera/Safari.
		xhr.open(method, url, true);
	} else if (typeof XDomainRequest != "undefined") {
		// XDomainRequest for IE.
		xhr = new XDomainRequest();
		xhr.open(method, url);
	} else {
		// CORS not supported.
		xhr = null;
	}
	return xhr;
}