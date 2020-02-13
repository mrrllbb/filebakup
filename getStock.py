import requests
import os
import time


os.environ['TZ'] = 'Asia/Shanghai'
f = open("所有股票及代码.txt", 'r')
has_got = False

def get_stock():
    f1 = open(time.strftime('%Y%m%d') + ".txt", 'w')
    flag = 1
    for line in f:
        if line.strip() == "":
            flag = 2
            continue
        else:
            stock_code = line.strip().split('(')[1].split(')')[0]
            stock_id = stock_code + str(flag)
            print(stock_id)

        url = "http://pdfm.eastmoney.com/EM_UBG_PDTI_Fast/api/js"

        querystring = {"rtntype": "5", "id": stock_id, "type": "r", "iscr": "false"}

        headers = {
            'cache-control': "no-cache",
            'postman-token': "e71dfefd-5310-22cb-c7f1-a4e3d858c431"
        }

        response = requests.request("GET", url, headers=headers, params=querystring)
        f1.write(response.text + '\n')

        print(response.text)



while True:
    t = time.localtime()
    print(time.strftime('%Y%m%d'))
    hour = t.tm_hour
    print(hour)
    if hour < 15:
        has_got = False
        time.sleep(3600)
    else:
        if not has_got:
            get_stock()
            has_got = True
        time.sleep(3600)


