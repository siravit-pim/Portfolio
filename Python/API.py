# API
 # Application programming Interface
    # Request - Response cycle
import requests
import time

# main point
url = "https://swapi.dev/api/people/7"
response = requests.get(url)
# response.status_code
result = response.json()
# example select like dictionary
result['name']

# -------------------------
# loop multi ------------------
name = []
height = []
mass = []

for i in range(1,6) : 
    respones = requests.get(f"https://swapi.dev/api/people/{i}")
    #print(f"it's Number : {i}")
    #print(" > " , respones.json()["name"])
    result = respones.json()
    name.append(result["name"])
    height.append(result["height"])
    mass.append(result["mass"])

    time.sleep(0.5) #seconds

df = pd.DataFrame({
    "name":name,
    "height":height,
    "mass":mass
})

df
