# Web Scraping

# pip install gazpacho
from gazpacho import Soup
from requests import get

url = "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc"
resp = get(url)
imdb = Soup(resp.text)
#imdb.find("h3",{"class" : "lister-item-header"}, mode = "first").strip()
titles = imdb.find("h3",{"class" : "lister-item-header"})
clean_titles = []
for title in titles :
    clean_titles.append(title.strip())

ratings = imdb.find("div", {"class" : "inline-block ratings-imdb-rating"})
ratings = [float(rating.strip()) for rating in ratings]

imdb_movie = pd.DataFrame({
    "title" : clean_titles,
    "rating" : ratings
})

imdb_movie
