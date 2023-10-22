import http.client
#https://apiportal.bot.or.th/
conn = http.client.HTTPSConnection("apigw1.bot.or.th")

Client_ID = ""
start_period = "2023-10-10"
end_period = "2023-10-10"
Curr = 'USD'

headers = { 'X-IBM-Client-Id': Client_ID }

endpoint = f"/bot/public/Stat-ExchangeRate/v2/DAILY_AVG_EXG_RATE/?start_period={start_period}&end_period={end_period}&currency={Curr}"
conn.request("GET", endpoint, headers=headers)

res = conn.getresponse()
data = res.read()

if res.status == 200:
    data = eval(data.decode("utf-8"))['result']['data']['data_detail']
    for i in data:
        data = [
           i['currency_id'],i['period'], i['buying_sight'],i['buying_transfer'],i['selling'],i['mid_rate'] 
        ]
        print(data)
        print(type(data))
    
else:
    print(f"Failed to retrieve data. Status code: {res.status}")
