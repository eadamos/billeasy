import cgitb
cgitb.enable()
import jwt
import pymysql
import collections
from datetime import datetime, timedelta
import json

def test():
	return "hello!"

def login(post):
    #retrieve POST data
    p=str(post.value).split(",")
    user_name=p[0][14:-1]
    password=p[len(p)-1][12:-2] #bakit ayaw pag p[1]????

    #query database to validate user_name and password
    connection=pymysql.connect(host="joshuabalagapo.mysql.pythonanywhere-services.com", user="joshuabalagapo", passwd="razzaaaa", db="joshuabalagapo$billeasy")
    cur=connection.cursor(pymysql.cursors.DictCursor)
    query="SELECT user_id, given_name, class FROM users WHERE user_name=%s AND password=%s"
    cur.execute(query, (user_name, password))
    results=cur.fetchall()

    response = collections.OrderedDict()

    if len(results)>0:
    	#create JWT token, valid for 10 seconds
    	exp = datetime.utcnow() + timedelta(seconds=10)
    	response['name'] = results[0]["given_name"]

    	if(results[0]["class"]=="admin"):
    		#NOTE: class can be parsed as field in case multiple classes are allowed.
    		response['admin']=1;
    		response['token'] = jwt.encode({'user_name': user_name, 'class': 'admin', 'exp': exp}, 'razza', algorithm='HS256')
    	else:
    		#if regular user, class attribute is hidden
    		response['token'] = jwt.encode({'user_name': user_name, 'exp': exp}, 'razza', algorithm='HS256')

    	response['success']=1
    else:
    	response['success']=0

    return json.dumps(response)

def fetch_bills(get, escape):

    response = collections.OrderedDict()
    response['success']=0

    if 'token' in get:
        token = escape(get['token'][0])

    	try:
    		#decode token
    		payload = jwt.decode(token, 'razza', algorithms=["HS256"])
    		user_name=payload["user_name"]

    		response["bills"]=[]

    		#query for bills
    		connection=pymysql.connect(host="joshuabalagapo.mysql.pythonanywhere-services.com", user="joshuabalagapo", passwd="razzaaaa", db="joshuabalagapo$billeasy")
    		cur=connection.cursor(pymysql.cursors.DictCursor)
    		SELECT="SELECT billers.biller_name, bills.bill_id, bills.billing_date, FORMAT(bills.amount,2) FROM billers"
    		JOIN1=" JOIN bills ON bills.biller_id = billers.biller_id"
    		JOIN2= " JOIN users ON users.user_id = bills.user_id"
    		WHERE= " WHERE user_name=%s AND paid=0"

    		cur.execute(SELECT+JOIN1+JOIN2+WHERE, (user_name))
    		results=cur.fetchall()

    		response['success']=1

    		#build json output
    		for row in results:
    			bill = collections.OrderedDict()
    			bill['bill_id']=row["bill_id"]
    			bill['biller_name']=row["biller_name"]
    			bill['billing_date']=str(row["billing_date"])
    			bill['amount']=row["FORMAT(bills.amount,2)"]

    			response["bills"].append(bill)

    	except(jwt.DecodeError, jwt.ExpiredSignatureError):
    		response["message"]="invalid token" #TODO: proper REST response
    else:
    	response["message"]="malformed request" #TODO: proper REST response

    return json.dumps(response)

def renew_token(get, escape):

    response = collections.OrderedDict()
    response['success']=0

    if 'token' in get:
        token = escape(get['token'][0])

    	try:
    		#decode token
    		payload = jwt.decode(token, 'razza', algorithms=["HS256"])
    		user_name=payload["user_name"]

    		#create JWT token, valid for 10 seconds
    		exp = datetime.utcnow() + timedelta(seconds=10)

    		if "class" in payload and payload["class"]=="admin":
    			response['token'] = jwt.encode({'user_name': user_name, 'class': 'admin', 'exp': exp}, 'razza', algorithm='HS256')
    		else:
    			response['token'] = jwt.encode({'user_name': user_name, 'exp': exp}, 'razza', algorithm='HS256')

    		response['success']=1
    	except(jwt.DecodeError, jwt.ExpiredSignatureError):
    		response["message"]="token invalid" #TODO: proper REST response
    else:
    	response["message"]="malformed request" #TODO: proper REST response

    return json.dumps(response)